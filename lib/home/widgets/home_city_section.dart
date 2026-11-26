import 'package:flutter/material.dart';

import 'home_label.dart';
import 'home_media.dart';
import 'section_layout.dart';

const _cityCover = AssetImage('assets/tmp/city-img.jpg');

class HomeCitySection extends StatelessWidget {
  const HomeCitySection({
    super.key,
    required this.cities,
    required this.images,
    required this.onCitySelected,
    this.onViewAll,
  });

  final List<(String, String)> cities;
  final Map<String, ImageProvider<Object>> images;
  final ValueChanged<String> onCitySelected;
  final ValueChanged<String>? onViewAll;

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'إبحث عن عقارك بالمدينة',
      onViewAll: onViewAll,
      child: HorizontalCards(
        height: 250,
        children: [
          for (final (city, image) in cities)
            SizedBox(
              width: 189,
              child: HomeCardSurface(
                radius: 20,
                label: city,
                onTap: () => onCitySelected(city),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    HomePhoto(image, images, fallback: _cityCover),
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
                      child: HomeLabel(
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
                          HomeLabel('عقارات للبيع : 505', color: Colors.white),
                          SizedBox(height: 5),
                          HomeLabel(
                            'عقارات للإيجار : 1002',
                            color: Colors.white,
                          ),
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
