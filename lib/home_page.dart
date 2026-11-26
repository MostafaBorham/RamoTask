import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home/home_colors.dart';
import 'home/home_content.dart' as content;
import 'home/home_models.dart';
import 'home/widgets/home_bottom_bar.dart';
import 'home/widgets/home_city_section.dart';
import 'home/widgets/home_header.dart';
import 'home/widgets/home_news_section.dart';
import 'home/widgets/listing_section.dart';
import 'home/widgets/promotion_carousel.dart';

export 'home/widgets/home_bottom_bar.dart' show HomeDestination;

/// The RTL home screen from the e-RAMO Figma design.
///
/// Override bundled photos by their Figma image names in [images].
/// The bundled logo can also be overridden with the 'ar logo' key.
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.images = const {},
    this.onSearch,
    this.onContact,
    this.onViewAll,
    this.onItemSelected,
    this.onNavigation,
    this.onMenu,
    this.onNotifications,
    this.onMessages,
  });

  final Map<String, ImageProvider<Object>> images;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onContact;
  final ValueChanged<String>? onViewAll;
  final ValueChanged<String>? onItemSelected;
  final ValueChanged<HomeDestination>? onNavigation;
  final VoidCallback? onMenu;
  final VoidCallback? onNotifications;
  final VoidCallback? onMessages;

  @override
  State<HomePage> createState() => _HomePageState();
}

const _sectionGap = SizedBox(height: 48);

class _HomePageState extends State<HomePage> {
  final _favorites = <Listing>{};
  String _city = content.homeCities.first.$1;
  String _query = '';

  void _selectCity(String city) {
    setState(() => _city = city);
    widget.onItemSelected?.call(city);
  }

  void _toggleFavorite(Listing listing) {
    setState(() {
      if (!_favorites.add(listing)) _favorites.remove(listing);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: HomeColors.background,
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    HomeHeader(
                      city: _city,
                      topInset: MediaQuery.paddingOf(context).top,
                      logo: widget.images['ar logo'],
                      onQueryChanged: (value) =>
                          setState(() => _query = value.trim()),
                      onSearch: widget.onSearch,
                      onMenu: widget.onMenu,
                      onNotifications: widget.onNotifications,
                      onMessages: widget.onMessages,
                    ),
                    PromotionCarousel(
                      images: widget.images,
                      slides: const [
                        content.homePromotion,
                        content.officePromotion,
                      ],
                      onContact: widget.onContact,
                    ),
                    _sectionGap,
                    _listings('عقارات مميزة في مصر', content.featuredListings),
                    _sectionGap,
                    _listings(
                      'اهم المشاريع العقارية في مصر',
                      content.projectListings,
                      showFilters: false,
                    ),
                    _sectionGap,
                    HomeCitySection(
                      cities: content.homeCities,
                      images: widget.images,
                      onCitySelected: _selectCity,
                      onViewAll: widget.onViewAll,
                    ),
                    _sectionGap,
                    PromotionCarousel(
                      images: widget.images,
                      slides: const [
                        content.officePromotion,
                        content.homePromotion,
                      ],
                      onContact: widget.onContact,
                    ),
                    _sectionGap,
                    _listings(
                      'أحدث الشقق في مصر',
                      content.apartmentListings,
                      compact: true,
                    ),
                    _sectionGap,
                    _listings(
                      'أحدث الفيلات في مصر',
                      content.villaListings,
                      compact: true,
                    ),
                    _sectionGap,
                    _listings(
                      'أحدث الدوبلكس في مصر',
                      content.duplexListings,
                      compact: true,
                    ),
                    _sectionGap,
                    HomeNewsSection(
                      images: widget.images,
                      onViewAll: widget.onViewAll,
                      onItemSelected: widget.onItemSelected,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: HomeBottomBar(onSelected: widget.onNavigation),
        ),
      ),
    );
  }

  Widget _listings(
    String title,
    List<Listing> listings, {
    bool compact = false,
    bool showFilters = true,
  }) {
    return ListingSection(
      title: title,
      listings: listings,
      images: widget.images,
      query: _query,
      favorites: _favorites,
      onFavorite: _toggleFavorite,
      compact: compact,
      showFilters: showFilters,
      onViewAll: widget.onViewAll,
      onItemSelected: widget.onItemSelected,
    );
  }
}
