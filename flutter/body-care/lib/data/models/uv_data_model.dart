enum UvCategory { low, moderate, high, veryHigh, extreme }

class UvEnvironmentData {
  final double currentUv;
  final double maxTodayUv;
  final String locationName;
  final double latitude;
  final double longitude;
  final double temperatureCelsius;
  final int humidityPercent;
  final int aqiIndex; // 1-5 Air Quality (1: Good, 2: Fair, 3: Moderate, 4: Poor, 5: Very Poor)
  final String weatherDescription;
  final DateTime timestamp;
  final DateTime? sunscreenAppliedAt;

  const UvEnvironmentData({
    required this.currentUv,
    required this.maxTodayUv,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.temperatureCelsius,
    required this.humidityPercent,
    required this.aqiIndex,
    required this.weatherDescription,
    required this.timestamp,
    this.sunscreenAppliedAt,
  });

  UvCategory get uvCategory {
    if (currentUv < 3.0) return UvCategory.low;
    if (currentUv < 6.0) return UvCategory.moderate;
    if (currentUv < 8.0) return UvCategory.high;
    if (currentUv < 11.0) return UvCategory.veryHigh;
    return UvCategory.extreme;
  }

  String get riskLabel {
    switch (uvCategory) {
      case UvCategory.low:
        return 'Low (Safe)';
      case UvCategory.moderate:
        return 'Moderate (Protection Needed)';
      case UvCategory.high:
        return 'High (Sun Protection Vital)';
      case UvCategory.veryHigh:
        return 'Very High (High Risk)';
      case UvCategory.extreme:
        return 'Extreme (Avoid Direct Sun)';
    }
  }

  bool get isSunscreenRecommended => currentUv >= 3.0 || maxTodayUv >= 3.0;

  List<String> get actionableRecommendations {
    final list = <String>[];
    if (currentUv < 3.0) {
      list.add('UV is low. Minimal protection needed unless near reflective surfaces.');
      list.add('Safe for early morning / late afternoon natural vitamin D synthesis.');
    } else if (currentUv < 6.0) {
      list.add('Apply SPF 30+ or 50+ broad-spectrum sunscreen.');
      list.add('Wear UV-400 blocking sunglasses when outdoors.');
      list.add('Seek shade during midday solar peaks (11 AM - 3 PM).');
    } else if (currentUv < 8.0) {
      list.add('Mandatory SPF 50+ broad-spectrum mineral sunscreen.');
      list.add('Wear a wide-brim hat and UV-protective clothing (UPF 50+).');
      list.add('Reapply sunscreen every 2 hours or after sweating/swimming.');
      list.add('Reduce direct sun exposure between 10 AM and 4 PM.');
    } else {
      list.add('CRITICAL: Extreme UV radiation. Unprotected skin can burn in minutes.');
      list.add('Avoid direct outdoor exposure between 10 AM and 4 PM.');
      list.add('Cover all exposed skin, wear wrap-around UV sunglasses & SPF 50+.');
    }
    return list;
  }

  UvEnvironmentData copyWith({
    double? currentUv,
    double? maxTodayUv,
    String? locationName,
    double? latitude,
    double? longitude,
    double? temperatureCelsius,
    int? humidityPercent,
    int? aqiIndex,
    String? weatherDescription,
    DateTime? timestamp,
    DateTime? sunscreenAppliedAt,
  }) {
    return UvEnvironmentData(
      currentUv: currentUv ?? this.currentUv,
      maxTodayUv: maxTodayUv ?? this.maxTodayUv,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      temperatureCelsius: temperatureCelsius ?? this.temperatureCelsius,
      humidityPercent: humidityPercent ?? this.humidityPercent,
      aqiIndex: aqiIndex ?? this.aqiIndex,
      weatherDescription: weatherDescription ?? this.weatherDescription,
      timestamp: timestamp ?? this.timestamp,
      sunscreenAppliedAt: sunscreenAppliedAt ?? this.sunscreenAppliedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'currentUv': currentUv,
    'maxTodayUv': maxTodayUv,
    'locationName': locationName,
    'latitude': latitude,
    'longitude': longitude,
    'temperatureCelsius': temperatureCelsius,
    'humidityPercent': humidityPercent,
    'aqiIndex': aqiIndex,
    'weatherDescription': weatherDescription,
    'timestamp': timestamp.toIso8601String(),
    'sunscreenAppliedAt': sunscreenAppliedAt?.toIso8601String(),
  };

  factory UvEnvironmentData.fromJson(Map<String, dynamic> json) => UvEnvironmentData(
    currentUv: (json['currentUv'] as num?)?.toDouble() ?? 4.2,
    maxTodayUv: (json['maxTodayUv'] as num?)?.toDouble() ?? 6.8,
    locationName: json['locationName'] as String? ?? 'Montreal, QC',
    latitude: (json['latitude'] as num?)?.toDouble() ?? 45.5017,
    longitude: (json['longitude'] as num?)?.toDouble() ?? -73.5673,
    temperatureCelsius: (json['temperatureCelsius'] as num?)?.toDouble() ?? 22.0,
    humidityPercent: json['humidityPercent'] as int? ?? 55,
    aqiIndex: json['aqiIndex'] as int? ?? 1,
    weatherDescription: json['weatherDescription'] as String? ?? 'Partly Cloudy',
    timestamp: json['timestamp'] != null
        ? DateTime.parse(json['timestamp'] as String)
        : DateTime.now(),
    sunscreenAppliedAt: json['sunscreenAppliedAt'] != null
        ? DateTime.parse(json['sunscreenAppliedAt'] as String)
        : null,
  );

  static UvEnvironmentData mockDefault() => UvEnvironmentData(
    currentUv: 5.4,
    maxTodayUv: 7.2,
    locationName: 'Montreal, QC',
    latitude: 45.5017,
    longitude: -73.5673,
    temperatureCelsius: 21.5,
    humidityPercent: 52,
    aqiIndex: 1,
    weatherDescription: 'Sunny / Moderate UV',
    timestamp: DateTime.now(),
  );
}
