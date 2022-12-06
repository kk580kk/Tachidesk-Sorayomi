// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../constants/app_sizes.dart';
import '../../../../../../constants/db_keys.dart';
import '../../../../../../i18n/locale_keys.g.dart';
import '../../../../../../utils/extensions/custom_extensions.dart';
import '../../../../../../utils/storage/local/shared_preferences_client.dart';
import '../../../../../../widgets/pop_button.dart';

part 'credentials_popup.g.dart';

@riverpod
class Credentials extends _$Credentials with SharedPreferenceClient<String> {
  @override
  String? build() => initialize(
        ref,
        client: ref.watch(sharedPreferencesProvider),
        key: DBKeys.basicCredentials.name,
        initial: DBKeys.basicCredentials.initial,
      );
}

final formKey = GlobalKey<FormState>();

class CredentialsPopup extends HookConsumerWidget {
  const CredentialsPopup({super.key});

  String _basicAuth({
    required String userName,
    required String password,
  }) =>
      'Basic ${base64.encode(
        utf8.encode('$userName:$password'),
      )}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final username = useTextEditingController();
    final password = useTextEditingController();
    return AlertDialog(
      title: Text(LocaleKeys.credentials.tr()),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: username,
              validator: (value) =>
                  value.isBlank ? LocaleKeys.error_userName.tr() : null,
              decoration: InputDecoration(
                hintText: LocaleKeys.userName.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            KSizedBox.h4.size,
            TextFormField(
              controller: password,
              validator: (value) =>
                  value.isBlank ? LocaleKeys.error_password.tr() : null,
              obscureText: true,
              decoration: InputDecoration(
                hintText: LocaleKeys.password.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        const PopButton(),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              ref.read(credentialsProvider.notifier).update(
                    _basicAuth(
                      userName: username.text,
                      password: password.text,
                    ),
                  );
              context.pop();
            }
          },
          child: Text(LocaleKeys.save.tr()),
        ),
      ],
    );
  }
}
