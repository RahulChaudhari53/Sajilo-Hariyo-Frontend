import 'package:equatable/equatable.dart';

class ProductDetailState extends Equatable {
  final bool isLoading;
  final bool isFavorite;
  final bool isChecking;
  final String? message; // Success message for Cart
  final String? errorMessage;

  const ProductDetailState({
    required this.isLoading,
    required this.isChecking,
    required this.isFavorite,
    this.message,
    this.errorMessage,
  });

  factory ProductDetailState.initial() => const ProductDetailState(
    isLoading: false,
    isChecking: true,
    isFavorite: false,
    message: null,
    errorMessage: null,
  );

  ProductDetailState copyWith({
    bool? isLoading,
    bool? isChecking,
    bool? isFavorite,
    String? message,
    String? errorMessage,
  }) {
    return ProductDetailState(
      isLoading: isLoading ?? this.isLoading,
      isChecking: isChecking ?? this.isChecking,
      isFavorite: isFavorite ?? this.isFavorite,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isChecking,
    isFavorite,
    message,
    errorMessage,
  ];
}
