/// Small helpers for turning raw numbers and dates into display text.
class Fmt {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  /// Temperature stored in Celsius, shown in the selected unit.
  static String temp(double celsius, bool useCelsius) {
    final value = useCelsius ? celsius : celsius * 9 / 5 + 32;
    return '${value.round()}°';
  }

  static String wind(double kmh, bool metric) {
    return metric
        ? '${kmh.round()} km/h'
        : '${(kmh * 0.621371).round()} mph';
  }

  /// "8 PM" style label for the hourly forecast.
  static String hour(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    return '$h ${t.hour < 12 ? 'AM' : 'PM'}';
  }

  /// "6:05 AM" style time.
  static String time(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.hour < 12 ? 'AM' : 'PM'}';
  }

  static String day(DateTime d, {bool isToday = false}) =>
      isToday ? 'Today' : _days[d.weekday - 1];
}
