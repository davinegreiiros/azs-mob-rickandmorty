import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/episode.dart';

part 'episode_model.g.dart';

int _characterCountFromJson(List<dynamic> characters) => characters.length;

@JsonSerializable()
class EpisodeModel {
  final String id;
  final String name;
  final String episode;

  @JsonKey(name: 'air_date')
  final String airDate;

  @JsonKey(name: 'characters', fromJson: _characterCountFromJson)
  final int characterCount;

  const EpisodeModel({
    required this.id,
    required this.name,
    required this.episode,
    required this.airDate,
    required this.characterCount,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);

  Episode toEntity() => Episode(
        id: id,
        name: name,
        episode: episode,
        airDate: airDate,
        characterCount: characterCount,
      );
}
