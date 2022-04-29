import 'package:flutter/material.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import '../../../core/values/db_keys.dart';
import '../../../data/chapter_model.dart';
import '../../../data/enums/reader_mode.dart';
import '../../../data/enums/reader_navigation_layout.dart';
import '../../../data/manga_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../routes/app_pages.dart';
import '../repository/reader_repository.dart';
import '../widgets/reader_modes/continuous_horizontal_ltr.dart';
import '../widgets/reader_modes/continuous_horizontal_rtl.dart';
import '../widgets/reader_modes/continuous_vertical.dart';
import '../widgets/reader_modes/single_horizontal_ltr.dart';
import '../widgets/reader_modes/single_horizontal_rtl.dart';
import '../widgets/reader_modes/single_vertical.dart';
import '../widgets/reader_modes/webtoon.dart';
import '../widgets/reader_navigation_layout/edge.dart';
import '../widgets/reader_navigation_layout/kindlish.dart';
import '../widgets/reader_navigation_layout/l_shaped.dart';
import '../widgets/reader_navigation_layout/right_and_left.dart';

class NextScrollIntent extends Intent {}

class PreviousScrollIntent extends Intent {}

class ReaderController extends GetxController {
  void Function()? previousScroll;
  void Function()? nextScroll;
  var readerScaffoldKey = GlobalKey<ScaffoldState>();
  final ReaderRepository repository = ReaderRepository();
  final CacheManager cacheManager = DefaultCacheManager();
  late final int mangaId;
  late final int chapterIndex;
  final Rx<Manga> _manga = Manga().obs;
  Manga get manga => _manga.value;
  set manga(Manga value) => _manga.value = value;

  final Rx<Chapter> _chapter = Chapter().obs;
  Chapter get chapter => _chapter.value;
  set chapter(Chapter value) => _chapter.value = value;

  final LocalStorageService localStorageService =
      Get.find<LocalStorageService>();

  final Rx<ReaderMode> _readerMode = ReaderMode.defaultReader.obs;
  ReaderMode get readerMode => _readerMode.value;
  set readerMode(ReaderMode value) => _readerMode.value = value;

  final Rx<ReaderNavigationLayout> _readerNavigationLayout =
      ReaderNavigationLayout.disabled.obs;
  ReaderNavigationLayout get readerNavigationLayout =>
      _readerNavigationLayout.value;
  set readerNavigationLayout(ReaderNavigationLayout value) =>
      _readerNavigationLayout.value = value;

  final RxBool _readerNavigationLayoutInvert = false.obs;
  bool get readerNavigationLayoutInvert => _readerNavigationLayoutInvert.value;
  set readerNavigationLayoutInvert(bool value) =>
      _readerNavigationLayoutInvert.value = value;

  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;
  set currentIndex(int value) => _currentIndex.value = value;

  final RxInt sliderValue = 0.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final RxBool _isDataLoading = false.obs;
  bool get isDataLoading => _isDataLoading.value;
  set isDataLoading(bool value) => _isDataLoading.value = value;

  final RxBool _visibility = false.obs;
  bool get visibility => _visibility.value;
  void toggleVisibility() => _visibility.value = !_visibility.value;

  final RxBool _expandedState = false.obs;
  bool get expandedState => _expandedState.value;
  set expandedState(bool value) => _expandedState.value = value;

  void Function(int)? sliderJumpTo;

  String getChapterPage(int page) => repository.getChapterPage(
        mangaId: mangaId,
        chapterIndex: chapterIndex,
        page: page,
      );

  final Map<ReaderMode, Function> readerModeMap = {
    ReaderMode.continuousHorizontalLTR: ContinuousHorizontalLTR.asFunction,
    ReaderMode.continuousHorizontalRTL: ContinuousHorizontalRTL.asFunction,
    ReaderMode.continuousVertical: ContinuousVertical.asFunction,
    ReaderMode.singleHorizontalLTR: SingleHorizontalLTR.asFunction,
    ReaderMode.singleHorizontalRTL: SingleHorizontalRTL.asFunction,
    ReaderMode.singleVertical: SingleVertical.asFunction,
    ReaderMode.webtoon: Webtoon.asFunction,
  };

