import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/emoticons.dart';
import '../../../widgets/manga_grid_design.dart';
import '../controllers/library_controller.dart';

class LibraryView extends GetView<LibraryController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: controller.categoryListLength,
        animationDuration: Duration(),
        initialIndex: controller.tabIndex.value,
        child: Scaffold(
          appBar: controller.categoryListLength <= 1
              ? null
              : TabBar(
                  onTap: (value) {
                    controller.tabIndex.value = value;
                    controller.loadMangaListWithCategoryId();
                  },
                  padding: EdgeInsets.all(8),
                  isScrollable: context.width > 600 ? true : false,
                  labelColor: context.theme.indicatorColor,
                  unselectedLabelColor: context.textTheme.bodyText1!.color,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: context.theme.indicatorColor.withOpacity(.3),
                  ),
                  tabs: controller.categoryList
                      .map<Tab>((e) => Tab(text: e?.name ?? ""))
                      .toList(),
                ),
          body: Obx(
            () => controller.categoryListLength >= 1
                ? TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: controller.categoryList.map<Widget>(
                      (e) {
                        return Obx(
                          () => controller.mangaListLength != 0
                              ? Scrollbar(
                                  thumbVisibility: true,
                                  controller: controller.scrollController,
                                  child: GridView.builder(
                                    controller: controller.scrollController,
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 250,
                                      crossAxisSpacing: 2.0,
                                      mainAxisSpacing: 2.0,
                                      childAspectRatio: 0.7,
                                    ),
                                    itemCount: controller.mangaListLength,
                                    itemBuilder: (context, index) =>
                                        MangaGridDesign(
                                      manga: controller.mangaList[index],
                                      onTap: () => Get.toNamed(
                                        Routes.manga +
                                            "/${controller.mangaList[index].id}",
                                      ),
                                      isLibraryScreen: true,
                                    ),
                                  ),
                                )
                              : (controller.isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : EmoticonsView(
                                      emptyType:
                                          LocaleKeys.libraryScreen_manga.tr,
                                      button: TextButton.icon(
                                        onPressed: () => controller
                                            .loadMangaListWithCategoryId(),
                                        style: TextButton.styleFrom(),
                                        icon: Icon(Icons.refresh),
                                        label: Text(
                                          LocaleKeys.libraryScreen_refresh.tr,
                                        ),
                                      ),
                                    )),
                        );
                      },
                    ).toList(),
                  )
                : (controller.isCategoryLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : EmoticonsView(
                        emptyType: LocaleKeys.libraryScreen_manga.tr,
                        button: TextButton.icon(
                          onPressed: () => controller.refreshLibraryScreen(),
                          style: TextButton.styleFrom(),
                          icon: Icon(Icons.refresh),
                          label: Text(
                            LocaleKeys.libraryScreen_refresh.tr,
                          ),
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
