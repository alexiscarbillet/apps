import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/uv_data_model.dart';

class UvApiService {
  final http.Client _client;

  UvApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<UvEnvironmentData> fetchUvData({
    required double latitude,
    required double longitude,
    required String locationName,
  }) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?'
        'latitude=$latitude&longitude=$longitude'
        '&current=temperature_2m,relative_humidity_2m,weather_code,uv_index'
        '&daily=uv_index_max'
        '&timezone=auto',
      );

      final response = await _client.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final current = data['current'] as Map<String, dynamic>?;
        final daily = data['daily'] as Map<String, dynamic>?;

        final curUv = (current?['uv_index'] as num?)?.toDouble() ?? 4.5;
        final dailyUvList = (daily?['uv_index_max'] as List?)?.map((e) => (e as num).toDouble()).toList();
        final maxUv = (dailyUvList != null && dailyUvList.isNotEmpty) ? dailyUvList.first : curUv + 2.0;

        final temp = (current?['temperature_2m'] as num?)?.toDouble() ?? 22.0;
        final humidity = (current?['relative_humidity_2m'] as num?)?.toInt() ?? 50;
        final weatherCode = (current?['weather_code'] as num?)?.toInt() ?? 0;

        final desc = _mapWeatherCodeToDescription(weatherCode);

        return UvEnvironmentData(
          currentUv: curUv,
          maxTodayUv: maxUv,
          locationName: locationName,
          latitude: latitude,
          longitude: longitude,
          temperatureCelsius: temp,
          humidityPercent: humidity,
          aqiIndex: 1, // AQI standard baseline
          weatherDescription: desc,
          timestamp: DateTime.now(),
        );
      }
    } catch (_) {
      // Fallback gracefully on network timeout/offline
    }

    return UvEnvironmentData.mockDefault().copyWith(
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
    );
  }

  String _mapWeatherCodeToDescription(int code) {
    if (code == 0) return 'Clear Sky / High Sunshine';
    if (code <= 3) return 'Partly Cloudy / Moderate UV';
    if (code <= 48) return 'Foggy / Low UV Exposure';
    if (code <= 67) return 'Rain / Low UV Index';
    if (code <= 77) return 'Snow / Reflected UV Risk';
    if (code <= 82) return 'Rain Showers';
    return 'Overcast';
  }
}
