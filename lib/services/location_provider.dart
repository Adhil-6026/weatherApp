import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/services/location_service.dart';
//import 'package:http/http.dart' as http;

//const apiKey = '1227ff650a5c4dd6b518b86dcdf3503b';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  final LocationService _locationService = LocationService();
  Placemark? _currentLocationName;
  Placemark? get currentLocationName => _currentLocationName;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      _currentLocationName = null;
      notifyListeners();
      return;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        _currentLocationName = null;
        notifyListeners();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _currentLocationName = null;
      notifyListeners();
      return;
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    print(_currentPosition);
    _currentLocationName =
        await _locationService.getLocationName(_currentPosition);
    print(_currentLocationName);

    notifyListeners();
  }
}
