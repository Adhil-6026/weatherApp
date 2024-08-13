import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import '../models/weather_response_model.dart';
import '../data/api.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = "";
  String get error => _error;

  Future<void> fetchWeatherData(Position position) async {
    _isLoading = true;
    _error = "";

    try {
      final String apiUrl =
          "${APIEndPoints().url}lat=${position.latitude}&lon=${position.longitude}"
          "&appid=${APIEndPoints().apiKey}${APIEndPoints().unit}";

      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        _weather = WeatherModel.fromJson(data);
        print(_weather!.main!.feelsLike);
        notifyListeners();
      } else {
        _error = "Failed to load data...";
        print(response.statusCode);
        print(_error);
        notifyListeners();
      }
    } catch (e) {
      _error = "Failed to load data$e";
    } finally {
      _isLoading = false;
    }
  }

  Future<void> fetchWeatherDataByCity(String city) async {
    _isLoading = true;
    _error = "";

    try {
      final String apiUrl = "${APIEndPoints().url}q=${city}"
          "&appid=${APIEndPoints().apiKey}${APIEndPoints().unit}";

      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        _weather = WeatherModel.fromJson(data);
        print(_weather!.main!.feelsLike);
        notifyListeners();
      } else {
        _error = "Failed to load data...";
        print(response.statusCode);
        print(_error);
        notifyListeners();
      }
    } catch (e) {
      _error = "Failed to load data$e";
    } finally {
      _isLoading = false;
    }
  }
}
