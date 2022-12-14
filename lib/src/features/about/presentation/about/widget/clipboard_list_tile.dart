// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../i18n/locale_keys.g.dart';
import '../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../utils/misc/toast/toast.dart';

class ClipboardListTile extends ConsumerWidget {
  const ClipboardListTile({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String? subtitle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isNotBlank ? Text(subtitle!) : null,
      onTap: subtitle.isNotBlank
          ? () {
              final msg = "$title: $subtitle";
              Clipboard.setData(
                ClipboardData(text: msg),
              );
              ref.read(toastProvider(context)).instantShow(
                    LocaleKeys.copyMsg.tr(namedArgs: {"msg": msg}),
                  );
            }
          : null,
    );
  }
}
