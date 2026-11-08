import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../utils/formatters.dart';
import '../utils/weather_codes.dart';
import 'glass_card.dart';

/// Seven-day forecast list.
class DailyForecast extends StatelessWidget {
  final List<DailyPoint> days;
  final bool useCelsius;

  const DailyForecast({
    super.key,
    required this.days,
    required this.useCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '7-DAY FORECAST',
            style: TextStyle(fontSize: 12, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < days.length; i++) _row(days[i], i == 0),
        ],
      ),
    );
  }

  Widget _row(DailyPoint d, bool isToday) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              Fmt.day(d.date, isToday: isToday),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(WeatherCodes.icon(d.code, true), size: 26),
          const SizedBox(width: 8),
          SizedBox(
            width: 44,
            child: Text(
              '${d.rainChance}%',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              WeatherCodes.describe(d.code),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Text(
            '${Fmt.temp(d.minTemp, useCelsius)} / ${Fmt.temp(d.maxTemp, useCelsius)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
