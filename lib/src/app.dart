import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'route.dart';
import 'screens/home.dart';
import 'services/hospital_service.dart';

final hospitalService = HospitalService();

class HospitalApp extends StatefulWidget {
  @override
  _HospitalAppState createState() => _HospitalAppState();
}

class _HospitalAppState extends State<HospitalApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => hospitalService),
      ],
      child: MaterialApp(
        title: 'نحن معاك',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.tajawalTextTheme(),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Home(),
      ),
    );
  }

  @override
  void dispose() {
    hospitalService.dispose();
    super.dispose();
  }
}
