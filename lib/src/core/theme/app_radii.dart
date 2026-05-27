import 'package:flutter/widgets.dart';

abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 16;
  static const double xxl = 20;
  static const double pill = 28;

  static const BorderRadius radius8 = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radius12 = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radius14 = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radius16 = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radius20 = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radius28 = BorderRadius.all(Radius.circular(pill));
}
