import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const List<BoxShadow> low = <BoxShadow>[
    BoxShadow(color: Color(0x0F1A1A1A), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> medium = <BoxShadow>[
    BoxShadow(color: Color(0x141A1A1A), blurRadius: 18, offset: Offset(0, 6)),
  ];
}
