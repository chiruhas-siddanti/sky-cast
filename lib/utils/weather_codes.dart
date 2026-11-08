import 'package:flutter/material.dart';

/// Converts WMO weather codes (used by Open-Meteo) into text, icons and colours.
class WeatherCodes {
  static String describe(int code) {
    switch (code) {
      case 0:
        return 'Clear sky';
      case 1:
        return 'Mainly clear';
      case 2:
        return 'Partly cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 56:
      case 57:
        return 'Freezing drizzle';
      case 61:
        return 'Light rain';
      case 63:
        return 'Moderate rain';
      case 65:
        return 'Heavy rain';
      case 66:
      case 67:
        return 'Freezing rain';
      case 71:
      case 73:
      case 75:
        return 'Snowfall';
      case 77:
        return 'Snow grains';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 85:
      case 86:
        return 'Snow showers';
      case 95:
        return 'Thunderstorm';
      case 96:
      case 99:
        return 'Thunderstorm with hail';
      default:
        return 'Unknown';
    }
  }

  static IconData icon(int code, bool isDay) {
    if (code == 0 || code == 1) {
      return isDay ? Icons.wb_sunny : Icons.nights_stay;
    }
    if (code == 2) return isDay ? Icons.wb_cloudy : Icons.cloud;
    if (code == 3) return Icons.cloud;
    if (code == 45 || code == 48) return Icons.dehaze;
    if (code >= 51 && code <= 57) return Icons.grain;
    if (code >= 61 && code <= 67) return Icons.water_drop;
    if (code >= 71 && code <= 77) return Icons.ac_unit;
    if (code >= 80 && code <= 82) return Icons.water_drop;
    if (code == 85 || code == 86) return Icons.ac_unit;
    if (code >= 95) return Icons.thunderstorm;
    return Icons.cloud_queue;
  }

  /// Background gradient that matches the weather and time of day.
  static List<Color> gradient(int code, bool isDay) {
    if (code >= 95) {
      return const [Color(0xFF232526), Color(0xFF414345)];
    }
    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return const [Color(0xFF373B44), Color(0xFF4286F4)];
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return const [Color(0xFF4B6CB7), Color(0xFF182848)];
    }
    if (code == 45 || code == 48) {
      return const [Color(0xFF757F9A), Color(0xFF4B5568)];
    }
    if (code == 3 || code == 2) {
      return isDay
          ? const [Color(0xFF606C88), Color(0xFF3F4C6B)]
          : const [Color(0xFF232526), Color(0xFF3F4C6B)];
    }
    return isDay
        ? const [Color(0xFF2193B0), Color(0xFF6DD5ED)]
        : const [Color(0xFF0F2027), Color(0xFF2C5364)];
  }
}
