// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';

SharedPreferences? _prefs;

enum DeviceSize {
  mobile,
  tablet,
  desktop,
}

abstract class FlutterFlowTheme {
  static DeviceSize deviceSize = DeviceSize.mobile;

  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) {
    deviceSize = getDeviceSize(context);
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  bool get displayLargeIsCustom => typography.displayLargeIsCustom;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  bool get displayMediumIsCustom => typography.displayMediumIsCustom;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  bool get displaySmallIsCustom => typography.displaySmallIsCustom;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  bool get headlineLargeIsCustom => typography.headlineLargeIsCustom;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  bool get headlineMediumIsCustom => typography.headlineMediumIsCustom;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  bool get headlineSmallIsCustom => typography.headlineSmallIsCustom;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  bool get titleLargeIsCustom => typography.titleLargeIsCustom;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  bool get titleMediumIsCustom => typography.titleMediumIsCustom;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  bool get titleSmallIsCustom => typography.titleSmallIsCustom;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  bool get labelLargeIsCustom => typography.labelLargeIsCustom;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  bool get labelMediumIsCustom => typography.labelMediumIsCustom;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  bool get labelSmallIsCustom => typography.labelSmallIsCustom;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  bool get bodyLargeIsCustom => typography.bodyLargeIsCustom;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  bool get bodyMediumIsCustom => typography.bodyMediumIsCustom;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  bool get bodySmallIsCustom => typography.bodySmallIsCustom;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => {
        DeviceSize.mobile: MobileTypography(this),
        DeviceSize.tablet: TabletTypography(this),
        DeviceSize.desktop: DesktopTypography(this),
      }[deviceSize]!;

  ThemeData get themeData => ThemeData(
        brightness: Brightness.light,
        primaryColor: primary,
        scaffoldBackgroundColor: primaryBackground,
        textTheme: TextTheme(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
        ),
      );

  ThemeData get darkThemeData => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primary,
        scaffoldBackgroundColor: primaryBackground,
        textTheme: TextTheme(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
        ),
      );
}

DeviceSize getDeviceSize(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 479) {
    return DeviceSize.mobile;
  } else if (width < 991) {
    return DeviceSize.tablet;
  } else {
    return DeviceSize.desktop;
  }
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF007BFF);
  late Color secondary = const Color(0xFF6C757D);
  late Color tertiary = const Color(0xFF28A745);
  late Color alternate = const Color(0xFFFFC107);
  late Color primaryText = const Color(0xFF212529);
  late Color secondaryText = const Color(0xFF6C757D);
  late Color primaryBackground = const Color(0xFFF8F9FA);
  late Color secondaryBackground = const Color(0xFFE9ECEF);
  late Color accent1 = const Color(0xFF17A2B8);
  late Color accent2 = const Color(0xFF6610F2);
  late Color accent3 = const Color(0xFFDC3545);
  late Color accent4 = const Color(0xFFFFC107);
  late Color success = const Color(0xFF28A745);
  late Color warning = const Color(0xFFFFC107);
  late Color error = const Color(0xFFDC3545);
  late Color info = const Color(0xFF17A2B8);
}

abstract class Typography {
  String get displayLargeFamily;
  bool get displayLargeIsCustom;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  bool get displayMediumIsCustom;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  bool get displaySmallIsCustom;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  bool get headlineLargeIsCustom;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  bool get headlineMediumIsCustom;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  bool get headlineSmallIsCustom;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  bool get titleLargeIsCustom;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  bool get titleMediumIsCustom;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  bool get titleSmallIsCustom;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  bool get labelLargeIsCustom;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  bool get labelMediumIsCustom;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  bool get labelSmallIsCustom;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  bool get bodyLargeIsCustom;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  bool get bodyMediumIsCustom;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  bool get bodySmallIsCustom;
  TextStyle get bodySmall;
}

class MobileTypography extends Typography {
  MobileTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Plus Jakarta Sans';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 64.0,
      );
  String get displayMediumFamily => 'Plus Jakarta Sans';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 44.0,
      );
  String get displaySmallFamily => 'Plus Jakarta Sans';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Plus Jakarta Sans';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Plus Jakarta Sans';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
      );
  String get headlineSmallFamily => 'Plus Jakarta Sans';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Plus Jakarta Sans';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      );
  String get titleMediumFamily => 'Plus Jakarta Sans';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      );
  String get titleSmallFamily => 'Plus Jakarta Sans';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'Noto Sans';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Noto Sans';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Noto Sans';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Noto Sans';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Noto Sans';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Noto Sans';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
}

