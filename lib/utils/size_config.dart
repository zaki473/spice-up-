import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;

  // Ukuran dasar desain, biasanya menggunakan ukuran iPhone 13/14 (390 x 844) 
  // atau standar figma (375 x 812). Sesuaikan dengan base design di Figma.
  static const double designWidth = 390.0;
  static const double designHeight = 844.0;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }
}

extension ResponsiveSize on num {
  /// Responsive Width (scaling horizontal)
  double get w => (this / SizeConfig.designWidth) * SizeConfig.screenWidth;

  /// Responsive Height (scaling vertical)
  double get h => (this / SizeConfig.designHeight) * SizeConfig.screenHeight;

  /// Responsive Font Size (scaling berdasarkan lebar agar konsisten)
  double get sp => (this / SizeConfig.designWidth) * SizeConfig.screenWidth;
}
