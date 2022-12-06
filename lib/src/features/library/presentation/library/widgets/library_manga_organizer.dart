// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../i18n/locale_keys.g.dart';
import 'library_manga_display.dart';
import 'library_manga_filter.dart';
import 'library_manga_sort.dart';

class LibraryMangaOrganizer extends StatelessWidget {
  const LibraryMangaOrganizer({
    super.key,
    /* required this.controller */
  });
  // final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          tabs: [
            Tab(text: LocaleKeys.filter.tr()),
            Tab(text: LocaleKeys.sort.tr()),
            Tab(text: LocaleKeys.display.tr()),
          ],
        ),
        body: const TabBarView(
          children: [
            LibraryMangaFilter(),
            LibraryMangaSort(),
            LibraryMangaDisplay(),
          ],
        ),
      ),
    );
  }
}
