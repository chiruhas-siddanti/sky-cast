import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../utils/formatters.dart';
import '../utils/weather_codes.dart';
import 'glass_card.dart';

/// Horizontally scrollable list of the next 24 hours.
class HourlyForecast extends StatelessWidget {
  final List<HourlyPoint> hours;
  final bool useCelsius;

  const HourlyForecast({
    super.key,
    required this.hours,
    required this.useCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              'HOURLY FORECAST',
              style: TextStyle(fontSize: 12, letterSpacing: 1.2),
            ),
          ),
          SizedBox(
            height: 104,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hours.length,
              itemBuilder: (context, i) {
                final h = hours[i];
                return Container(
                  width: 66,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(i == 0 ? 'Now' : Fmt.hour(h.time),
                          style: const TextStyle(fontSize: 13)),
                      Icon(WeatherCodes.icon(h.code, h.isDay), size: 28),
                      Text(Fmt.temp(h.temperature, useCelsius),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
