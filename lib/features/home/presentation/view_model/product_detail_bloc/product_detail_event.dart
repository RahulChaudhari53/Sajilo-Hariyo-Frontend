import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

// Check if the product is already in favorites when the page opens
class CheckInitialFavoriteStatus extends ProductDetailEvent {
  final String productId;
  const CheckInitialFavoriteStatus(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Handle clicking the heart icon
class ToggleFavoriteEvent extends ProductDetailEvent {
  final String productId;
  const ToggleFavoriteEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Handle clicking the "Add to Cart" button (adds 1 unit)
class AddToCartEvent extends ProductDetailEvent {
  final ProductEntity product;
  const AddToCartEvent(this.product);

  @override
  List<Object?> get props => [product];
}
