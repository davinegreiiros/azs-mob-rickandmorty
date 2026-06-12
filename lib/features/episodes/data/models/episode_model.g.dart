// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeModel _$EpisodeModelFromJson(Map<String, dynamic> json) => EpisodeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      episode: json['episode'] as String,
      airDate: json['air_date'] as String,
      characterCount: _characterCountFromJson(json['characters'] as List),
    );

Map<String, dynamic> _$EpisodeModelToJson(EpisodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'episode': instance.episode,
      'air_date': instance.airDate,
      'characters': instance.characterCount,
    };
