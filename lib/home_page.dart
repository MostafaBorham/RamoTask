import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

enum HomeDestination { properties, offers, home, market, developers }

const _background = Color(0xFFFCFCFC);
const _blue = Color(0xFF005879);
const _gold = Color(0xFFEAB010);
const _grey = Color(0xFF6C6C6C);
const _filterGrey = Color(0xFF898989);
const _badgeGold = Color(0xFFFFC700);
const _projectGreen = Color(0xFF145233);
const _red = Color(0xFFE53935);
const _border = Color(0xFFD9D9D9);
const _livingRoom = 'pexels-vecislavas-popa-1643383';
const _apartment = 'pexels-christa-grover-2121120';
const _companyLogo = 'agent-one.jpg';
const _propertyCover = ResizeImage(
  AssetImage('assets/tmp/reel-state-card-item-img.jpg'),
  width: 960,
);
const _cityCover = AssetImage('assets/tmp/city-img.jpg');
const _newsCover = AssetImage('assets/tmp/news-img.png');
const _location = 'الشيخ زايد الجيزة';
const _apartmentTitle = 'شقة سكنية للبيع تشطيب سوبر ...';
const _projectTitle = 'كمبوند الشيخ زايد';
const _projectDescription = 'شقق سكنية فاخرة ومطاعم تجار...';
const _newsTitle = 'أحدث سوق إيجي';
const _newsDescription =
    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، '
    'لقد تم توليد هذا النص من مولد النص العربى،';

typedef _PromotionSlide = ({
  String image,
  AssetImage photo,
  String title,
  String subtitle,
});

const _homePromotion = (
  image: _livingRoom,
  photo: AssetImage('assets/tmp/banner2-img.png'),
  title: 'منزل احلامك الاَن متوفر',
  subtitle: 'مشروع كمبوند الشيخ زايد اكثر من 200 شقة ومحل في انتظارك',
);
const _officePromotion = (
  image: 'pexels-huseyn-kamaladdin-667838',
  photo: AssetImage('assets/tmp/banner1-img.png'),
  title: 'مكتبك لازم يكون انيق',
  subtitle: 'مشروع كمبوند الشيخ زايد اكثر من 200 مكتب ومحل في انتظارك',
);

const _cities = <(String, String)>[
  ('القاهرة', '213338'),
  ('الجيزة', 'محافظة-الجيزة-كل-ما-يهمك'),
  ('الأسكندرية', 'stanley-bridge-alexandria2.jpg'),
];

enum _ListingType {
  all('الكل'),
  sale('للبيع'),
  rent('للإيجار');

  const _ListingType(this.label);
  final String label;
}

class _Listing {
  const _Listing(
    this.title,
    this.subtitle,
    this.image, {
    this.type = _ListingType.all,
    this.featured = false,
  });

  final String title;
  final String subtitle;
  final String image;
  final _ListingType type;
  final bool featured;

  bool get isProject => type == _ListingType.all;
}

const _sale = '4,000,000 ج.م';
const _rent = '4,000 ج.م شهريا';
const _featured = [
  _Listing(
    _sale,
    _apartmentTitle,
    _apartment,
    type: _ListingType.sale,
    featured: true,
  ),
  _Listing(
    '4,000, ج.م شهريا',
    _apartmentTitle,
    _livingRoom,
    type: _ListingType.rent,
    featured: true,
  ),
];
const _projects = [
  _Listing(_projectTitle, _projectDescription, _apartment, featured: true),
  _Listing(_projectTitle, _projectDescription, 'مشروع-عقاري-في-اسطنبول-1'),
  _Listing(_projectTitle, _projectDescription, '2e224a5e112ca'),
];
const _apartments = [
  _Listing(
    _sale,
    _apartmentTitle,
    _apartment,
    type: _ListingType.sale,
    featured: true,
  ),
  _Listing(_rent, _apartmentTitle, _apartment, type: _ListingType.rent),
];
const _villas = [
  _Listing(
    _sale,
    'فيلا سكنية للبيع تشطيب سوبر ...',
    '001-2008-1',
    type: _ListingType.sale,
  ),
  _Listing(
    _rent,
    _apartmentTitle,
    '04c04e21-6970-438a-829f-eb480af54167',
    type: _ListingType.rent,
    featured: true,
  ),
];
const _duplexes = [
  _Listing(
    _sale,
    'دوبلكس للبيع تشطيب سوبر ...',
    '9066_1_or_1485286106',
    type: _ListingType.sale,
    featured: true,
  ),
  _Listing(
    _rent,
    _apartmentTitle,
    'تصميم-دوبلكس-العزيزية-1',
    type: _ListingType.rent,
  ),
];

