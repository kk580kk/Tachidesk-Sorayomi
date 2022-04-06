import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../generated/locales.g.dart';
import '../data/enums/auth_type.dart';
import '../data/manga_model.dart';
import '../data/services/local_storage_service.dart';

class MangaGridDesign extends StatelessWidget {
  const MangaGridDesign({
    Key? key,
    required this.manga,
    this.isLibraryScreen = false,
    this.onTap,
    this.onDoubleTap,
  }) : super(key: key);
  final Manga manga;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final bool isLibraryScreen;
  @override
  Widget build(BuildContext context) {
    LocalStorageService localStorageService = Get.find<LocalStorageService>();
    return InkResponse(
      onTap: onTap,
      onDoubleTap: () {},
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: GridTile(
          header: !isLibraryScreen
              ? manga.inLibrary ?? false
                  ? Row(
                      children: [
                        Card(
                          color: Get.theme.colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2.0,
                              horizontal: 4.0,
                            ),
                            child: Text(
                              LocaleKeys.mangaGridDesign_inLibrary.tr,
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null
              : Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    (manga.unreadCount ?? 0) != 0
                        ? Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(5),
                                right: (manga.downloadCount ?? 0) == 0
                                    ? Radius.circular(5)
                                    : Radius.zero,
                              ),
                            ),
                            color: Get.theme.colorScheme.primary,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 4.0,
                              ),
                              child: Text(
                                "${manga.unreadCount}",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    (manga.downloadCount ?? 0) != 0
                        ? Card(
                            margin: EdgeInsets.zero,
                            color: Get.theme.colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(5),
                                left: (manga.unreadCount ?? 0) == 0
                                    ? Radius.circular(5)
                                    : Radius.zero,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 4.0,
                              ),
                              child: Text(
                                "${manga.downloadCount}",
                                style: TextStyle(
                                  color: Get.theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ]),
                ),
          child: manga.thumbnailUrl != null && manga.thumbnailUrl!.isNotEmpty
              ? Container(
                  child: CachedNetworkImage(
                    imageUrl: localStorageService.baseURL +
                        manga.thumbnailUrl.toString(),
                    fit: BoxFit.cover,
                    httpHeaders:
                        localStorageService.baseAuthType == AuthType.basic
                            ? {
                                "Authorization": localStorageService.basicAuth,
                              }
                            : null,
                    errorWidget: (context, error, stackTrace) => SizedBox(
                      height: context.height * .3,
                      child: Center(
                        child: Icon(
                          Icons.book_rounded,
                          color: Colors.grey,
                          size: context.height * .1,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (BuildContext context, _,
                        DownloadProgress? loadingProgress) {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress?.progress,
                        ),
                      );
                    },
                  ),
                  foregroundDecoration: BoxDecoration(
                    border: Border.all(
                      width: 0,
                      color: Get.theme.canvasColor,
                    ),
                    boxShadow: !isLibraryScreen && (manga.inLibrary ?? false)
                        ? [
                            BoxShadow(
                                color: Get.theme.canvasColor.withOpacity(.5))
                          ]
                        : null,
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Get.theme.canvasColor.withOpacity(0),
                        Get.theme.canvasColor.withOpacity(0.4),
                        Get.theme.canvasColor.withOpacity(0.9),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: context.height * .3,
                  child: Icon(
                    Icons.book_rounded,
                    color: Colors.grey,
                    size: context.height * .2,
                  ),
                ),
          footer: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            dense: true,
            title: Text(
              (manga.title ?? manga.author ?? ""),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
