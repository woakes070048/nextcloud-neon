part of '../neon_notes.dart';

class NotesCategoriesView extends StatelessWidget {
  const NotesCategoriesView({
    required this.bloc,
    super.key,
  });

  final NotesBloc bloc;

  @override
  Widget build(final BuildContext context) => ResultBuilder<List<NotesNote>>.behaviorSubject(
        stream: bloc.notes,
        builder: (final context, final notes) => SortBoxBuilder<CategoriesSortProperty, NoteCategory>(
          sortBox: categoriesSortBox,
          sortPropertyOption: bloc.options.categoriesSortPropertyOption,
          sortBoxOrderOption: bloc.options.categoriesSortBoxOrderOption,
          input: notes.data
              ?.map((final note) => note.category)
              .toSet()
              .map(
                (final category) => NoteCategory(
                  category,
                  notes.requireData.where((final note) => note.category == category).length,
                ),
              )
              .toList(),
          builder: (final context, final sorted) => NeonListView<NoteCategory>(
            scrollKey: 'notes-categories',
            items: sorted,
            isLoading: notes.isLoading,
            error: notes.error,
            onRefresh: bloc.refresh,
            builder: _buildCategory,
          ),
        ),
      );

  Widget _buildCategory(
    final BuildContext context,
    final NoteCategory category,
  ) =>
      ListTile(
        title: Text(category.name.isNotEmpty ? category.name : AppLocalizations.of(context).categoryUncategorized),
        subtitle: Text(AppLocalizations.of(context).categoryNotesCount(category.count)),
        leading: category.name.isNotEmpty
            ? Icon(
                MdiIcons.tag,
                size: largeIconSize,
                color: NotesCategoryColor.compute(category.name),
              )
            : const SizedBox.square(dimension: largeIconSize),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (final context) => NotesCategoryPage(
                bloc: bloc,
                category: category,
              ),
            ),
          );
        },
      );
}
