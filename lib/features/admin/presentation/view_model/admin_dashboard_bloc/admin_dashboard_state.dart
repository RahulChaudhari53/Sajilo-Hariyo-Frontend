import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/admin/domain/entity/admin_stats_entity.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/category_entity.dart';

class AdminDashboardState extends Equatable {
  final bool isLoading;
  final AdminStatsEntity? stats;
  final List<CategoryEntity> categories;
  final String? error;
  final String? successMessage; // To show snackbar on add/delete

  const AdminDashboardState({
    required this.isLoading,
    this.stats,
    required this.categories,
    this.error,
    this.successMessage,
  });

  factory AdminDashboardState.initial() {
    return const AdminDashboardState(
      isLoading: false,
      stats: null,
      categories: [],
      error: null,
      successMessage: null,
    );
  }

  AdminDashboardState copyWith({
    bool? isLoading,
    AdminStatsEntity? stats,
    List<CategoryEntity>? categories,
    String? error,
    String? successMessage,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      stats: stats ?? this.stats,
      categories: categories ?? this.categories,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, stats, categories, error, successMessage];
}
