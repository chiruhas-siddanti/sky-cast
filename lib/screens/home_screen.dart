import 'package:flutter/material.dart';

import '../models/weather_models.dart';
import '../services/weather_service.dart';
import '../utils/weather_codes.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/details_grid.dart';
import '../widgets/glass_card.dart';
import '../widgets/hourly_forecast.dart';

/// The single screen of the app: search bar, unit toggle and weather cards.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _defaultCity = 'Hyderabad';

  final _service = WeatherService();
  final _controller = TextEditingController();

  WeatherReport? _report;
  bool _loading = false;
  String? _error;
  bool _useCelsius = true;

  @override
  void initState() {
    super.initState();
    _searchCity(_defaultCity, askWhenMany: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Looks up a city by name, then loads its weather.
  Future<void> _searchCity(String query, {bool askWhenMany = true}) async {
    final text = query.trim();
    if (text.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final places = await _service.searchPlaces(text);
      if (!mounted) return;

      if (places.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No city found for "$text". Check the spelling and retry.';
        });
        return;
      }

      var chosen = places.first;
      if (places.length > 1 && askWhenMany) {
        final picked = await _pickPlace(places);
        if (!mounted) return;
        if (picked == null) {
          setState(() => _loading = false);
          return;
        }
        chosen = picked;
      }
      await _loadPlace(chosen);
    } on WeatherException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Something went wrong while searching. Please try again.';
      });
    }
  }

  /// Downloads the forecast for a known place.
  Future<void> _loadPlace(Place place) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final report = await _service.fetchWeather(place);
      if (!mounted) return;
      setState(() {
        _report = report;
        _loading = false;
      });
    } on WeatherException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Something went wrong while reading the weather data.';
      });
    }
  }

  /// Lets the user choose between several cities with the same name.
  Future<Place?> _pickPlace(List<Place> places) {
    return showModalBottomSheet<Place>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Select a location',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            for (final p in places)
              ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(p.label),
                subtitle: Text(p.country),
                onTap: () => Navigator.of(context).pop(p),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    final colors = report == null
        ? WeatherCodes.gradient(0, true)
        : WeatherCodes.gradient(report.current.code, report.current.isDay);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildUnitToggle(),
                  const SizedBox(height: 16),
                  ..._buildBody(report),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.cloud, size: 28),
        const SizedBox(width: 8),
        const Text('SkyCast',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Spacer(),
        IconButton(
          tooltip: 'Refresh',
          onPressed: (_report == null || _loading)
              ? null
              : () => _loadPlace(_report!.place),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onSubmitted: _searchCity,
      decoration: InputDecoration(
        hintText: 'Search city (e.g. Warangal, London)',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _searchCity(_controller.text),
        ),
        filled: true,
        fillColor: const Color(0x26FFFFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ChoiceChip(
          label: const Text('°C'),
          selected: _useCelsius,
          onSelected: (_) => setState(() => _useCelsius = true),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('°F'),
          selected: !_useCelsius,
          onSelected: (_) => setState(() => _useCelsius = false),
        ),
      ],
    );
  }

  List<Widget> _buildBody(WeatherReport? report) {
    if (_loading && report == null) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 80),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    return [
      if (_error != null)
        GlassCard(
          child: Row(
            children: [
              const Icon(Icons.error_outline),
              const SizedBox(width: 12),
              Expanded(child: Text(_error!)),
            ],
          ),
        ),
      if (_error != null) const SizedBox(height: 16),
      if (_loading) const LinearProgressIndicator(),
      if (_loading) const SizedBox(height: 16),
      if (report != null) ...[
        CurrentWeatherCard(report: report, useCelsius: _useCelsius),
        const SizedBox(height: 16),
        HourlyForecast(hours: report.hourly, useCelsius: _useCelsius),
        const SizedBox(height: 16),
        DetailsGrid(report: report, useCelsius: _useCelsius),
        const SizedBox(height: 16),
        DailyForecast(days: report.daily, useCelsius: _useCelsius),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Data: Open-Meteo.com',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    ];
  }
}
