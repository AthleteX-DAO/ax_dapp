/// Standardized responsive breakpoints for consistent mobile-first layout
class ResponsiveConstants {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1160;
  static const double desktopMaxWidth = 1160;

  /// Determine device type based on width
  static DeviceType getDeviceType(double width) {
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if device is mobile
  static bool isMobile(double width) => width < mobileMaxWidth;

  /// Check if device is tablet or smaller
  static bool isTabletOrSmaller(double width) => width < tabletMaxWidth;

  /// Mobile padding constants
  static const double mobilePaddingSmall = 8;
  static const double mobilePaddingDefault = 12;
  static const double mobilePaddingMedium = 16;
  static const double mobilePaddingLarge = 20;

  /// Tablet padding constants
  static const double tabletPaddingDefault = 16;
  static const double tabletPaddingMedium = 20;
  static const double tabletPaddingLarge = 24;

  /// Card dimensions for grid
  static const double mobileCardHeight = 200;
  static const double tabletCardHeight = 240;
  static const double desktopCardHeight = 280;

  /// Get grid cross axis count based on width
  static int getGridCrossAxisCount(double width) {
    if (isMobile(width)) {
      return 1;
    } else if (width < 900) {
      return 2;
    } else if (width < 1400) {
      return 3;
    } else {
      return 4;
    }
  }

  /// Get padding based on device type
  static double getPadding(double width, {required PaddingSize size}) {
    final isMobileDevice = isMobile(width);
    switch (size) {
      case PaddingSize.small:
        return isMobileDevice ? mobilePaddingSmall : tabletPaddingDefault;
      case PaddingSize.medium:
        return isMobileDevice ? mobilePaddingMedium : tabletPaddingMedium;
      case PaddingSize.large:
        return isMobileDevice ? mobilePaddingLarge : tabletPaddingLarge;
    }
  }
}

enum DeviceType { mobile, tablet, desktop }

enum PaddingSize { small, medium, large }
