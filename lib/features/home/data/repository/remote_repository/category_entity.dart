import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String name;
  final String? description;

  const CategoryEntity({this.id, required this.name, this.description});

  @override
  List<Object?> get props => [id, name, description];
}
