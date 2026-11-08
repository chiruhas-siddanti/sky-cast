import 'package:flutter_test/flutter_test.dart';
import 'package:skycast/utils/formatters.dart';

void main() {
  test('converts Celsius to Fahrenheit', () {
    expect(Fmt.temp(0, true), '0°');
    expect(Fmt.temp(0, false), '32°');
    expect(Fmt.temp(100, false), '212°');
  });

  test('formats 12-hour time', () {
    expect(Fmt.hour(DateTime(2026, 1, 1, 0)), '12 AM');
    expect(Fmt.hour(DateTime(2026, 1, 1, 15)), '3 PM');
    expect(Fmt.time(DateTime(2026, 1, 1, 6, 5)), '6:05 AM');
  });
}
