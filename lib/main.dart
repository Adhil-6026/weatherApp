import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/screens/home_page.dart';
import 'package:weatherapp/services/location_provider.dart';
import 'package:weatherapp/services/weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => WeatherService()),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
            )),
        home: HomePage(),
      ),
    );
  }
}
