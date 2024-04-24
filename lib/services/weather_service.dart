import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:minimal_weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey = dotenv.env['WEATHER_API_KEY'] ??
      "default_api_key"; // Provide a default or handle null appropriately

  WeatherService();

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.formJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather Data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city = placemarks[0].locality;

    return city ?? "";
  }
}
