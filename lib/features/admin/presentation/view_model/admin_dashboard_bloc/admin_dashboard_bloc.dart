import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/create_category_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/delete_category_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/get_admin_stats_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/get_categories_usecase.dart';

import 'admin_dashboard_event.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardBloc extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  final GetAdminStatsUseCase _getAdminStatsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  AdminDashboardBloc({
    required GetAdminStatsUseCase getAdminStatsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required CreateCategoryUseCase createCategoryUseCase,
    required DeleteCategoryUseCase deleteCategoryUseCase,
  })  : _getAdminStatsUseCase = getAdminStatsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _createCategoryUseCase = createCategoryUseCase,
        _deleteCategoryUseCase = deleteCategoryUseCase,
        super(AdminDashboardState.initial()) {
    on<LoadAdminDashboardEvent>(_onLoadDashboard);
    on<CreateCategoryEvent>(_onCreateCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadDashboard(
    LoadAdminDashboardEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    // Fetch Stats
    final statsResult = await _getAdminStatsUseCase.call();
    
    // Fetch Categories
    final categoriesResult = await _getCategoriesUseCase.call(); // No params needed

    statsResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (stats) {
        categoriesResult.fold(
          (failure) => emit(state.copyWith(
            isLoading: false, 
            error: failure.message,
            stats: stats, // Still show stats if categories fail?
          )),
          (categories) => emit(state.copyWith(
            isLoading: false,
            stats: stats,
            categories: categories,
          )),
        );
      },
    );
  }

  Future<void> _onCreateCategory(
    CreateCategoryEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await _createCategoryUseCase.call(
      CreateCategoryParams(name: event.name, description: event.description),
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) {
        emit(state.copyWith(isLoading: false, successMessage: "Category Created"));
        add(LoadAdminDashboardEvent()); // Refresh
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategoryEvent event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, successMessage: null));
    final result = await _deleteCategoryUseCase.call(event.id);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) {
        emit(state.copyWith(isLoading: false, successMessage: "Category Deleted"));
        add(LoadAdminDashboardEvent()); // Refresh
      },
    );
  }
}
