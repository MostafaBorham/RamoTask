import 'package:flutter/material.dart';

import '../home_colors.dart';
import '../home_models.dart';
import 'home_label.dart';
import 'home_media.dart';
import 'section_layout.dart';

const _badgeGold = Color(0xFFFFC700);
const _projectGreen = Color(0xFF2A803F);
const _companyLogo = 'agent-one.jpg';
const _propertyCover = ResizeImage(
  AssetImage('assets/tmp/reel-state-card-item-img.jpg'),
  width: 960,
);

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.listing,
    required this.compact,
    required this.images,
    required this.isFavorite,
    required this.onFavorite,
    this.onTap,
  });

  final Listing listing;
  final bool compact;
  final Map<String, ImageProvider<Object>> images;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final photo = _buildPhoto();
    final details = _buildDetails();

    return SizedBox(
      width: compact ? 378 : 230,
      child: HomeCardSurface(
        radius: compact ? 20 : 40,
        borderColor: listing.featured ? HomeColors.gold : HomeColors.border,
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

  Widget _buildPhoto() {
    return Stack(
      fit: StackFit.expand,
      children: [
        HomePhoto(listing.image, images, fallback: _propertyCover),
        if (!listing.isProject)
          Positioned(
            left: 1,
            top: compact ? 10 : null,
            bottom: compact ? null : 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: listing.type == ListingType.sale
                    ? _badgeGold
                    : HomeColors.border,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                ),
              ),
              child: SizedBox(
                width: compact ? 60 : 98,
                height: 32,
                child: Center(
                  child: HomeLabel(
                    listing.type.label,
                    color: HomeColors.primary,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        if (!compact)
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    if (listing.featured)
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Colors.black,
                      )
                    else
                      const HomeSvg('buildings-icon', width: 13, height: 13),
                    HomeLabel(
                      listing.featured ? 'مميز' : 'مشروع',
                      size: 10,
                      color: listing.featured ? Colors.black : Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, compact ? 11 : 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: HomeLabel(
                  listing.title,
                  size: 14,
                  weight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                isSelected: isFavorite,
                tooltip: isFavorite ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                icon: const Icon(
                  Icons.favorite_border,
                  color: Color(0xFFB4B4B4),
                ),
                selectedIcon: const Icon(
                  Icons.favorite,
                  color: HomeColors.danger,
                ),
                style:
                    IconButton.styleFrom(
                      iconSize: 16,
                      minimumSize: const Size.square(32),
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      splashFactory: NoSplash.splashFactory,
                    ).copyWith(
                      overlayColor: WidgetStateProperty.resolveWith(
                        (states) => states.contains(WidgetState.pressed)
                            ? Colors.transparent
                            : null,
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          HomeLabel(
            listing.subtitle,
            color: HomeColors.muted,
            weight: FontWeight.w600,
          ),
          if (!listing.isProject) ...[
            const SizedBox(height: 9),
            const Row(
              children: [
                _IconLabel(HomeSvg('bed-icon', width: 14, height: 10), '10'),
                SizedBox(width: 8),
                _IconLabel(
                  HomeSvg('pathroom-icon', width: 16, height: 16),
                  '5',
                ),
                SizedBox(width: 8),
                _IconLabel(
                  HomeSvg('space-square-icon', width: 13, height: 13),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconLabel(
                    const HomeSvg('location-icon', width: 10, height: 13),
                    listing.location,
                  ),
                  const SizedBox(height: 5),
                  const _IconLabel(
                    Icon(Icons.access_time, size: 14, color: HomeColors.muted),
                    'منذ 4 ايام',
                  ),
                ],
              ),
              Column(
                children: [
                  const HomeLabel('بواسطة', size: 10, weight: FontWeight.w600),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: SizedBox(
                      width: 48,
                      height: 33,
                      child: images.containsKey(_companyLogo)
                          ? HomePhoto(_companyLogo, images)
                          : Semantics(
                              label: 'Zillow',
                              image: true,
                              child: const HomeSvg(
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
        HomeLabel(
          label,
          size: 10,
          color: HomeColors.muted,
          weight: FontWeight.w600,
          direction: direction,
        ),
      ],
    );
  }
}
