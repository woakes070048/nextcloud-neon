import 'package:neon/l10n/localizations.dart';
import 'package:neon/src/models/label_builder.dart';
import 'package:sort_box/sort_box.dart';

final sortBoxOrderOptionValues = <SortBoxOrder, LabelBuilder>{
  SortBoxOrder.ascending: (final context) => AppLocalizations.of(context).optionsSortOrderAscending,
  SortBoxOrder.descending: (final context) => AppLocalizations.of(context).optionsSortOrderDescending,
};