import 'dart:convert';
import 'package:sajilo_hariyo/features/cart/data/model/cart_item_api_model.dart';
import 'package:sajilo_hariyo/features/cart/domain/entity/cart_item_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _cartKey = 'user_cart';

  CartLocalDataSource(this._sharedPreferences);

  Future<void> addToCart(CartItemEntity item) async {
    List<CartItemEntity> currentCart = await getCartItems();

    // Check if product already exists
    int index = currentCart.indexWhere((i) => i.productId == item.productId);

    if (index != -1) {
      // Update quantity if it exists
      CartItemEntity existing = currentCart[index];
      currentCart[index] = CartItemEntity(
        productId: existing.productId,
        name: existing.name,
        price: existing.price,
        image: existing.image,
        quantity: existing.quantity + item.quantity,
      );
    } else {
      // Add new item
      currentCart.add(item);
    }

    await _saveCart(currentCart);
  }

  Future<List<CartItemEntity>> getCartItems() async {
    final String? cartString = _sharedPreferences.getString(_cartKey);
    if (cartString == null) return [];

    final List<dynamic> jsonList = jsonDecode(cartString);
    return jsonList
        .map((json) => CartItemApiModel.fromJson(json).toEntity())
        .toList();
  }

  Future<void> removeFromCart(String productId) async {
    List<CartItemEntity> currentCart = await getCartItems();
    currentCart.removeWhere((item) => item.productId == productId);
    await _saveCart(currentCart);
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    List<CartItemEntity> currentCart = await getCartItems();
    int index = currentCart.indexWhere((i) => i.productId == productId);

    if (index != -1) {
      CartItemEntity existing = currentCart[index];
      currentCart[index] = CartItemEntity(
        productId: existing.productId,
        name: existing.name,
        price: existing.price,
        image: existing.image,
        quantity: quantity,
      );
      await _saveCart(currentCart);
    }
  }

  Future<void> clearCart() async {
    await _sharedPreferences.remove(_cartKey);
  }

  // Helper to encode and save
  Future<void> _saveCart(List<CartItemEntity> cart) async {
    final List<Map<String, dynamic>> jsonList = cart
        .map((item) => CartItemApiModel.fromEntity(item).toJson())
        .toList();
    await _sharedPreferences.setString(_cartKey, jsonEncode(jsonList));
  }
}
