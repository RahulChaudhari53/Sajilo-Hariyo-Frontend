import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchProductsEvent extends SearchEvent {
  final String? query;
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const SearchProductsEvent({
    this.query,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  @override
  List<Object?> get props => [query, categoryId, minPrice, maxPrice, sort];
}

class LoadSearchCategoriesEvent extends SearchEvent {}

class ResetSearchEvent extends SearchEvent {}
