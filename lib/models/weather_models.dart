/// A searchable location returned by the geocoding API.
class Place {
  final String name;
  final String? region;
  final String country;
  final double latitude;
  final double longitude;

  const Place({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] as String,
      region: json['admin1'] as String?,
      country: (json['country'] as String?) ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Short label such as "Hyderabad, Telangana".
  String get label {
    final parts = <String>[name];
    if (region != null && region!.isNotEmpty && region != name) {
      parts.add(region!);
    }
    return parts.join(', ');
  }

  /// Full label including the country.
  String get fullLabel => country.isEmpty ? label : '$label, $country';
}

/// Weather right now at a location. Temperatures are stored in Celsius.
class CurrentWeather {
  final DateTime time;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windKmh;
  final double pressure;
  final int code;
  final bool isDay;

  const CurrentWeather({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windKmh,
    required this.pressure,
    required this.code,
    required this.isDay,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: DateTime.parse(json['time'] as String),
      temperature: (json['temperature_2m'] as num).toDouble(),
      feelsLike: (json['apparent_temperature'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).round(),
      windKmh: (json['wind_speed_10m'] as num).toDouble(),
      pressure: (json['surface_pressure'] as num).toDouble(),
      code: (json['weather_code'] as num).toInt(),
      isDay: (json['is_day'] as num).toInt() == 1,
    );
  }
}

/// One hour of forecast data.
class HourlyPoint {
  final DateTime time;
  final double temperature;
  final int code;
  final bool isDay;

  const HourlyPoint({
    required this.time,
    required this.temperature,
    required this.code,
    required this.isDay,
  });
}

/// One day of forecast data.
class DailyPoint {
  final DateTime date;
  final int code;
  final double maxTemp;
  final double minTemp;
  final int rainChance;
  final DateTime sunrise;
  final DateTime sunset;

  const DailyPoint({
    required this.date,
    required this.code,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
    required this.sunrise,
    required this.sunset,
  });
}

/// Everything shown on the home screen for one location.
class WeatherReport {
  final Place place;
  final CurrentWeather current;
  final List<HourlyPoint> hourly;
  final List<DailyPoint> daily;

  const WeatherReport({
    required this.place,
    required this.current,
    required this.hourly,
    required this.daily,
  });
}
