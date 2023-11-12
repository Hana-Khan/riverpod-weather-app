// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      location: json['location'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] as String,
      weatherStateAbr: json['weatherStateAbr'] as String,
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      humidity: json['humidity'] as int,
      airPressure: (json['airPressure'] as num).toDouble(),
      applicableDate: DateTime.parse(json['applicableDate'] as String),
    );

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
      'location': instance.location,
      'temperature': instance.temperature,
      'condition': instance.condition,
      'weatherStateAbr': instance.weatherStateAbr,
      'minTemp': instance.minTemp,
      'maxTemp': instance.maxTemp,
      'windSpeed': instance.windSpeed,
      'windDirection': instance.windDirection,
      'humidity': instance.humidity,
      'airPressure': instance.airPressure,
      'applicableDate': instance.applicableDate.toIso8601String(),
    };
