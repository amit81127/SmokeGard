import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum RiskLevel {
  safe('SAFE', AppColors.riskSafe, 'Low exposure detected. Environment is healthy and clean.'),
  moderate('MODERATE', AppColors.riskModerate, 'Elevated smoke or particulate levels. Exercise caution.'),
  high('HIGH RISK', AppColors.riskHigh, 'Hazardous smoke detected! Immediate protective action needed.');

  final String label;
  final Color color;
  final String description;

  const RiskLevel(this.label, this.color, this.description);
}

class SmokeMetrics {
  final double pm25; // in µg/m³
  final double voc; // in ppm
  final int pseiScore; // 0 - 100 Personal Smoke Exposure Index
  final int exposureTimeMinutes;
  final double carbonMonoxide; // ppm
  final double temperature; // °C
  final double humidity; // %
  final int aqi;

  const SmokeMetrics({
    required this.pm25,
    required this.voc,
    required this.pseiScore,
    required this.exposureTimeMinutes,
    required this.carbonMonoxide,
    required this.temperature,
    required this.humidity,
    required this.aqi,
  });

  RiskLevel get riskLevel {
    if (pseiScore <= 35) return RiskLevel.safe;
    if (pseiScore <= 65) return RiskLevel.moderate;
    return RiskLevel.high;
  }

  SmokeMetrics copyWith({
    double? pm25,
    double? voc,
    int? pseiScore,
    int? exposureTimeMinutes,
    double? carbonMonoxide,
    double? temperature,
    double? humidity,
    int? aqi,
  }) {
    return SmokeMetrics(
      pm25: pm25 ?? this.pm25,
      voc: voc ?? this.voc,
      pseiScore: pseiScore ?? this.pseiScore,
      exposureTimeMinutes: exposureTimeMinutes ?? this.exposureTimeMinutes,
      carbonMonoxide: carbonMonoxide ?? this.carbonMonoxide,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      aqi: aqi ?? this.aqi,
    );
  }
}

class AlertItem {
  final String id;
  final String title;
  final String subtitle;
  final RiskLevel riskLevel;
  final int pseiValue;
  final double pm25Value;
  final String location;
  final DateTime timestamp;
  final int durationMinutes;
  final bool isResolved;
  final List<String> recommendations;

  const AlertItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.riskLevel,
    required this.pseiValue,
    required this.pm25Value,
    required this.location,
    required this.timestamp,
    required this.durationMinutes,
    this.isResolved = false,
    required this.recommendations,
  });

  AlertItem copyWith({
    bool? isResolved,
  }) {
    return AlertItem(
      id: id,
      title: title,
      subtitle: subtitle,
      riskLevel: riskLevel,
      pseiValue: pseiValue,
      pm25Value: pm25Value,
      location: location,
      timestamp: timestamp,
      durationMinutes: durationMinutes,
      isResolved: isResolved ?? this.isResolved,
      recommendations: recommendations,
    );
  }
}

class ExposureHistoryItem {
  final String id;
  final DateTime date;
  final String dayName;
  final int durationMinutes;
  final int avgPsei;
  final int peakPsei;
  final String primaryLocation;
  final RiskLevel overallRisk;

  const ExposureHistoryItem({
    required this.id,
    required this.date,
    required this.dayName,
    required this.durationMinutes,
    required this.avgPsei,
    required this.peakPsei,
    required this.primaryLocation,
    required this.overallRisk,
  });
}

class AIInsightItem {
  final String title;
  final String primaryStat;
  final String highlight;
  final String description;
  final IconData icon;
  final Color accentColor;

  const AIInsightItem({
    required this.title,
    required this.primaryStat,
    required this.highlight,
    required this.description,
    required this.icon,
    required this.accentColor,
  });
}
