// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../constants/db_keys.dart';
import '../../../../../../i18n/locale_keys.g.dart';
import '../../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../../utils/storage/local/shared_preferences_client.dart';

part 'reader_invert_tap_tile.g.dart';

@riverpod
class InvertTap extends _$InvertTap with SharedPreferenceClient<bool> {
  @override
  bool? build() => initialize(
        ref,
        key: DBKeys.invertTap.name,
        initial: DBKeys.invertTap.initial,
      );
}

class ReaderInvertTapTile extends HookConsumerWidget {
  const ReaderInvertTapTile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SwitchListTile(
      controlAffinity: ListTileControlAffinity.trailing,
      secondary: const Icon(Icons.switch_left_rounded),
      title: Text(
        LocaleKeys.readerNavigationLayoutInvert.tr(),
      ),
      onChanged: ref.read(invertTapProvider.notifier).update,
      value: ref.watch(invertTapProvider).ifNull(),
    );
  }
}
