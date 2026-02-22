import 'package:flutter/material.dart';

/// Responsive design constants and helpers for the perps page
class PerpResponsive {
  // Breakpoints
  static const double mobileMax = 800;
  static const double tabletMax = 1200;
  static const double desktopMin = 1200;

  // Layout proportions for 3-column layout
  static const double desktopChartFlex = 55; // Chart takes 55%
  static const double desktopVisualizerFlex = 20; // Visualizer takes 20%
  static const double desktopTradingFlex = 25; // Trading takes 25%

  // Tablet layout (2-column)
  static const double tabletChartFlex = 60;
  static const double tabletTradingFlex = 40;

  static Size getSize(BuildContext context) => MediaQuery.of(context).size;

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) =>
      getWidth(context) < mobileMax;

  static bool isTablet(BuildContext context) =>
      getWidth(context) >= mobileMax && getWidth(context) < desktopMin;

  static bool isDesktop(BuildContext context) =>
      getWidth(context) >= desktopMin;

  static EdgeInsets getPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(12);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  static double getChartHeight(BuildContext context) {
    final height = getHeight(context);
    if (isMobile(context)) {
      return height * 0.4;
    } else if (isTablet(context)) {
      return height * 0.45;
    } else {
      return 420;
    }
  }

  static double getGap(BuildContext context) {
    if (isMobile(context)) {
      return 8;
    } else if (isTablet(context)) {
      return 12;
    } else {
      return 16;
    }
  }
}

/// Responsive layout builder that handles different screen sizes
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < PerpResponsive.mobileMax) {
          return mobile;
        } else if (constraints.maxWidth < PerpResponsive.desktopMin) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}

/// Helper to build responsive chart that scales to available space
class ResponsiveChart extends StatelessWidget {
  const ResponsiveChart({
    super.key,
    required this.child,
    this.minHeight = 200,
  });

  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(minHeight, PerpResponsive.getChartHeight(context)),
      child: child,
    );
  }
}

/// Helper for responsive stat cards row
class ResponsiveStatCardsRow extends StatelessWidget {
  const ResponsiveStatCardsRow({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = PerpResponsive.getGap(context);

    if (PerpResponsive.isMobile(context)) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              SizedBox(
                width: 160,
                child: children[i],
              ),
            ],
          ],
        ),
      );
    } else if (PerpResponsive.isTablet(context)) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              SizedBox(
                width: 170,
                child: children[i],
              ),
            ],
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) SizedBox(width: gap),
              SizedBox(
                width: 180,
                child: children[i],
              ),
            ],
          ],
        ),
      );
    }
  }
}

/// Helper for 3-column layout (desktop) or 2-column (tablet) or stacked (mobile)
class ResponsivePerpsLayout extends StatelessWidget {
  const ResponsivePerpsLayout({
    super.key,
    required this.chart,
    required this.visualizer,
    required this.trading,
    required this.tabsPanel,
  });

  final Widget chart;
  final Widget visualizer;
  final Widget trading;
  final Widget tabsPanel;

  @override
  Widget build(BuildContext context) {
    final gap = PerpResponsive.getGap(context);

    if (PerpResponsive.isMobile(context)) {
      // Mobile: stacked vertically
      return SingleChildScrollView(
        child: Column(
          children: [
            chart,
            SizedBox(height: gap),
            visualizer,
            SizedBox(height: gap),
            trading,
          ],
        ),
      );
    } else if (PerpResponsive.isTablet(context)) {
      // Tablet: 2-column layout
      return Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 60,
                  child: Column(
                    children: [
                      chart,
                      SizedBox(height: gap),
                      visualizer,
                    ],
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  flex: 40,
                  child: trading,
                ),
              ],
            ),
          ),
          tabsPanel,
        ],
      );
    } else {
      // Desktop: 3-column layout
      return Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 55,
                child: chart,
              ),
              SizedBox(width: gap),
              Expanded(
                flex: 20,
                child: visualizer,
              ),
              SizedBox(width: gap),
              Expanded(
                flex: 25,
                child: trading,
              ),
            ],
          ),
          tabsPanel,
        ],
      );
    }
  }
}

double max(double a, double b) => a > b ? a : b;

/// 3-column layout (desktop) or 2-column (tablet) or stacked (mobile) - WITHOUT side tabs
class ResponsivePerpsLayoutWithoutTabs extends StatelessWidget {
  const ResponsivePerpsLayoutWithoutTabs({
    super.key,
    required this.chart,
    required this.visualizer,
    required this.trading,
  });

  final Widget chart;
  final Widget visualizer;
  final Widget trading;

  @override
  Widget build(BuildContext context) {
    final gap = PerpResponsive.getGap(context);

    if (PerpResponsive.isMobile(context)) {
      // Mobile: stacked vertically
      return SingleChildScrollView(
        child: Column(
          children: [
            chart,
            SizedBox(height: gap),
            visualizer,
            SizedBox(height: gap),
            trading,
          ],
        ),
      );
    } else if (PerpResponsive.isTablet(context)) {
      // Tablet: 2-column layout
      return SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 60,
              child: Column(
                children: [
                  chart,
                  SizedBox(height: gap),
                  visualizer,
                ],
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              flex: 40,
              child: trading,
            ),
          ],
        ),
      );
    } else {
      // Desktop: 3-column layout
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 55,
            child: chart,
          ),
          SizedBox(width: gap),
          Expanded(
            flex: 20,
            child: visualizer,
          ),
          SizedBox(width: gap),
          Expanded(
            flex: 25,
            child: trading,
          ),
        ],
      );
    }
  }
}
