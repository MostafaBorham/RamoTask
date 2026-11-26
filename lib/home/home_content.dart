import 'package:flutter/material.dart';

import 'home_models.dart';

const _livingRoom = 'pexels-vecislavas-popa-1643383';
const _apartment = 'pexels-christa-grover-2121120';
const _location = 'الشيخ زايد الجيزة';
const _apartmentTitle = 'شقة سكنية للبيع تشطيب سوبر ...';
const _projectTitle = 'كمبوند الشيخ زايد';
const _projectDescription = 'شقق سكنية فاخرة ومطاعم تجار...';

const homePromotion = (
  image: _livingRoom,
  photo: AssetImage('assets/tmp/banner2-img.png'),
  title: 'منزل احلامك الاَن متوفر',
  subtitle: 'مشروع كمبوند الشيخ زايد اكثر من 200 شقة ومحل في انتظارك',
);
const officePromotion = (
  image: 'pexels-huseyn-kamaladdin-667838',
  photo: AssetImage('assets/tmp/banner1-img.png'),
  title: 'مكتبك لازم يكون انيق',
  subtitle: 'مشروع كمبوند الشيخ زايد اكثر من 200 مكتب ومحل في انتظارك',
);

const homeCities = <(String, String)>[
  ('القاهرة', '213338'),
  ('الجيزة', 'محافظة-الجيزة-كل-ما-يهمك'),
  ('الأسكندرية', 'stanley-bridge-alexandria2.jpg'),
];

const _sale = '4,000,000 ج.م';
const _rent = '4,000 ج.م شهريا';
const featuredListings = [
  Listing(
    _sale,
    _apartmentTitle,
    _apartment,
    location: _location,
    type: ListingType.sale,
    featured: true,
  ),
  Listing(
    '4,000, ج.م شهريا',
    _apartmentTitle,
    _livingRoom,
    location: _location,
    type: ListingType.rent,
    featured: true,
  ),
];
const projectListings = [
  Listing(
    _projectTitle,
    _projectDescription,
    _apartment,
    featured: true,
    location: _location,
  ),
  Listing(
    _projectTitle,
    _projectDescription,
    'مشروع-عقاري-في-اسطنبول-1',
    location: _location,
  ),
  Listing(
    _projectTitle,
    _projectDescription,
    '2e224a5e112ca',
    location: _location,
  ),
];
const apartmentListings = [
  Listing(
    _sale,
    _apartmentTitle,
    _apartment,
    location: _location,
    type: ListingType.sale,
    featured: true,
  ),
  Listing(
    _rent,
    _apartmentTitle,
    _apartment,
    type: ListingType.rent,
    location: _location,
  ),
];
const villaListings = [
  Listing(
    _sale,
    'فيلا سكنية للبيع تشطيب سوبر ...',
    '001-2008-1',
    location: _location,
    type: ListingType.sale,
  ),
  Listing(
    _rent,
    _apartmentTitle,
    '04c04e21-6970-438a-829f-eb480af54167',
    location: _location,
    type: ListingType.rent,
    featured: true,
  ),
];
const duplexListings = [
  Listing(
    _sale,
    'دوبلكس للبيع تشطيب سوبر ...',
    '9066_1_or_1485286106',
    location: _location,
    type: ListingType.sale,
    featured: true,
  ),
  Listing(
    _rent,
    _apartmentTitle,
    'تصميم-دوبلكس-العزيزية-1',
    location: _location,
    type: ListingType.rent,
  ),
];
