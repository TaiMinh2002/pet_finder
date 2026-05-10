import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 22;
  static const double card = 24;
  static const double cardLarge = 30;
  static const double hero = 34;
  static const double pill = 999;

  static BorderRadius get smBorder => BorderRadius.circular(sm);
  static BorderRadius get mdBorder => BorderRadius.circular(md);
  static BorderRadius get lgBorder => BorderRadius.circular(lg);
  static BorderRadius get cardBorder => BorderRadius.circular(card);
  static BorderRadius get cardLargeBorder => BorderRadius.circular(cardLarge);
  static BorderRadius get heroBorder => BorderRadius.circular(hero);
  static BorderRadius get pillBorder => BorderRadius.circular(pill);

  static const bottomSheet = BorderRadius.vertical(top: Radius.circular(hero));
}