class _HomePageState extends State<HomePage> {
  final _favorites = <_Listing>{};
  String _city = _cities.first.$1;
  String _query = '';

  void _selectCity(String city) {
    setState(() => _city = city);
    widget.onItemSelected?.call(city);
  }

  void _toggleFavorite(_Listing listing) {
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
          backgroundColor: _background,
          body: SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 32),
                  children: [
                    _header(),
                    _Promotion(
                      images: widget.images,
                      slides: const [_homePromotion, _officePromotion],
                      onContact: widget.onContact,
                    ),
                    const SizedBox(height: 80),
                    _listings('عقارات مميزة في مصر', _featured),
                    const SizedBox(height: 80),
                    _listings(
                      'اهم المشاريع العقارية في مصر',
                      _projects,
                      showFilters: false,
                    ),
                    const SizedBox(height: 80),
                    _citySection(),
                    const SizedBox(height: 80),
                    _Promotion(
                      images: widget.images,
                      slides: const [_officePromotion, _homePromotion],
                      onContact: widget.onContact,
                    ),
                    const SizedBox(height: 80),
                    _listings('أحدث الشقق في مصر', _apartments, compact: true),
                    const SizedBox(height: 80),
                    _listings('أحدث الفيلات في مصر', _villas, compact: true),
                    const SizedBox(height: 80),
                    _listings('أحدث الدوبلكس في مصر', _duplexes, compact: true),
                    const SizedBox(height: 80),
                    _news(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _HomeBottomBar(onSelected: widget.onNavigation),
        ),
      ),
    );
  }

  Widget _header() {
    final logo = widget.images['ar logo'];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 26,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(23, 12, 23, 16),
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: Center(
                child: logo == null
                    ? const _HomeAsset('app-logo', width: 98, height: 28)
                    : Image(
                        image: logo,
                        width: 98,
                        height: 44,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SizedBox(
                      height: 42,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _HomeAsset(
                            'location-icon',
                            width: 18,
                            height: 22,
                          ),
                          const SizedBox(width: 4),
                          Flexible(child: _Label(_city, size: 18)),
                          const Icon(Icons.keyboard_arrow_down, color: _blue),
                        ],
                      ),
                    ),
                  ),
                ),
                _HeaderAction(
                  const _HomeAsset('message-icon', width: 26, height: 26),
                  'الرسائل',
                  count: '5',
                  onPressed: widget.onMessages,
                ),
                _HeaderAction(
                  const _HomeAsset('notification-icon', width: 19, height: 25),
                  'الإشعارات',
                  count: '2',
                  onPressed: widget.onNotifications,
                ),
                _HeaderAction(
                  const _HomeAsset('home/menu-icon', width: 26, height: 26),
                  'القائمة',
                  onPressed: widget.onMenu,
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 42,
              child: TextField(
                textAlign: TextAlign.right,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.search,
                style: const TextStyle(fontSize: 16),
                onChanged: (value) => setState(() => _query = value.trim()),
                onSubmitted: (value) => widget.onSearch?.call(value.trim()),
                decoration: InputDecoration(
                  hintText: 'كيف يمكننا مساعدتك',
                  hintStyle: const TextStyle(color: Color(0x993C3C43)),
                  isDense: true,
                  prefixIconConstraints: const BoxConstraints.tightFor(
                    width: 40,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsetsDirectional.only(start: 12, end: 4),
                    child: Icon(Icons.search, size: 24, color: _grey),
                  ),
                  filled: true,
                  fillColor: const Color(0x1F767680),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listings(
    String title,
    List<_Listing> listings, {
    bool compact = false,
    bool showFilters = true,
  }) {
    return _ListingSection(
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

  Widget _citySection() {
    return _Section(
      title: 'إبحث عن عقارك بالمدينة',
      onViewAll: widget.onViewAll,
      child: _HorizontalCards(
        height: 250,
        children: [
          for (final (city, image) in _cities)
            SizedBox(
              width: 189,
              child: _CardSurface(
                radius: 20,
                label: city,
                onTap: () => _selectCity(city),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _Photo(image, widget.images, fallback: _cityCover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x33000000), Color(0xA6000000)],
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, -0.09),
                      child: _Label(
                        city,
                        size: 16,
                        color: Colors.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const PositionedDirectional(
                      bottom: 14,
                      start: 19,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Label('عقارات للبيع : 505', color: Colors.white),
                          SizedBox(height: 5),
                          _Label('عقارات للإيجار : 1002', color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _news() {
    return _Section(
      title: 'اهم الأخبار',
      onViewAll: widget.onViewAll,
      child: _HorizontalCards(
        height: 257,
        children: [
          for (final image in const [
            'real-estate-marketing-ways-in-Saudi-Arabia.jpg',
            'مفهوم-التسويق-العقاري',
          ])
            SizedBox(
              width: 250,
              child: _CardSurface(
                radius: 20,
                label: _newsTitle,
                color: const Color(0xFFF9F9F9),
                onTap: widget.onItemSelected == null
                    ? null
                    : () => widget.onItemSelected!(_newsTitle),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 125,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: _Photo(
                          image,
                          widget.images,
                          fallback: _newsCover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 18, 15, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Label(_newsTitle, size: 14, weight: FontWeight.w700),
                          SizedBox(height: 7),
                          _Label(_newsDescription, color: _grey, maxLines: 3),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(
    this.text, {
    this.size = 12,
    this.color = Colors.black,
    this.weight = FontWeight.w400,
    this.maxLines = 1,
    this.align,
    this.direction,
  });

  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final int maxLines;
  final TextAlign? align;
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      textDirection: direction,
      style: TextStyle(
        fontSize: size,
        height: size <= 12 ? 16 / size : 1.33,
        letterSpacing: size >= 14 ? -0.3 : 0,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo(this.name, this.images, {this.fallback});

  final String name;
  final Map<String, ImageProvider<Object>> images;
  final ImageProvider<Object>? fallback;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: Color(0xFFD8E5E9),
      child: Center(child: Icon(Icons.image_outlined, color: _blue, size: 26)),
    );
    final image = images[name] ?? fallback;
    return image == null
        ? placeholder
        : Image(
            image: image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            excludeFromSemantics: true,
            errorBuilder: (context, error, stackTrace) => placeholder,
          );
  }
}

class _HomeAsset extends StatelessWidget {
  const _HomeAsset(this.name, {required this.width, required this.height});

  final String name;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/$name.svg',
      width: width,
      height: height,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction(this.icon, this.label, {this.count, this.onPressed});

  final Widget icon;
  final String label;
  final String? count;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: SizedBox.square(
        dimension: 29,
        child: Stack(
          alignment: Alignment.center,
          children: [
            icon,
            if (count != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox.square(
                    dimension: 13,
                    child: Center(
                      child: Text(
                        count!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.child,
    this.onViewAll,
    this.filters,
    this.footer,
  });

  final String title;
  final Widget child;
  final ValueChanged<String>? onViewAll;
  final Widget? filters;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Row(
              children: [
                Expanded(
                  child: _Label(
                    title,
                    size: 18,
                    maxLines: 2,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onViewAll == null ? null : () => onViewAll!(title),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: _Label('مشاهدة الكل', size: 16, color: _grey),
                  ),
                ),
              ],
            ),
          ),
          ?filters,
          SizedBox(height: filters == null ? 16 : 14),
          child,
          ?footer,
        ],
      ),
    );
  }
}

class _HorizontalCards extends StatelessWidget {
  const _HorizontalCards({
    required this.height,
    required this.children,
    this.controller,
  });

  final double height;
  final List<Widget> children;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        controller: controller,
        primary: false,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }
}

class _CardSurface extends StatelessWidget {
  const _CardSurface({
    required this.child,
    required this.radius,
    required this.label,
    this.color = _background,
    this.borderColor = _border,
    this.onTap,
  });

  final Widget child;
  final double radius;
  final String label;
  final Color color;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (onTap == null)
            child
          else
            Semantics(
              label: label,
              button: true,
              child: InkWell(onTap: onTap, child: child),
            ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingSection extends StatefulWidget {
  const _ListingSection({
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
  final List<_Listing> listings;
  final Map<String, ImageProvider<Object>> images;
  final String query;
  final Set<_Listing> favorites;
  final ValueChanged<_Listing> onFavorite;
  final bool compact;
  final bool showFilters;
  final ValueChanged<String>? onViewAll;
  final ValueChanged<String>? onItemSelected;

  @override
  State<_ListingSection> createState() => _ListingSectionState();
}

class _ListingSectionState extends State<_ListingSection> {
  final _scroll = ScrollController();
  _ListingType _filter = _ListingType.all;
  int _dot = 0;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ListingSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) _resetCarousel();
  }

  void _resetCarousel() {
    _dot = 0;
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  bool _trackScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.horizontal && metrics.maxScrollExtent > 0) {
      final dot = (3 * metrics.pixels / metrics.maxScrollExtent)
          .clamp(0.0, 3.0)
          .round();
      if (dot != _dot) setState(() => _dot = dot);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.query.toLowerCase();
    final visible = widget.listings.where((listing) {
      return (_filter == _ListingType.all || listing.type == _filter) &&
          '${listing.title} ${listing.subtitle} $_location ${listing.type.label}'
              .toLowerCase()
              .contains(query);
    }).toList();

    return _Section(
      title: widget.title,
      onViewAll: widget.onViewAll,
      filters: widget.showFilters
          ? Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final filter in _ListingType.values) ...[
                    if (filter != _ListingType.all)
                      const _Label('|', size: 14, color: _grey),
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
                          child: _Label(
                            filter.label,
                            size: 14,
                            color: _filter == filter ? _blue : _filterGrey,
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
      footer: widget.compact && visible.length > 1
          ? Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _Dots(
                selected: _dot,
                onSelected: (index) {
                  if (!_scroll.hasClients) return;
                  _scroll.animateTo(
                    _scroll.position.maxScrollExtent * index / 3,
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
              child: _Label('لا توجد نتائج', color: _grey, size: 14),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: _trackScroll,
              child: _HorizontalCards(
                height: widget.compact ? 171 : 309,
                controller: _scroll,
                children: [
                  for (final listing in visible)
                    _PropertyCard(
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

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.listing,
    required this.compact,
    required this.images,
    required this.isFavorite,
    required this.onFavorite,
    this.onTap,
  });

  final _Listing listing;
  final bool compact;
  final Map<String, ImageProvider<Object>> images;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final photo = Stack(
      fit: StackFit.expand,
      children: [
        _Photo(listing.image, images, fallback: _propertyCover),
        if (!listing.isProject)
          Positioned(
            left: 1,
            top: compact ? 10 : null,
            bottom: compact ? null : 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: listing.type == _ListingType.sale
                    ? _badgeGold
                    : listing.featured
                    ? _gold
                    : _border,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                ),
              ),
              child: SizedBox(
                width: compact ? 60 : 98,
                height: 32,
                child: Center(
                  child: _Label(
                    listing.type.label,
                    color: _blue,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          right: 0,
          bottom: 7,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: listing.featured ? _badgeGold : _projectGreen,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(30),
              ),
            ),
            child: SizedBox(
              width: 60,
              height: 19,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (listing.featured)
                    const Icon(
                      Icons.star_rounded,
                      size: 13,
                      color: Colors.black,
                    )
                  else
                    const _HomeAsset('buildings-icon', width: 13, height: 13),
                  const SizedBox(width: 3),
                  Flexible(
                    child: _Label(
                      listing.featured ? 'مميز' : 'مشروع',
                      size: 10,
                      color: listing.featured ? Colors.black : Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    final details = Padding(
      padding: EdgeInsets.fromLTRB(12, compact ? 11 : 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _Label(listing.title, size: 14, weight: FontWeight.w600),
              ),
              IconButton(
                onPressed: onFavorite,
                isSelected: isFavorite,
                tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                icon: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFFB4B4B4),
                ),
                selectedIcon: const Icon(Icons.favorite, color: _red),
                style: IconButton.styleFrom(
                  iconSize: 16,
                  minimumSize: const Size.square(32),
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          _Label(listing.subtitle, color: _grey, weight: FontWeight.w600),
          if (!listing.isProject) ...[
            const SizedBox(height: 9),
            const Row(
              children: [
                _IconLabel(_HomeAsset('bed-icon', width: 14, height: 10), '10'),
                SizedBox(width: 8),
                _IconLabel(
                  _HomeAsset('pathroom-icon', width: 16, height: 16),
                  '5',
                ),
                SizedBox(width: 8),
                _IconLabel(
                  _HomeAsset('space-square-icon', width: 13, height: 13),
                  '8,725sqft',
                  direction: TextDirection.ltr,
                ),
              ],
            ),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconLabel(
                    _HomeAsset('location-icon', width: 10, height: 13),
                    _location,
                  ),
                  SizedBox(height: 5),
                  _IconLabel(
                    Icon(Icons.access_time, size: 14, color: _grey),
                    'منذ 4 ايام',
                  ),
                ],
              ),
              Column(
                children: [
                  const _Label('بواسطة', size: 10, weight: FontWeight.w600),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      width: 48,
                      height: 33,
                      child: images.containsKey(_companyLogo)
                          ? _Photo(_companyLogo, images)
                          : Semantics(
                              label: 'Zillow',
                              image: true,
                              child: const _HomeAsset(
                                'tmp/zillow-logo',
                                width: 48,
                                height: 33,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    return SizedBox(
      width: compact ? 378 : 230,
      child: _CardSurface(
        radius: compact ? 20 : 40,
        borderColor: listing.featured ? _gold : _border,
        label: '${listing.title}، ${listing.subtitle}',
        onTap: onTap,
        child: compact
            ? Row(
                children: [
                  SizedBox(width: 156, height: double.infinity, child: photo),
                  Expanded(child: details),
                ],
              )
            : Column(
                children: [
                  SizedBox(height: 150, width: double.infinity, child: photo),
                  Expanded(child: details),
                ],
              ),
      ),
    );
  }
}

class _IconLabel extends StatelessWidget {
  const _IconLabel(this.icon, this.label, {this.direction});

  final Widget icon;
  final String label;
  final TextDirection? direction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 3),
        _Label(
          label,
          size: 10,
          color: _grey,
          weight: FontWeight.w600,
          direction: direction,
        ),
      ],
    );
  }
}

class _Promotion extends StatefulWidget {
  const _Promotion({
    required this.images,
    required this.slides,
    this.onContact,
  });

  final Map<String, ImageProvider<Object>> images;
  final List<_PromotionSlide> slides;
  final ValueChanged<String>? onContact;

  @override
  State<_Promotion> createState() => _PromotionState();
}

class _PromotionState extends State<_Promotion> {
  final _pages = PageController();
  int _page = 0;

  void _goTo(int index) {
    if (!_pages.hasClients) return;
    _pages.animateToPage(
      index % widget.slides.length,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const arrow = _HomeAsset('home/slider-circle-icon', width: 30, height: 30);
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: _pages,
                  itemCount: widget.slides.length,
                  onPageChanged: (index) => setState(() => _page = index),
                  itemBuilder: (context, index) {
                    final slide = widget.slides[index];
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        _Photo(
                          slide.image,
                          widget.images,
                          fallback: slide.photo,
                        ),
                        const ColoredBox(color: Color(0x70000000)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 54),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _Label(
                                slide.title,
                                size: 14,
                                color: Colors.white,
                                maxLines: 2,
                                align: TextAlign.center,
                                weight: FontWeight.w600,
                              ),
                              const SizedBox(height: 7),
                              _Label(
                                slide.subtitle,
                                color: Colors.white70,
                                maxLines: 2,
                                align: TextAlign.center,
                                weight: FontWeight.w500,
                              ),
                              const SizedBox(height: 7),
                              Material(
                                color: _gold,
                                borderRadius: BorderRadius.circular(4),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4),
                                  onTap: widget.onContact == null
                                      ? null
                                      : () => widget.onContact!(slide.title),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    child: _Label(
                                      'تواصل الاَن',
                                      color: Colors.white,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              PositionedDirectional(
                start: 7,
                child: IconButton(
                  tooltip: 'السابق',
                  onPressed: () => _goTo(_page - 1),
                  icon: Transform.flip(flipX: true, child: arrow),
                ),
              ),
              PositionedDirectional(
                end: 7,
                child: IconButton(
                  tooltip: 'التالي',
                  onPressed: () => _goTo(_page + 1),
                  icon: arrow,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        _Dots(count: widget.slides.length, selected: _page, onSelected: _goTo),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.selected,
    required this.onSelected,
    this.count = 4,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: [
        for (var index = 0; index < count; index++)
          Semantics(
            button: true,
            selected: index == selected,
            label: 'شريحة ${index + 1}',
            child: InkWell(
              onTap: () => onSelected(index),
              child: SizedBox(
                width: 18,
                height: 17,
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: index == selected ? _blue : _border,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox.square(dimension: 8),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HomeBottomBar extends StatelessWidget {
  const _HomeBottomBar({this.onSelected});

  final ValueChanged<HomeDestination>? onSelected;

  static const _items = [
    (
      HomeDestination.properties,
      _HomeAsset('my-reel-states-icon', width: 24, height: 24),
      'عقاراتي',
    ),
    (
      HomeDestination.offers,
      _HomeAsset('offers-icon', width: 17, height: 20),
      'العروض',
    ),
    (
      HomeDestination.home,
      _HomeAsset('home-icon', width: 35, height: 35),
      'الرئيسية',
    ),
    (
      HomeDestination.market,
      Icon(Icons.storefront_outlined, size: 21, color: Color(0xFF484C52)),
      'السوق',
    ),
    (
      HomeDestination.developers,
      _HomeAsset('developers-icon', width: 29, height: 21),
      'المطورون',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 10),
      child: Center(
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 56,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final (destination, icon, label) in _items)
                        Expanded(
                          child: destination == HomeDestination.home
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 17),
                                  child: Semantics(
                                    selected: true,
                                    button: true,
                                    child: Tooltip(
                                      message: label,
                                      child: Material(
                                        color: _blue,
                                        elevation: 4,
                                        shape: const CircleBorder(
                                          side: BorderSide(
                                            color: Colors.white,
                                            width: 4,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: InkWell(
                                          onTap: onSelected == null
                                              ? null
                                              : () => onSelected!(destination),
                                          child: SizedBox.square(
                                            dimension: 63,
                                            child: Center(child: icon),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: onSelected == null
                                      ? null
                                      : () => onSelected!(destination),
                                  child: SizedBox(
                                    height: 56,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          child: Center(child: icon),
                                        ),
                                        const SizedBox(height: 3),
                                        _Label(label, size: 11, color: _blue),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
