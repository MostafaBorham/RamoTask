import 'package:flutter/material.dart';

import '../home_colors.dart';
import 'home_label.dart';
import 'home_media.dart';
import 'section_layout.dart';

const _newsCover = AssetImage('assets/tmp/news-img.png');
const _newsTitle = 'أحدث سوق إيجي';
const _newsDescription =
    'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، '
    'لقد تم توليد هذا النص من مولد النص العربى،';

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({
    super.key,
    required this.images,
    this.onViewAll,
    this.onItemSelected,
  });

  final Map<String, ImageProvider<Object>> images;
  final ValueChanged<String>? onViewAll;
  final ValueChanged<String>? onItemSelected;

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: 'اهم الأخبار',
      onViewAll: onViewAll,
      child: HorizontalCards(
        height: 257,
        children: [
          for (final image in const [
            'real-estate-marketing-ways-in-Saudi-Arabia.jpg',
            'مفهوم-التسويق-العقاري',
          ])
            SizedBox(
              width: 250,
              child: HomeCardSurface(
                radius: 20,
                label: _newsTitle,
                color: const Color(0xFFF9F9F9),
                onTap: onItemSelected == null
                    ? null
                    : () => onItemSelected!(_newsTitle),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 125,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: HomePhoto(image, images, fallback: _newsCover),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 18, 15, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeLabel(
                            _newsTitle,
                            size: 14,
                            weight: FontWeight.w700,
                          ),
                          SizedBox(height: 7),
                          HomeLabel(
                            _newsDescription,
                            color: HomeColors.muted,
                            maxLines: 3,
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
