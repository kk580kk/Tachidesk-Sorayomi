// Copyright (c) 2022 Contributors to the Suwayomi project
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../constants/app_sizes.dart';
import '../../../../i18n/locale_keys.g.dart';
import '../../../../utils/extensions/custom_extensions.dart';
import '../../../../widgets/emoticons.dart';
import '../../../../widgets/search_field.dart';
import '../../domain/source/source_model.dart';
import '../source/controller/source_controller.dart';
import 'widgets/source_quick_search.dart';

class GlobalSearchScreen extends HookConsumerWidget {
  const GlobalSearchScreen({super.key, this.initialQuery});
  final String? initialQuery;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourceMapData = ref.watch(sourceMapFilteredProvider);
    final sourceMap = {...?sourceMapData.valueOrNull}..remove("lastUsed");
    final sourceList = sourceMap.values.fold(
        <Source>[], (previousValue, element) => [...previousValue, ...element]);
    final query = useState(initialQuery);
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.globalSearch.tr()),
        bottom: PreferredSize(
          preferredSize: kCalculateAppBarBottomSize([true]),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: SearchField(
                  initialText: query.value,
                  onSubmitted: (value) => query.value = value,
                  // hintText: LocaleKeys.searchGlobally.tr(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: sourceMapData.showUiWhenData(
        (data) => sourceList.isBlank
            ? Emoticons(
                text: LocaleKeys.noSourcesFound.tr(),
                button: TextButton(
                  onPressed: () => ref.invalidate(sourceListProvider),
                  child: Text(LocaleKeys.refresh.tr()),
                ),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  if (sourceList[index].id == null) {
                    return const SizedBox.shrink();
                  } else {
                    return SourceQuickSearch(
                      sourceId: sourceList[index].id!,
                      query: query.value,
                    );
                  }
                },
                itemCount: data!.length,
              ),
      ),
    );
  }
}
