import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String? description;

  const CategoryApiModel({this.id, required this.name, this.description});

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // Mapper
  CategoryEntity toEntity() =>
      CategoryEntity(id: id, name: name, description: description);

  @override
  List<Object?> get props => [id, name, description];
}