class TabletTypography extends Typography {
  TabletTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Plus Jakarta Sans';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 64.0,
      );
  String get displayMediumFamily => 'Plus Jakarta Sans';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 44.0,
      );
  String get displaySmallFamily => 'Plus Jakarta Sans';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Plus Jakarta Sans';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Plus Jakarta Sans';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
      );
  String get headlineSmallFamily => 'Plus Jakarta Sans';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Plus Jakarta Sans';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      );
  String get titleMediumFamily => 'Plus Jakarta Sans';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      );
  String get titleSmallFamily => 'Plus Jakarta Sans';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'Noto Sans';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Noto Sans';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Noto Sans';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Noto Sans';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Noto Sans';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Noto Sans';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
}

class DesktopTypography extends Typography {
  DesktopTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Plus Jakarta Sans';
  bool get displayLargeIsCustom => false;
  TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 64.0,
      );
  String get displayMediumFamily => 'Plus Jakarta Sans';
  bool get displayMediumIsCustom => false;
  TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 44.0,
      );
  String get displaySmallFamily => 'Plus Jakarta Sans';
  bool get displaySmallIsCustom => false;
  TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Plus Jakarta Sans';
  bool get headlineLargeIsCustom => false;
  TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Plus Jakarta Sans';
  bool get headlineMediumIsCustom => false;
  TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 28.0,
      );
  String get headlineSmallFamily => 'Plus Jakarta Sans';
  bool get headlineSmallIsCustom => false;
  TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Plus Jakarta Sans';
  bool get titleLargeIsCustom => false;
  TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
      );
  String get titleMediumFamily => 'Plus Jakarta Sans';
  bool get titleMediumIsCustom => false;
  TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18.0,
      );
  String get titleSmallFamily => 'Plus Jakarta Sans';
  bool get titleSmallIsCustom => false;
  TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'Noto Sans';
  bool get labelLargeIsCustom => false;
  TextStyle get labelLarge => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Noto Sans';
  bool get labelMediumIsCustom => false;
  TextStyle get labelMedium => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Noto Sans';
  bool get labelSmallIsCustom => false;
  TextStyle get labelSmall => GoogleFonts.notoSans(
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Noto Sans';
  bool get bodyLargeIsCustom => false;
  TextStyle get bodyLarge => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Noto Sans';
  bool get bodyMediumIsCustom => false;
  TextStyle get bodyMedium => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Noto Sans';
  bool get bodySmallIsCustom => false;
  TextStyle get bodySmall => GoogleFonts.notoSans(
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
}

class DarkModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF1E90FF);
  late Color secondary = const Color(0xFFA9A9A9);
  late Color tertiary = const Color(0xFF3CB371);
  late Color alternate = const Color(0xFFFFD700);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFFD3D3D3);
  late Color primaryBackground = const Color(0xFF343A40);
  late Color secondaryBackground = const Color(0xFF495057);
  late Color accent1 = const Color(0xFF20B2AA);
  late Color accent2 = const Color(0xFF8A2BE2);
  late Color accent3 = const Color(0xFFFF4500);
  late Color accent4 = const Color(0xFFFFA500);
  late Color success = const Color(0xFF32CD32);
  late Color warning = const Color(0xFFFFD700);
  late Color error = const Color(0xFFFF6347);
  late Color info = const Color(0xFF20B2AA);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    TextStyle? font,
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = false,
    TextDecoration? decoration,
    double? lineHeight,
    List<Shadow>? shadows,
    String? package,
  }) {
    if (useGoogleFonts && fontFamily != null) {
      font = GoogleFonts.getFont(fontFamily,
          fontWeight: fontWeight ?? this.fontWeight,
          fontStyle: fontStyle ?? this.fontStyle);
    }

    return font != null
        ? font.copyWith(
            color: color ?? this.color,
            fontSize: fontSize ?? this.fontSize,
            letterSpacing: letterSpacing ?? this.letterSpacing,
            fontWeight: fontWeight ?? this.fontWeight,
            fontStyle: fontStyle ?? this.fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          )
        : copyWith(
            fontFamily: fontFamily,
            package: package,
            color: color,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: decoration,
            height: lineHeight,
            shadows: shadows,
          );
  }
}
