import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_models.dart';

/// Error with a message that is safe to show to the user.
class WeatherException implements Exception {
  final String message;
  const WeatherException(this.message);

  @override
  String toString() => message;
}

/// Talks to the free Open-Meteo APIs (no API key required).
class WeatherService {
  static const _geoHost = 'geocoding-api.open-meteo.com';
  static const _forecastHost = 'api.open-meteo.com';

  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  /// Finds up to five places matching [query].
  Future<List<Place>> searchPlaces(String query) async {
    final uri = Uri.https(_geoHost, '/v1/search', {
      'name': query,
      'count': '5',
      'language': 'en',
      'format': 'json',
    });
    final body = await _getJson(uri);
    final results = body['results'] as List<dynamic>?;
    if (results == null) return [];
    return results
        .map((e) => Place.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Downloads current conditions, 24 hours and 7 days of forecast.
  Future<WeatherReport> fetchWeather(Place place) async {
    final uri = Uri.https(_forecastHost, '/v1/forecast', {
      'latitude': place.latitude.toString(),
      'longitude': place.longitude.toString(),
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,'
          'is_day,weather_code,wind_speed_10m,surface_pressure',
      'hourly': 'temperature_2m,weather_code,is_day',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,'
          'precipitation_probability_max,sunrise,sunset',
      'timezone': 'auto',
      'forecast_days': '7',
    });
    final body = await _getJson(uri);

    final current =
        CurrentWeather.fromJson(body['current'] as Map<String, dynamic>);
    final hourly = _parseHourly(body['hourly'] as Map<String, dynamic>, current);
    final daily = _parseDaily(body['daily'] as Map<String, dynamic>);

    return WeatherReport(
      place: place,
      current: current,
      hourly: hourly,
      daily: daily,
    );
  }

  List<HourlyPoint> _parseHourly(
    Map<String, dynamic> json,
    CurrentWeather current,
  ) {
    final times = json['time'] as List<dynamic>;
    final temps = json['temperature_2m'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final days = json['is_day'] as List<dynamic>;

    // Start from the current hour, e.g. "2026-11-08T20".
    final currentHour = current.time.toIso8601String().substring(0, 13);

    final points = <HourlyPoint>[];
    for (var i = 0; i < times.length; i++) {
      final t = times[i] as String;
      if (t.substring(0, 13).compareTo(currentHour) < 0) continue;
      points.add(HourlyPoint(
        time: DateTime.parse(t),
        temperature: (temps[i] as num).toDouble(),
        code: (codes[i] as num).toInt(),
        isDay: (days[i] as num).toInt() == 1,
      ));
      if (points.length == 24) break;
    }
    return points;
  }

  List<DailyPoint> _parseDaily(Map<String, dynamic> json) {
    final dates = json['time'] as List<dynamic>;
    final codes = json['weather_code'] as List<dynamic>;
    final maxes = json['temperature_2m_max'] as List<dynamic>;
    final mins = json['temperature_2m_min'] as List<dynamic>;
    final rain = json['precipitation_probability_max'] as List<dynamic>;
    final rises = json['sunrise'] as List<dynamic>;
    final sets = json['sunset'] as List<dynamic>;

    return List.generate(dates.length, (i) {
      return DailyPoint(
        date: DateTime.parse(dates[i] as String),
        code: (codes[i] as num).toInt(),
        maxTemp: (maxes[i] as num).toDouble(),
        minTemp: (mins[i] as num).toDouble(),
        rainChance: rain[i] == null ? 0 : (rain[i] as num).toInt(),
        sunrise: DateTime.parse(rises[i] as String),
        sunset: DateTime.parse(sets[i] as String),
      );
    });
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response =
          await _client.get(uri).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw WeatherException(
            'The weather service returned an error (${response.statusCode}).');
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on WeatherException {
      rethrow;
    } catch (_) {
      throw const WeatherException(
          'Could not reach the weather service. Check your internet connection.');
    }
  }
}
