import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../utils/formatters.dart';
import '../utils/weather_codes.dart';
import 'glass_card.dart';

/// Large card with the city name, temperature and condition.
class CurrentWeatherCard extends StatelessWidget {
  final WeatherReport report;
  final bool useCelsius;

  const CurrentWeatherCard({
    super.key,
    required this.report,
    required this.useCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final current = report.current;
    final today = report.daily.first;

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  report.place.fullLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Icon(WeatherCodes.icon(current.code, current.isDay), size: 84),
          const SizedBox(height: 4),
          Text(
            Fmt.temp(current.temperature, useCelsius),
            style: const TextStyle(fontSize: 76, fontWeight: FontWeight.w300),
          ),
          Text(
            WeatherCodes.describe(current.code),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'H: ${Fmt.temp(today.maxTemp, useCelsius)}   '
            'L: ${Fmt.temp(today.minTemp, useCelsius)}   '
            'Feels like ${Fmt.temp(current.feelsLike, useCelsius)}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
