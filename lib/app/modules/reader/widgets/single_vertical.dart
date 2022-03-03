import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../widgets/emoticons.dart';
import '../controllers/reader_controller.dart';

class SingleVertical extends StatelessWidget {
  SingleVertical({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ReaderController controller;

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          child: PageView.builder(
            itemCount: controller.chapter.pageCount,
            controller: pageController,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (index == (controller.chapter.pageCount! - 1)) {
                controller.markAsRead();
              }
              return InteractiveViewer(
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  imageUrl: controller.getChapterPage(index),
                  filterQuality: FilterQuality.medium,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      SizedBox(
                    height: context.height,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => SizedBox(
                    height: context.height,
                    child: Center(
                      child: EmoticonsView(
                        emptyType: LocaleKeys.readerScreen_image.tr,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                pageController.animateToPage((pageController.page!).toInt() - 1,
                    duration: Duration(seconds: 1), curve: Curves.ease);
              },
              child: Container(
                height: context.height * .2,
              ),
            ),
            InkWell(
              onTap: () {
                pageController.animateToPage((pageController.page!).toInt() + 1,
                    duration: Duration(seconds: 1), curve: Curves.ease);
              },
              child: Container(
                height: context.height * .2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
