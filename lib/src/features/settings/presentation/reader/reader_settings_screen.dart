// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/locale_keys.g.dart';
import 'widgets/reader_invert_tap_tile/reader_invert_tap_tile.dart';
import 'widgets/reader_mode_tile/reader_mode_tile.dart';
import 'widgets/reader_navigation_layout_tile/reader_navigation_layout_tile.dart';

class ReaderSettingsScreen extends StatelessWidget {
  const ReaderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.reader.tr()),
      ),
      body: ListView(
        children: const [
          ReaderModeTile(),
          ReaderNavigationLayoutTile(),
          ReaderInvertTapTile(),
        ],
      ),
    );
  }
}
