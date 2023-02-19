// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../constants/db_keys.dart';
import '../../../../../../constants/enum.dart';

import '../../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../../utils/storage/local/shared_preferences_client.dart';
import '../../../../../../widgets/radio_list_popup.dart';

part 'reader_mode_tile.g.dart';

@riverpod
class ReaderModeKey extends _$ReaderModeKey
    with SharedPreferenceEnumClient<ReaderMode> {
  @override
  ReaderMode? build() => initialize(
        ref,
        initial: DBKeys.readerMode.initial,
        key: DBKeys.readerMode.name,
        enumList: ReaderMode.values,
      );
}

class ReaderModeTile extends ConsumerWidget {
  const ReaderModeTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readerMode = ref.watch(readerModeKeyProvider);
    return ListTile(
      leading: const Icon(Icons.app_settings_alt_rounded),
      subtitle: readerMode != null ? Text(readerMode.toLocale(context)) : null,
      title: Text(context.l10n!.readerMode),
      onTap: () => showDialog(
        context: context,
        builder: (context) => RadioListPopup<ReaderMode>(
          title: context.l10n!.readerMode,
          optionList: ReaderMode.values.sublist(1),
          optionDisplayName: (value) => value.toLocale(context),
          value: readerMode ?? ReaderMode.webtoon,
          onChange: (enumValue) async {
            ref.read(readerModeKeyProvider.notifier).update(enumValue);
            if (context.mounted) context.pop();
          },
        ),
      ),
    );
  }
}