  final Map<ReaderNavigationLayout, Function> readerNavigationLayoutMap = {
    ReaderNavigationLayout.edge: Edge.asFunction,
    ReaderNavigationLayout.kindlish: Kindlish.asFunction,
    ReaderNavigationLayout.lShaped: LShaped.asFunction,
    ReaderNavigationLayout.rightAndLeft: RightAndLeft.asFunction,
  };

  Future<void> modifyChapter(String key, dynamic value) async {
    Map<String, dynamic> formData = {key: value};
    await repository.patchChapter(chapter, formData);
    await reloadChapter();
  }

  @override
  void onInit() {
    mangaId = int.parse(Get.parameters["mangaId"]!);
    chapterIndex = int.parse(Get.parameters["chapterIndex"]!);
    sliderValue.listen((index) {
      if (sliderJumpTo != null) sliderJumpTo!(index);
    });
    super.onInit();
  }

  void nextChapter() {
    if ((chapter.index ?? 1) < (chapter.chapterCount ?? 1)) {
      repository.patchChapter(chapter, {
        "lastPageRead": chapter.pageCount! - 1,
        "read": true,
      });
    }
    Get.offNamed(
        "${Routes.manga}/${chapter.mangaId}/chapter/${chapter.index! + 1}");
  }

  void changeReaderMode(ReaderMode? readerMode) async {
    this.readerMode = readerMode ?? this.readerMode;
    currentIndex = 0;
    await repository.patchMangaMeta(
      manga,
      MapEntry(
        readerModeKey,
        this.readerMode.name,
      ),
    );
  }

  void changeReaderNavigationLayout(
      ReaderNavigationLayout? readerNavigationLayout) async {
    this.readerNavigationLayout =
        readerNavigationLayout ?? this.readerNavigationLayout;
    await repository.patchMangaMeta(
      manga,
      MapEntry(
        readerNavigationLayoutKey,
        this.readerNavigationLayout.name,
      ),
    );
  }

  void changeReaderNavigationLayoutInvert(
      bool? readerNavigationLayoutInvert) async {
    this.readerNavigationLayoutInvert =
        readerNavigationLayoutInvert ?? this.readerNavigationLayoutInvert;
    await repository.patchMangaMeta(
      manga,
      MapEntry(
        readerNavigationLayoutInvertKey,
        this.readerNavigationLayoutInvert.toString(),
      ),
    );
  }

  Future<void> markAsRead() async {
    Map<String, dynamic> formData = {"read": true, "lastPageRead": "1"};
    await repository.patchChapter(chapter, formData);
  }

  void prevChapter() {
    if ((chapter.index ?? 0) > 1) {
      Get.offNamed(
          "${Routes.manga}/${chapter.mangaId}/chapter/${chapter.index! - 1}");
    }
  }

  Future<void> reloadChapter() async {
    final tempChapter = await repository.getChapter(
      mangaId: mangaId,
      chapterIndex: chapterIndex,
    );
    if (tempChapter != null) chapter = tempChapter;
  }

  Future<void> reloadReader() async {
    isLoading = true;
    await reloadChapter();
    manga = (await repository.getManga(mangaId)) ?? manga;
    readerMode = (manga.meta?[readerModeKey] != null
        ? readerModeFromString(manga.meta![readerModeKey])
        : readerMode);
    readerNavigationLayout = (manga.meta?[readerNavigationLayoutKey] != null
        ? readerNavigationLayoutFromString(
            manga.meta![readerNavigationLayoutKey])
        : localStorageService.readerNavigationLayout);
    readerNavigationLayoutInvert =
        (manga.meta?[readerNavigationLayoutInvertKey] != null
            ? (manga.meta![readerNavigationLayoutInvertKey].toLowerCase() ==
                'true')
            : localStorageService.readerNavigationLayoutInvert);

    isDataLoading = true;
    isLoading = false;
  }

  @override
  void onReady() async {
    await reloadReader();
    super.onReady();
  }

  @override
  void onClose() {}
}
