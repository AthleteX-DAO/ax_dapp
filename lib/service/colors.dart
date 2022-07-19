import 'package:flutter/material.dart';

// Map to help create the various shades of a material color.
Map<int, Color> color = {
  50: const Color.fromRGBO(136, 14, 79, .1),
  100: const Color.fromRGBO(136, 14, 79, .2),
  200: const Color.fromRGBO(136, 14, 79, .3),
  300: const Color.fromRGBO(136, 14, 79, .4),
  400: const Color.fromRGBO(136, 14, 79, .5),
  500: const Color.fromRGBO(136, 14, 79, .6),
  600: const Color.fromRGBO(136, 14, 79, .7),
  700: const Color.fromRGBO(136, 14, 79, .8),
  800: const Color.fromRGBO(136, 14, 79, .9),
  900: const Color.fromRGBO(136, 14, 79, 1),
};
// Custom Colors for our app. In this case I'm going for a terminal look.
MaterialColor colorHackerHeading = MaterialColor(0xffe0e0e0, color);
MaterialColor colorHackerBorder = MaterialColor(0xff13690c, color);
MaterialColor colorHackerBackground = MaterialColor(0xff000000, color);
