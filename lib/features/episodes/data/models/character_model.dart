import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/character.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  final String id;
  final String name;
  final String species;
  final String status;
  final String image;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.species,
    required this.status,
    required this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  Character toEntity() => Character(
        id: id,
        name: name,
        species: species,
        status: status,
        image: image,
      );
}
