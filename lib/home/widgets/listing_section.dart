import 'package:flutter/material.dart';

import '../home_colors.dart';
import '../home_models.dart';
import 'home_label.dart';
import 'pagination_dots.dart';
import 'property_card.dart';
import 'section_layout.dart';

const _filterGrey = Color(0xFF898989);

class ListingSection extends StatefulWidget {
  const ListingSection({
    super.key,
    required this.title,
    required this.listings,
    required this.images,
    required this.query,
    required this.favorites,
    required this.onFavorite,
    required this.compact,
    required this.showFilters,
    this.onViewAll,
    this.onItemSelected,
  });

  final String title;
  final List<Listing> listings;
  final Map<String, ImageProvider<Object>> images;
  final String query;
  final Set<Listing> favorites;
  final ValueChanged<Listing> onFavorite;
  final bool compact;
  final bool showFilters;
  final ValueChanged<String>? onViewAll;
  final ValueChanged<String>? onItemSelected;

  @override
  State<ListingSection> createState() => _ListingSectionState();
}

class _ListingSectionState extends State<ListingSection> {
  final _scroll = ScrollController();
  ListingType _filter = ListingType.all;
  int _dot = 0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ListingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.listings != widget.listings) {
      _resetCarousel();
    }
  }

  void _resetCarousel() {
    _dot = 0;
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  bool _trackScroll(ScrollNotification notification, int lastDot) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.horizontal && metrics.maxScrollExtent > 0) {
      final dot = (lastDot * metrics.pixels / metrics.maxScrollExtent)
          .clamp(0, lastDot)
          .round();
      if (dot != _dot) setState(() => _dot = dot);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.query.toLowerCase();
    final visible = widget.listings.where((listing) {
      return (_filter == ListingType.all || listing.type == _filter) &&
          '${listing.title} ${listing.subtitle} ${listing.location} ${listing.type.label}'
              .toLowerCase()
              .contains(query);
    }).toList();
    final lastDot = visible.length - 1;

    return HomeSection(
      title: widget.title,
      onViewAll: widget.onViewAll,
      filters: widget.showFilters
          ? Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final filter in ListingType.values) ...[
                    if (filter != ListingType.all)
                      const HomeLabel('|', size: 14, color: HomeColors.muted),
                    Semantics(
                      selected: _filter == filter,
                      button: true,
                      child: InkWell(
                        onTap: () => setState(() {
                          _filter = filter;
                          _resetCarousel();
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 6,
                          ),
                          child: HomeLabel(
                            filter.label,
                            size: 14,
                            color: _filter == filter
                                ? HomeColors.primary
                                : _filterGrey,
                            weight: _filter == filter
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          : null,
      footer: widget.compact && visible.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: PaginationDots(
                count: visible.length,
                selected: _dot,
                onSelected: (index) {
                  if (lastDot == 0 || !_scroll.hasClients) return;
                  _scroll.animateTo(
                    _scroll.position.maxScrollExtent * index / lastDot,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                  );
                },
              ),
            )
          : null,
      child: visible.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: HomeLabel(
                'لا توجد نتائج',
                color: HomeColors.muted,
                size: 14,
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (notification) =>
                  _trackScroll(notification, lastDot),
              child: HorizontalCards(
                height: widget.compact ? 171 : 309,
                controller: _scroll,
                children: [
                  for (final listing in visible)
                    PropertyCard(
                      listing: listing,
                      compact: widget.compact,
                      images: widget.images,
                      isFavorite: widget.favorites.contains(listing),
                      onFavorite: () => widget.onFavorite(listing),
                      onTap: widget.onItemSelected == null
                          ? null
                          : () => widget.onItemSelected!(
                              listing.isProject
                                  ? listing.title
                                  : listing.subtitle,
                            ),
                    ),
                ],
              ),
            ),
    );
  }
}
