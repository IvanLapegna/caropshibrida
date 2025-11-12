import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.cardBackground,
    required this.button,
    required this.grayLight,
    required this.lightBlue,
    required this.green,
    required this.red,
    required this.pendingYellow,

  });

  final Color? primary;
  final Color? cardBackground;
  final Color? button;
  final Color? grayLight;
  final Color? lightBlue;
  final Color? green;
  final Color? red;
  final Color? pendingYellow;

  @override
  AppColors copyWith({
    Color? primary,
    Color? cardBackground,
    Color? button,
    Color? grayLight,
    Color? lightBlue,
    Color? green,
    Color? red,
    Color? pendingYellow,
  }) =>
      AppColors(
        primary: primary ?? this.primary,
        cardBackground: cardBackground ?? this.cardBackground,
        button: button ?? this.button,
        grayLight: grayLight ?? this.grayLight,
        lightBlue: lightBlue ?? this.lightBlue,
        green: green ?? this.green,
        red: red ?? this.red,
        pendingYellow: pendingYellow ?? this.pendingYellow,

      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primary: Color.lerp(primary, other.primary, t),
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t),
      button: Color.lerp(button, other.button, t),
      grayLight: Color.lerp(grayLight, other.grayLight, t),
      lightBlue: Color.lerp(lightBlue, other.lightBlue, t),
      green: Color.lerp(green, other.green, t),
      red: Color.lerp(red, other.red, t),
      pendingYellow: Color.lerp(pendingYellow, other.pendingYellow, t),
    );
  }
}

const AppColors appColorsLight = AppColors(
  primary: Color(0xFF222831),
  cardBackground: Color(0xFF2F3846),
  button: Color(0xFF0067FF),
  grayLight: Color(0xFF686868),
  lightBlue: Color(0xFF5381C4),
  green: Color(0xFF006D2C),
  red: Color(0xFFE91E25),
  pendingYellow: Color(0xFFFFC53D),
);