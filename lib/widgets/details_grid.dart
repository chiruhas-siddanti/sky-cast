import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../utils/formatters.dart';
import 'glass_card.dart';

/// Grid of extra measurements: humidity, wind, pressure, rain, sun times.
class DetailsGrid extends StatelessWidget {
  final WeatherReport report;
  final bool useCelsius;

  const DetailsGrid({
    super.key,
    required this.report,
    required this.useCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final c = report.current;
    final today = report.daily.first;

    final items = <_Detail>[
      _Detail(Icons.water_drop_outlined, 'Humidity', '${c.humidity}%'),
      _Detail(Icons.air, 'Wind', Fmt.wind(c.windKmh, useCelsius)),
      _Detail(Icons.speed, 'Pressure', '${c.pressure.round()} hPa'),
      _Detail(Icons.umbrella_outlined, 'Chance of rain', '${today.rainChance}%'),
      _Detail(Icons.wb_twilight, 'Sunrise', Fmt.time(today.sunrise)),
      _Detail(Icons.nights_stay_outlined, 'Sunset', Fmt.time(today.sunset)),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.3,
      children: items.map(_tile).toList(),
    );
  }

  Widget _tile(_Detail d) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(d.icon, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d.label, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 2),
                Text(
                  d.value,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Detail {
  final IconData icon;
  final String label;
  final String value;
  const _Detail(this.icon, this.label, this.value);
}
