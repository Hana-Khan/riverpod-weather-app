// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      id: json['id'] as int,
      weatherStateName: json['weatherStateName'] as String,
      weatherStateAbbr: $enumDecode(
          _$WeatherStateEnumMap, json['weatherStateAbbr'],
          unknownValue: WeatherState.unknown),
      windDirectionCompass: $enumDecode(
          _$WindDirectionCompassEnumMap, json['windDirectionCompass'],
          unknownValue: WindDirectionCompass.unknown),
      created: DateTime.parse(json['created'] as String),
      applicableDate: DateTime.parse(json['applicableDate'] as String),
      minTemp: (json['minTemp'] as num).toDouble(),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      theTemp: (json['theTemp'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      windDirection: (json['windDirection'] as num).toDouble(),
      airPressure: (json['airPressure'] as num).toDouble(),
      humidity: json['humidity'] as int,
      visibility: (json['visibility'] as num).toDouble(),
      predictability: json['predictability'] as int,
    );
