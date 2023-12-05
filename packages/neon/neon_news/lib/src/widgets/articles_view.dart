import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html_dom;
import 'package:html/parser.dart' as html_parser;
import 'package:neon/blocs.dart';
import 'package:neon/platform.dart';
import 'package:neon/sort_box.dart';
import 'package:neon/theme.dart';
import 'package:neon/widgets.dart';
import 'package:neon_news/l10n/localizations.dart';
import 'package:neon_news/src/blocs/article.dart';
import 'package:neon_news/src/blocs/articles.dart';
import 'package:neon_news/src/blocs/news.dart';
import 'package:neon_news/src/options.dart';
import 'package:neon_news/src/pages/article.dart';
import 'package:neon_news/src/sort/articles.dart';
import 'package:neon_news/src/widgets/feed_icon.dart';
import 'package:nextcloud/news.dart' as news;
import 'package:url_launcher/url_launcher_string.dart';

class NewsArticlesView extends StatefulWidget {
  const NewsArticlesView({
    required this.bloc,
    required this.newsBloc,
    super.key,
  });

  final NewsArticlesBloc bloc;
  final NewsBloc newsBloc;

  @override
  State<NewsArticlesView> createState() => _NewsArticlesViewState();
}

class _NewsArticlesViewState extends State<NewsArticlesView> {
  @override
  void initState() {
    super.initState();

    widget.bloc.errors.listen((final error) {
      NeonError.showSnackbar(context, error);
    });
  }

  @override
  Widget build(final BuildContext context) => ResultBuilder<List<news.Feed>>.behaviorSubject(
        subject: widget.newsBloc.feeds,
        builder: (final context, final feeds) => ResultBuilder<List<news.Article>>.behaviorSubject(
          subject: widget.bloc.articles,
          builder: (final context, final articles) => SortBoxBuilder<ArticlesSortProperty, news.Article>(
            sortBox: articlesSortBox,
            sortProperty: widget.newsBloc.options.articlesSortPropertyOption,
            sortBoxOrder: widget.newsBloc.options.articlesSortBoxOrderOption,
            input: articles.data,
            builder: (final context, final sorted) => NeonListView(
              scrollKey: 'news-articles',
              isLoading: articles.isLoading || feeds.isLoading,
              error: articles.error ?? feeds.error,
              onRefresh: () async {
                await Future.wait([
                  widget.bloc.refresh(),
                  widget.newsBloc.refresh(),
                ]);
              },
              itemCount: feeds.hasData ? sorted.length : null,
              itemBuilder: (final context, final index) {
                final article = sorted[index];

                return _buildArticle(
                  context,
                  article,
                  feeds.requireData.singleWhere((final feed) => feed.id == article.feedId),
                );
              },
              topFixedChildren: [
                StreamBuilder<FilterType>(
                  stream: widget.bloc.filterType,
                  builder: (final context, final selectedFilterTypeSnapshot) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButton<FilterType>(
                      isExpanded: true,
                      value: selectedFilterTypeSnapshot.data,
                      items: [
                        FilterType.all,
                        FilterType.unread,
                        if (widget.bloc.listType == null) ...[
                          FilterType.starred,
                        ],
                      ].map<DropdownMenuItem<FilterType>>(
                        (final a) {
                          late final String label;
                          switch (a) {
                            case FilterType.all:
                              label = NewsLocalizations.of(context).articlesFilterAll;
                            case FilterType.unread:
                              label = NewsLocalizations.of(context).articlesFilterUnread;
                            case FilterType.starred:
                              label = NewsLocalizations.of(context).articlesFilterStarred;
                            default:
                              throw Exception('FilterType $a should not be shown');
                          }
                          return DropdownMenuItem(
                            value: a,
                            child: Text(label),
                          );
                        },
                      ).toList(),
                      onChanged: (final value) {
                        widget.bloc.setFilterType(value!);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildArticle(
    final BuildContext context,
    final news.Article article,
    final news.Feed feed,
  ) =>
      ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                article.title,
                style: article.unread
                    ? null
                    : Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).disabledColor),
              ),
            ),
            if (article.mediaThumbnail != null) ...[
              NeonUrlImage(
                url: article.mediaThumbnail!,
                size: const Size(100, 50),
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
        subtitle: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                right: 8,
              ),
              child: NewsFeedIcon(
                feed: feed,
                size: smallIconSize,
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
            ),
            RelativeTime(
              date: DateTime.fromMillisecondsSinceEpoch(article.pubDate * 1000),
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                feed.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            if (article.starred) {
              widget.bloc.unstarArticle(article);
            } else {
              widget.bloc.starArticle(article);
            }
          },
          tooltip:
              article.starred ? NewsLocalizations.of(context).articleUnstar : NewsLocalizations.of(context).articleStar,
          icon: Icon(
            article.starred ? Icons.star : Icons.star_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onLongPress: () {
          if (article.unread) {
            widget.bloc.markArticleAsRead(article);
          } else {
            widget.bloc.markArticleAsUnread(article);
          }
        },
        onTap: () async {
          final viewType = widget.newsBloc.options.articleViewTypeOption.value;
          String? bodyData;
          try {
            bodyData = _fixArticleBody(article.body);
          } catch (e, s) {
            debugPrint(e.toString());
            debugPrint(s.toString());
          }

          if ((viewType == ArticleViewType.direct || article.url == null) && bodyData != null) {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (final context) => NewsArticlePage(
                  bloc: NewsArticleBloc(
                    widget.bloc,
                    article,
                  ),
                  articlesBloc: widget.bloc,
                  useWebView: false,
                  bodyData: bodyData,
                  url: article.url,
                ),
              ),
            );
          } else if (viewType == ArticleViewType.internalBrowser &&
              article.url != null &&
              NeonPlatform.instance.canUseWebView) {
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (final context) => NewsArticlePage(
                  bloc: NewsArticleBloc(
                    widget.bloc,
                    article,
                  ),
                  articlesBloc: widget.bloc,
                  useWebView: true,
                  url: article.url,
                ),
              ),
            );
          } else {
            if (article.unread) {
              widget.bloc.markArticleAsRead(article);
            }
            if (article.url != null) {
              await launchUrlString(
                article.url!,
                mode: LaunchMode.externalApplication,
              );
            }
          }
        },
      );

  String _fixArticleBody(final String b) => _fixArticleBodyElement(html_parser.parse(b).documentElement!).outerHtml;

  html_dom.Element _fixArticleBodyElement(final html_dom.Element element) {
    for (final attributeName in ['src', 'href']) {
      final attributeValue = element.attributes[attributeName];
      if (attributeValue != null && attributeValue.startsWith('//')) {
        element.attributes[attributeName] = 'https:$attributeValue';
      }
    }

    element.children.forEach(_fixArticleBodyElement);

    return element;
  }
}