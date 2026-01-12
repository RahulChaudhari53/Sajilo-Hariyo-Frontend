class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);
  static const receiveTimeout = Duration(seconds: 1000);

  // static const String serverAddress = "http://10.0.2.2:5050";
  static const String serverAddress = "http://192.168.1.68:5050";

  static const String baseUrl = "$serverAddress/api";

  // =============== Auth Endpoints ===============
  static const String login = "$baseUrl/users/login";
  static const String register = "$baseUrl/users/signup";
  static const String forgotPassword = "$baseUrl/users/forgotPassword";
  static const String verifyOtp = "$baseUrl/users/verifyOtp";
  static const String resetPassword = "$baseUrl/users/resetPassword";

  // =============== User/Profile Endpoints ===============
  static const String getProfile = "$baseUrl/users/profile";
  static const String updateProfile = "$baseUrl/users/updateProfile";
  static const String updatePassword = "$baseUrl/users/updatePassword";

  // Address Endpoints
  static const String addAddress = "$baseUrl/users/address";
  static String updateAddress(String addressId) =>
      "$baseUrl/users/address/$addressId";
  static String deleteAddress(String addressId) =>
      "$baseUrl/users/address/$addressId";

  // Wishlist Endpoints
  static const String getWishlist = "$baseUrl/users/wishlist";
  static String toggleWishlist(String productId) =>
      "$baseUrl/users/wishlist/$productId";

  // =============== Product Endpoints ===============
  static const String getProducts = "$baseUrl/products";
  static String getProductById(String productId) =>
      "$baseUrl/products/$productId";
  static const String createProduct = "$baseUrl/products";
  static String updateProduct(String productId) =>
      "$baseUrl/products/$productId";
  static String deleteProduct(String productId) =>
      "$baseUrl/products/$productId";

  // =============== Category Endpoints ===============
  static const String getCategories = "$baseUrl/categories";
  static const String createCategory = "$baseUrl/categories";
  static String deleteCategory(String categoryId) =>
      "$baseUrl/categories/$categoryId";

  // =============== Order Endpoints ===============
  // Customer Routes
  static const String placeOrder = "$baseUrl/orders/new";
  static const String getMyOrders = "$baseUrl/orders/myorders";
  static String getOrderById(String orderId) => "$baseUrl/orders/$orderId";
  static String getDeliveryQR(String orderId) => "$baseUrl/orders/$orderId/qr";
  static String cancelOrder(String orderId) =>
      "$baseUrl/orders/$orderId/cancel";

  // Admin Routes
  static const String getAllOrders = "$baseUrl/orders/admin/all";
  static String updateOrderStatus(String orderId) =>
      "$baseUrl/orders/admin/$orderId";
  static const String verifyDelivery = "$baseUrl/orders/admin/verify-delivery";

  // =============== Notification Endpoints ===============
  static const String getNotifications = "$baseUrl/notifications";
  static const String markAllNotificationsRead =
      "$baseUrl/notifications/read-all";
  static String markNotificationRead(String notificationId) =>
      "$baseUrl/notifications/$notificationId/read";
  static const String sendNotification =
      "$baseUrl/notifications/send"; // Admin only

  // =============== Admin Endpoints ===============
  static const String getAdminStats = "$baseUrl/admin/stats";

  // =============== Helper Methods for Query Parameters ===============

  /// Build products URL with query parameters
  /// Example: getProductsWithQuery(search: "monstera", category: "cat_id", limit: 12)
  static String getProductsWithQuery({
    String? search,
    String? category,
    int? limit,
    String? sort,
    double? minPrice,
    double? maxPrice,
  }) {
    final uri = Uri.parse(getProducts);
    final queryParams = <String, String>{};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }
    if (sort != null && sort.isNotEmpty) {
      queryParams['sort'] = sort;
    }
    if (minPrice != null) {
      queryParams['price[gte]'] = minPrice.toString();
    }
    if (maxPrice != null) {
      queryParams['price[lte]'] = maxPrice.toString();
    }

    return queryParams.isEmpty
        ? getProducts
        : uri.replace(queryParameters: queryParams).toString();
  }

  /// Build my orders URL with filter
  /// Example: getMyOrdersWithFilter(filter: "active") or getMyOrdersWithFilter(filter: "history")
  static String getMyOrdersWithFilter({String? filter}) {
    if (filter == null || filter.isEmpty) {
      return getMyOrders;
    }
    final uri = Uri.parse(getMyOrders);
    return uri.replace(queryParameters: {'filter': filter}).toString();
  }

  /// Build admin orders URL with status filter
  /// Example: getAllOrdersWithStatus(status: "Pending")
  static String getAllOrdersWithStatus({String? status}) {
    if (status == null || status.isEmpty) {
      return getAllOrders;
    }
    final uri = Uri.parse(getAllOrders);
    return uri.replace(queryParameters: {'status': status}).toString();
  }
}
