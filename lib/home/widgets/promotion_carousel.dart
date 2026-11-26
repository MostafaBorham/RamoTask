import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../home_colors.dart';
import '../home_models.dart';
import 'home_label.dart';
import 'home_media.dart';
import 'pagination_dots.dart';

class PromotionCarousel extends StatefulWidget {
  const PromotionCarousel({
    super.key,
    required this.images,
    required this.slides,
    this.onContact,
  });

  final Map<String, ImageProvider<Object>> images;
  final List<PromotionSlide> slides;
  final ValueChanged<String>? onContact;

  @override
  State<PromotionCarousel> createState() => _PromotionCarouselState();
}

class _PromotionCarouselState extends State<PromotionCarousel> {
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
                        HomePhoto(
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
                              HomeLabel(
                                slide.title,
                                size: 14,
                                color: Colors.white,
                                maxLines: 2,
                                align: TextAlign.center,
                                weight: FontWeight.w600,
                              ),
                              const SizedBox(height: 7),
                              HomeLabel(
                                slide.subtitle,
                                color: Colors.white70,
                                maxLines: 2,
                                align: TextAlign.center,
                                weight: FontWeight.w500,
                              ),
                              const SizedBox(height: 7),
                              Material(
                                color: HomeColors.gold,
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
                                    child: HomeLabel(
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
                child: _PromotionArrow(
                  previous: true,
                  onPressed: () => _goTo(_page - 1),
                ),
              ),
              PositionedDirectional(
                end: 7,
                child: _PromotionArrow(
                  previous: false,
                  onPressed: () => _goTo(_page + 1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        PaginationDots(
          count: widget.slides.length,
          selected: _page,
          onSelected: _goTo,
        ),
      ],
    );
  }
}

class _PromotionArrow extends StatelessWidget {
  const _PromotionArrow({required this.previous, required this.onPressed});

  static final _blur = ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5);

  final bool previous;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: previous ? 'السابق' : 'التالي',
      onPressed: onPressed,
      icon: ClipOval(
        child: BackdropFilter(
          filter: _blur,
          child: ColoredBox(
            color: const Color(0x48FFFFFF),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Transform.flip(
                flipX: previous,
                child: const HomeSvg(
                  'home/slider-circle-icon',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
