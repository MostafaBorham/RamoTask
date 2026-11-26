import 'package:flutter/material.dart';

enum ListingType {
  all('الكل'),
  sale('للبيع'),
  rent('للإيجار');

  const ListingType(this.label);
  final String label;
}

class Listing {
  const Listing(
    this.title,
    this.subtitle,
    this.image, {
    required this.location,
    this.type = ListingType.all,
    this.featured = false,
  });

  final String title;
  final String subtitle;
  final String image;
  final String location;
  final ListingType type;
  final bool featured;

  bool get isProject => type == ListingType.all;
}

typedef PromotionSlide = ({
  String image,
  AssetImage photo,
  String title,
  String subtitle,
});
