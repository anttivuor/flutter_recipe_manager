import 'package:flutter/widgets.dart';

class AppBreakpoints {
    // Width thresholds
    static const double mobile = 480;
    static const double tablet = 768;

    static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= mobile;

    static bool isTablet(BuildContext context) {
        final width = MediaQuery.of(context).size.width;
        return width > mobile && width <= tablet;
    }

    static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width > tablet;
}