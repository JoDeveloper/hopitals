import 'package:flutter/material.dart';

import 'screens/add.dart';
import 'screens/drugs.dart';
import 'screens/home.dart';
import 'screens/hospitals.dart';

abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case 'add':
        return MaterialPageRoute(
            builder: (context) => AddHospital(
                  type: settings.arguments,
                ));
      case 'hospitals':
        return MaterialPageRoute(builder: (context) => Hospitals());
      case 'pharmacy':
        return MaterialPageRoute(builder: (context) => Drugs());

      default:
        return MaterialPageRoute(builder: (context) => Home());
    }
  }
}
