import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/get_wishlist_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/toggle_wishlist_usecase.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistUseCase getWishlistUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;

  WishlistBloc({
    required this.getWishlistUseCase,
    required this.toggleWishlistUseCase,
  }) : super(WishlistState.initial()) {
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<ToggleWishlistEvent>(_onToggleWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await getWishlistUseCase();

    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: failure.message),
      ),
      (wishlist) => emit(
        state.copyWith(isLoading: false, wishlist: wishlist, errorMessage: null),
      ),
    );
  }

  Future<void> _onToggleWishlist(
    ToggleWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    // We don't necessarily set loading to true for toggle to avoid full screen loaders,
    // but maybe we should for visual feedback. For now, let's just do it silently or optimistcally.
    // Actually, let's keep it simple: call api, then reload list.
    
    // NOTE: In a more complex app, we'd optimistically update the list.
    // Here, we'll just toggle and reload.
    
    final result = await toggleWishlistUseCase(event.productId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (isAdded) {
        emit(state.copyWith(
          successMessage: isAdded ? "Added to Wishlist" : "Removed from Wishlist",
        ));
        // After successful toggle, reload the wishlist to ensure consistency
        add(LoadWishlistEvent());
      },
    );
  }
}
