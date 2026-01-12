import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlistEvent extends WishlistEvent {}

class ToggleWishlistEvent extends WishlistEvent {
  final String productId;

  const ToggleWishlistEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
