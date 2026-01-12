import 'package:equatable/equatable.dart';

abstract class AdminDashboardEvent extends Equatable {
  const AdminDashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminDashboardEvent extends AdminDashboardEvent {}

class CreateCategoryEvent extends AdminDashboardEvent {
  final String name;
  final String description;

  const CreateCategoryEvent({required this.name, required this.description});

  @override
  List<Object> get props => [name, description];
}

class DeleteCategoryEvent extends AdminDashboardEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [id];
}
