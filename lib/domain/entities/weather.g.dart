// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'value': instance.value,
    };

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      condition: json['condition'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      location: json['location'] as String,
      temperature:
          Temperature.fromJson(json['temperature'] as Map<String, dynamic>),
      weatherStateAbr: json['weatherStateAbr'] as String,
      minTemp: Temperature.fromJson(json['minTemp'] as Map<String, dynamic>),
      maxTemp: Temperature.fromJson(json['maxTemp'] as Map<String, dynamic>),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      humidity: json['humidity'] as int,
      airPressure: (json['airPressure'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

