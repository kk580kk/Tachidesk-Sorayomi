import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../../widgets/emoticons.dart';
import '../controllers/reader_controller.dart';

class SingleHorizontalRTL extends StatelessWidget {
  SingleHorizontalRTL.asFunction({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ReaderController controller;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.arrowRight): PreviousScroll(),
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): NextScroll(),
      },
      child: Actions(
        actions: {
          PreviousScroll: CallbackAction<PreviousScroll>(
            onInvoke: (intent) => pageController.animateToPage(
                (pageController.page!).toInt() - 1,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease),
          ),
          NextScroll: CallbackAction<NextScroll>(
            onInvoke: (intent) => pageController.animateToPage(
                (pageController.page!).toInt() + 1,
                duration: Duration(milliseconds: 500),
                curve: Curves.ease),
          ),
        },
        child: Focus(
          autofocus: true,
          child: PageView.builder(
            controller: pageController,
            itemCount: controller.chapter.pageCount,
            reverse: true,
            itemBuilder: (context, index) {
              if (index == (controller.chapter.pageCount! - 1)) {
                controller.markAsRead();
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl: controller.getChapterPage(index),
                    filterQuality: FilterQuality.medium,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SizedBox(
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
                          text: LocaleKeys.no.tr +
                              " " +
                              LocaleKeys.readerScreen_image.tr,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
