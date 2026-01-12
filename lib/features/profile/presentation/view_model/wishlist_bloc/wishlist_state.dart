import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

class WishlistState extends Equatable {
  final bool isLoading;
  final List<ProductEntity> wishlist;
  final String? errorMessage;
  final String? successMessage;

  const WishlistState({
    required this.isLoading,
    required this.wishlist,
    this.errorMessage,
    this.successMessage,
  });

  factory WishlistState.initial() {
    return const WishlistState(
      isLoading: false,
      wishlist: [],
      errorMessage: null,
      successMessage: null,
    );
  }

  WishlistState copyWith({
    bool? isLoading,
    List<ProductEntity>? wishlist,
    String? errorMessage,
    String? successMessage,
  }) {
    return WishlistState(
      isLoading: isLoading ?? this.isLoading,
      wishlist: wishlist ?? this.wishlist,
      errorMessage: errorMessage, // Do not keep error message if not provided (or maybe we do? usually null out on new state)
      // Actually standard copyWith keeps old if null. But for messages we usually want to clear them if not set, 
      // OR we emit a new state with message and then immediately another one without?
      // In BlocListener, we usually listen for non-null changes.
      // Let's stick to standard copyWith pattern.
      successMessage: successMessage, 
    );
  }

  @override
  List<Object?> get props => [isLoading, wishlist, errorMessage, successMessage];
}
