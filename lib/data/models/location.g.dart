// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      title: json['title'] as String,
      locationType: $enumDecode(_$LocationTypeEnumMap, json['locationType']),
      latLng: const LatLngConverter().fromJson(json['latt_long'] as String),
      woeid: json['woeid'] as int,
    );

const _$LocationTypeEnumMap = {
  LocationType.city: 'City',
  LocationType.region: 'Region',
  LocationType.state: 'State',
  LocationType.province: 'Province',
  LocationType.country: 'Country',
  LocationType.continent: 'Continent',
};
