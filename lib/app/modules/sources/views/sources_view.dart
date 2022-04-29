import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../core/utils/language.dart';
import '../../../core/values/api_url.dart';
import '../../../data/enums/auth_type.dart';
import '../../../data/source_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/emoticons.dart';
import '../controllers/sources_controller.dart';

class SourcesView extends GetView<SourcesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.groupByMap.keys.isNotEmpty
            ? ListView.builder(
                itemCount: controller.groupByMap.keys.length,
                itemBuilder: (context, index) {
                  final currentKey = controller.groupByLanguageList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        key: Key(currentKey.toString()),
                        child: ListTile(
                          title: Text(currentKey.nativeName),
                        ),
                      ),
                      ...mapIndexed(
                        controller.groupByMap[currentKey]?.reversed,
                        (iterator, Source source) {
                          return Container(
                            key: Key(
                                '$currentKey-${source.toString()}-$iterator'),
                            child: ListTile(
                              onTap: (() async {
                                await controller.localStorageService
                                    .setLastUsed(source.id);
                                Get.toNamed(
                                  "${Routes.sourceManga}/${source.id}/popular",
                                );
                              }),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.localStorageService.baseURL +
                                          (source.iconUrl ?? ""),
                                  height: 48,
                                  httpHeaders: controller.localStorageService
                                              .baseAuthType ==
                                          AuthType.basic
                                      ? {
                                          "Authorization": controller
                                              .localStorageService.basicAuth,
                                        }
                                      : null,
                                  width: 48,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, error, stackTrace) =>
                                      Image.asset(iconPngURL),
                                ),
                              ),
                              title:
                                  Text(source.displayName ?? source.name ?? ""),
                              subtitle: Text(
                                  langCodeToName(source.lang ?? "").nativeName),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (source.supportsLatest ?? false) ...[
                                    TextButton(
                                      onPressed: () async {
                                        await controller.localStorageService
                                            .setLastUsed(source.id);
                                        Get.toNamed("${Routes.sourceManga}"
                                            "/${source.id}/latest");
                                      },
                                      child: Text(
                                        LocaleKeys.sourceScreen_latest.tr,
                                      ),
                                    )
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              )
            : controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : EmoticonsView(
                    text: "${LocaleKeys.no.tr} "
                        "${LocaleKeys.sourceScreen_extensions.tr}",
                    button: TextButton(
                      child: Text(LocaleKeys.sourceScreen_reload.tr),
                      onPressed: () => controller.updateSourceList(),
                    ),
                  ),
      ),
    );
  }
}

Iterable<E> mapIndexed<E, T>(
    Iterable<T>? items, E Function(int index, T item) f) sync* {
  var index = 0;
  if (items == null) return;
  for (final item in items) {
    yield f(index, item);
    index = index + 1;
  }
}

// GroupedListView(
//             padding: EdgeInsets.all(8),
//             elements: controller.sourceList,
//             groupHeaderBuilder: (Source element) => ListTile(
//               title: Text(langCodeToName(element.lang ?? "").nativeName),
//             ),
//             groupBy: (Source source) => source.lang!,
//             groupComparator: (String l1, String l2) => langSortCmp(l1, l2),
//             itemComparator: (Source e1, Source e2) =>
//                 e1.name!.compareTo(e2.name!),
//             itemBuilder: (context, Source source) {
//               return ListTile(
//                 leading: ClipRRect(
//                   borderRadius: BorderRadius.circular(10),
//                   child: Image.network(
//                     controller.localStorageService.baseURL +
//                         (source.iconUrl ?? ""),
//                     height: 48,
//                     width: 48,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                         Image.asset(logoURL),
//                   ),
//                 ),
//                 title: Text(source.displayName ?? source.name ?? ""),
//                 subtitle: Text(langCodeToName(source.lang ?? "").nativeName),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextButton(
//                       onPressed: () {},
//                       child: Text(
//                         LocaleKeys.sourceScreen_latest.tr,
//                         style: TextStyle(
//                           color: context.theme.indicatorColor,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
