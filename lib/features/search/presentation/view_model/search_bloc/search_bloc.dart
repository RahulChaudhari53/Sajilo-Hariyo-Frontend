import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/get_categories_usecase.dart';
import 'package:sajilo_hariyo/features/search/domain/use_case/search_products_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductsUseCase _searchProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  SearchBloc({
    required SearchProductsUseCase searchProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _searchProductsUseCase = searchProductsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(SearchState.initial()) {
    on<SearchProductsEvent>(_onSearchProducts);
    on<ResetSearchEvent>(_onResetSearch);
    on<LoadSearchCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onSearchProducts(
    SearchProductsEvent event,
    Emitter<SearchState> emit,
  ) async {
    // 1. Update state with new filters and set loading
    emit(state.copyWith(
      isLoading: true,
      query: event.query,
      categoryId: event.categoryId,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      sort: event.sort,
      error: null, // Clear previous errors
    ));

    // 2. Call UseCase
    final result = await _searchProductsUseCase.call(SearchProductsParams(
      search: event.query,
      category: event.categoryId,
      minPrice: event.minPrice,
      maxPrice: event.maxPrice,
      sort: event.sort,
    ));

    // 3. Handle Result
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        error: failure.message,
      )),
      (products) => emit(state.copyWith(
        isLoading: false,
        products: products,
        error: null,
      )),
    );
  }

  void _onResetSearch(
    ResetSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchState.initial().copyWith(
      categories: state.categories,
      query: '', // Explicitly clear query just to be safe, though initial() does it.
    ));
  }

  Future<void> _onLoadCategories(
    LoadSearchCategoriesEvent event,
    Emitter<SearchState> emit,
  ) async {
    // We can load categories without clearing existing search results
    final result = await _getCategoriesUseCase.call();
    result.fold(
      (failure) => null, // Silently fail or log?
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }
}
