import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sajilo_hariyo/features/admin/data/repository/remote_repository/admin_remote_repository.dart';
import 'package:sajilo_hariyo/features/auth/data/data_source/auth_data_source.dart';
import 'package:sajilo_hariyo/features/cart/data/data_source/local_data_source/cart_local_data_source.dart';
import 'package:sajilo_hariyo/features/cart/data/repository/local_repository/cart_local_repository.dart';
import 'package:sajilo_hariyo/features/cart/domain/repository/cart_repository.dart';
import 'package:sajilo_hariyo/features/cart/domain/usecase/add_to_cart_usecase.dart';
import 'package:sajilo_hariyo/features/cart/domain/usecase/clear_cart_usecase.dart';
import 'package:sajilo_hariyo/features/cart/domain/usecase/get_cart_usecase.dart';
import 'package:sajilo_hariyo/features/cart/domain/usecase/remove_from_cart_usecase.dart';
import 'package:sajilo_hariyo/features/cart/domain/usecase/update_cart_quantity_usecase.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_bloc.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/reset_password_viewmodel/reset_password_viewmodel.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/send_otp_viewmodel/send_otp_viewmodel.dart';
import 'package:sajilo_hariyo/features/forgot_password/presentation/view_model/verify_otp_viewmodel/verify_otp_viewmodel.dart';
import 'package:sajilo_hariyo/features/home/data/data_source/product_data_source.dart';
import 'package:sajilo_hariyo/features/home/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:sajilo_hariyo/features/home/data/repository/remote_repository/product_remote_repository.dart';
import 'package:sajilo_hariyo/features/home/domain/repository/product_repository.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/create_product_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/delete_product_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/get_categories_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/get_products_usecase.dart';
import 'package:sajilo_hariyo/features/home/domain/usecase/update_product_usecase.dart';
import 'package:sajilo_hariyo/features/home/presentation/view_model/product_bloc/product_bloc.dart';
import 'package:sajilo_hariyo/features/home/presentation/view_model/product_detail_bloc/product_detail_bloc.dart';
import 'package:sajilo_hariyo/features/orders/data/data_source/order_data_source.dart';
import 'package:sajilo_hariyo/features/orders/data/data_source/remote_data_source/order_remote_data_source.dart';
import 'package:sajilo_hariyo/features/orders/data/repository/remote_repository/order_remote_repository.dart';
import 'package:sajilo_hariyo/features/orders/domain/repository/order_repository.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/place_order_usecase.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/get_my_orders_usecase.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/cancel_order_usecase.dart';
import 'package:sajilo_hariyo/features/orders/domain/usecase/get_delivery_qr_usecase.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_bloc.dart';
import 'package:sajilo_hariyo/features/profile/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:sajilo_hariyo/features/profile/data/data_source/user_data_source.dart';
import 'package:sajilo_hariyo/features/profile/data/repository/remote_repository/user_remote_repository.dart';
import 'package:sajilo_hariyo/features/profile/domain/repository/user_repository.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/add_address_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/delete_address_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/get_wishlist_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/toggle_wishlist_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/update_address_usecase.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/change_password_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/update_profile_usecase.dart';

// Import your project files
import 'package:sajilo_hariyo/app/shared_pref/token_shared_pref.dart';
import 'package:sajilo_hariyo/app/shared_pref/user_shared_pref.dart';
import 'package:sajilo_hariyo/core/network/api_service.dart';
import 'package:sajilo_hariyo/core/network/auth_interceptor.dart';
import 'package:sajilo_hariyo/core/network/dio_error_interceptor.dart';

// Auth Imports
import 'package:sajilo_hariyo/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:sajilo_hariyo/features/auth/data/repository/remote_repository/auth_remote_repository.dart';
import 'package:sajilo_hariyo/features/auth/domain/repository/auth_repository.dart';
import 'package:sajilo_hariyo/features/auth/domain/usecase/login_user_usecase.dart';
import 'package:sajilo_hariyo/features/auth/domain/usecase/register_user_usecase.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/user_cubit/user_cubit.dart';

// Forgot Password Imports
import 'package:sajilo_hariyo/features/forgot_password/domain/usecase/reset_password_usecase.dart';
import 'package:sajilo_hariyo/features/forgot_password/domain/usecase/send_otp_usecase.dart';
import 'package:sajilo_hariyo/features/forgot_password/domain/usecase/verify_otp_usecase.dart';

// Splash Imports
import 'package:sajilo_hariyo/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:sajilo_hariyo/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:sajilo_hariyo/features/search/domain/use_case/search_products_usecase.dart';
import 'package:sajilo_hariyo/features/search/presentation/view_model/search_bloc/search_bloc.dart';
import 'package:sajilo_hariyo/features/notification/data/data_source/remote_data_source/notification_remote_data_source.dart';
import 'package:sajilo_hariyo/features/notification/data/repository/notification_remote_repository.dart';
import 'package:sajilo_hariyo/features/notification/domain/repository/notification_repository.dart';
import 'package:sajilo_hariyo/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:sajilo_hariyo/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:sajilo_hariyo/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view_model/notification_bloc/notification_bloc.dart';

import 'package:sajilo_hariyo/features/admin/data/data_source/remote_data_source/admin_remote_data_source.dart';
import 'package:sajilo_hariyo/features/admin/domain/repository/admin_repository.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/create_category_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/delete_category_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/get_admin_stats_usecase.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_dashboard_bloc/admin_dashboard_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_bloc.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/get_admin_orders_usecase.dart';
import 'package:sajilo_hariyo/features/admin/domain/use_case/update_order_status_usecase.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_bloc.dart';
import 'package:sajilo_hariyo/features/admin/domain/usecase/verify_delivery_usecase.dart';

final locator = GetIt
    .instance; // Changed from serviceLocator to locator for consistency with our previous steps

Future<void> initDependencies() async {
  await _initSharedPref();
  await _initDio();
  await _initCoreServices();
  await _initApiService();

  await _initSplashModule();
  await _initAuthModule();
  await _initAdminModule();
  await _initProductModule();
  await _initOrderModule();
  await _initCartModule();
  await _initProfileModule();
  await _initSearchModule();
  await _initNotificationModule();
}

Future<void> _initAdminModule() async {
  // Data Source
  locator.registerFactory<IAdminDataSource>(
    () => AdminRemoteDataSource(locator()),
  );

  // Repository
  locator.registerFactory<IAdminRepository>(
    () => AdminRemoteRepository(locator()),
  );

  // Use Cases
  locator.registerFactory<GetAdminStatsUseCase>(
    () => GetAdminStatsUseCase(locator()),
  );
  locator.registerFactory<CreateCategoryUseCase>(
    () => CreateCategoryUseCase(locator()),
  );
  locator.registerFactory<DeleteCategoryUseCase>(
    () => DeleteCategoryUseCase(locator()),
  );
  locator.registerFactory<GetAdminOrdersUseCase>(
    () => GetAdminOrdersUseCase(locator()),
  );
  locator.registerFactory<UpdateOrderStatusUseCase>(
    () => UpdateOrderStatusUseCase(locator()),
  );
  locator.registerFactory<VerifyDeliveryUseCase>(
    () => VerifyDeliveryUseCase(repository: locator()),
  );

  // Bloc
  locator.registerFactory<AdminDashboardBloc>(
    () => AdminDashboardBloc(
      getAdminStatsUseCase: locator(),
      getCategoriesUseCase: locator(),
      createCategoryUseCase: locator(),
      deleteCategoryUseCase: locator(),
    ),
  );

  locator.registerFactory<AdminProductBloc>(
    () => AdminProductBloc(
      getProductsUseCase: locator(),
      getCategoriesUseCase: locator(),
      createProductUseCase: locator(),
      updateProductUseCase: locator(),
      deleteProductUseCase: locator(),
    ),
  );

  locator.registerFactory<AdminOrderBloc>(
    () => AdminOrderBloc(
      getAdminOrdersUseCase: locator(),
      updateOrderStatusUseCase: locator(),
      verifyDeliveryUseCase: locator(),
    ),
  );
}

Future<void> _initNotificationModule() async {
  // Data Source
  locator.registerFactory<INotificationDataSource>(
    () => NotificationRemoteDataSource(locator()),
  );

  // Repository
  locator.registerFactory<INotificationRepository>(
    () => NotificationRepositoryImpl(locator()),
  );

  // Use Cases
  locator.registerFactory<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(locator()),
  );
  locator.registerFactory<MarkAsReadUseCase>(
    () => MarkAsReadUseCase(locator()),
  );
  locator.registerFactory<MarkAllAsReadUseCase>(
    () => MarkAllAsReadUseCase(locator()),
  );

  // Bloc
  locator.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      getNotificationsUseCase: locator(),
      markAsReadUseCase: locator(),
      markAllAsReadUseCase: locator(),
    ),
  );
}

Future<void> _initSharedPref() async {
  final sharedPref = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPref);
  locator.registerLazySingleton(() => TokenSharedPref(locator()));
  locator.registerLazySingleton(() => UserSharedPref(locator()));
}

Future<void> _initDio() async {
  locator.registerLazySingleton(() => Dio());
}

Future<void> _initCoreServices() async {
  locator.registerLazySingleton(
    () => AuthInterceptor(locator<TokenSharedPref>()),
  );
  locator.registerLazySingleton(() => DioErrorInterceptor());
}

Future<void> _initApiService() async {
  locator.registerLazySingleton(() => ApiService(locator<Dio>()));

  // Initialize interceptors manually since ApiService is a singleton
  locator<ApiService>().init(
    locator<AuthInterceptor>(),
    locator<DioErrorInterceptor>(),
  );
}

Future<void> _initSplashModule() async {
  locator.registerFactory<SplashCubit>(
    () => SplashCubit(locator<TokenSharedPref>(), locator<UserSharedPref>()),
  );

  locator.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(locator<TokenSharedPref>()),
  );
}

Future<void> _initAuthModule() async {
  // ================= Data Source =================
  locator.registerFactory<IAuthDataSource>(
    () => AuthRemoteDataSource(locator<Dio>()),
  );

  // ================= Repository =================
  locator.registerFactory<IAuthRepository>(
    () => AuthRemoteRepository(
      locator<IAuthDataSource>(),
      locator<TokenSharedPref>(),
      locator<UserSharedPref>(),
    ),
  );

  // ================= Use Cases (User) =================
  locator.registerFactory<RegisterUserUseCase>(
    () => RegisterUserUseCase(repository: locator<IAuthRepository>()),
  );

  locator.registerFactory<LoginUserUseCase>(
    () => LoginUserUseCase(repository: locator<IAuthRepository>()),
  );

  // ================= Use Cases (Forgot Password) =================
  locator.registerFactory<SendOtpUseCase>(
    () => SendOtpUseCase(repository: locator<IAuthRepository>()),
  );

  locator.registerFactory<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(repository: locator<IAuthRepository>()),
  );

  locator.registerFactory<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(repository: locator<IAuthRepository>()),
  );

  // ================= View Models (BLoCs) =================
  locator.registerFactory<RegisterViewModel>(
    () =>
        RegisterViewModel(registerUserUseCase: locator<RegisterUserUseCase>()),
  );

  locator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      loginUserUseCase: locator<LoginUserUseCase>(),
      userCubit: locator<UserCubit>(),
    ),
  );

  // ================= User Cubit (Global State) =================
  locator.registerLazySingleton<UserCubit>(
    () => UserCubit(locator<UserSharedPref>()),
  );

  locator.registerFactory<SendOtpViewModel>(
    () => SendOtpViewModel(locator<SendOtpUseCase>()),
  );

  locator.registerFactory<VerifyOtpViewModel>(
    () => VerifyOtpViewModel(
      locator<VerifyOtpUseCase>(),
      locator<SendOtpUseCase>(),
    ),
  );

  locator.registerFactory<ResetPasswordViewModel>(
    () => ResetPasswordViewModel(locator<ResetPasswordUseCase>()),
  );
}

Future<void> _initProductModule() async {
  // ================= Data Source =================
  locator.registerFactory<IProductDataSource>(
    () => ProductRemoteDataSource(locator()),
  );

  // ================= Repository =================
  locator.registerFactory<IProductRepository>(
    () => ProductRemoteRepository(locator()),
  );

  // ================= Use Cases =================
  locator.registerFactory<GetProductsUseCase>(
    () => GetProductsUseCase(repository: locator()),
  );
  locator.registerFactory<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(repository: locator()),
  );
  locator.registerFactory<CreateProductUseCase>(
    () => CreateProductUseCase(repository: locator()),
  );
  locator.registerFactory<UpdateProductUseCase>(
    () => UpdateProductUseCase(repository: locator()),
  );
  locator.registerFactory<DeleteProductUseCase>(
    () => DeleteProductUseCase(repository: locator()),
  );

  // ================= View Model (BLoCs) =================
  locator.registerFactory<ProductBloc>(
    () => ProductBloc(
      getProductsUseCase: locator(),
      getCategoriesUseCase: locator(),
    ),
  );

  locator.registerFactory<ProductDetailBloc>(
    () => ProductDetailBloc(
      toggleWishlistUseCase: locator<ToggleWishlistUseCase>(),
      getWishlistUseCase: locator<GetWishlistUseCase>(),
      addToCartUseCase: locator<AddToCartUseCase>(),
    ),
  );
}

Future<void> _initCartModule() async {
  // Data Source
  locator.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSource(locator()),
  );

  // Repository
  locator.registerFactory<ICartRepository>(
    () => CartLocalRepository(locator()),
  );

  // Use Cases
  locator.registerFactory<AddToCartUseCase>(
    () => AddToCartUseCase(repository: locator()),
  );
  locator.registerFactory<GetCartUseCase>(
    () => GetCartUseCase(repository: locator()),
  );
  locator.registerFactory<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(repository: locator()),
  );
  locator.registerFactory<UpdateCartQuantityUseCase>(
    () => UpdateCartQuantityUseCase(repository: locator()),
  );
  locator.registerFactory<ClearCartUseCase>(
    () => ClearCartUseCase(repository: locator()),
  );

  // Bloc
  locator.registerFactory<CartBloc>(() => CartBloc(locator<ICartRepository>()));
}

Future<void> _initOrderModule() async {
  // Data Source
  locator.registerFactory<IOrderDataSource>(
    () => OrderRemoteDataSource(locator()),
  );

  // Repository
  locator.registerFactory<IOrderRepository>(
    () => OrderRemoteRepository(locator()),
  );

  // Use Cases
  locator.registerFactory<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(repository: locator()),
  );

  locator.registerFactory<GetMyOrdersUseCase>(
    () => GetMyOrdersUseCase(repository: locator()),
  );

  locator.registerFactory<CancelOrderUseCase>(
    () => CancelOrderUseCase(repository: locator()),
  );

  locator.registerFactory<GetDeliveryQRUseCase>(
    () => GetDeliveryQRUseCase(repository: locator()),
  );

  // Order Bloc (Checkout logic)
  locator.registerFactory<OrderBloc>(
    () => OrderBloc(
      placeOrderUseCase: locator(),
      getMyOrdersUseCase: locator(),
      cancelOrderUseCase: locator(),
      getDeliveryQRUseCase: locator(),
      userRepository: locator(),
    ),
  );
}

Future<void> _initProfileModule() async {
  // Data Source
  locator.registerFactory<IUserDataSource>(
    () => UserRemoteDataSource(locator()),
  );
  // Repository
  locator.registerFactory<IUserRepository>(
    () => UserRemoteRepository(locator()),
  );
  // Use Cases
  locator.registerFactory<GetWishlistUseCase>(
    () => GetWishlistUseCase(repository: locator()),
  );
  locator.registerFactory<ToggleWishlistUseCase>(
    () => ToggleWishlistUseCase(repository: locator()),
  );

  // Address UseCases
  locator.registerFactory<AddAddressUseCase>(
    () => AddAddressUseCase(repository: locator()),
  );
  locator.registerFactory<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(repository: locator()),
  );
  locator.registerFactory<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(repository: locator()),
  );

  // Blocs
  locator.registerFactory<WishlistBloc>(
    () => WishlistBloc(
      getWishlistUseCase: locator(),
      toggleWishlistUseCase: locator(),
    ),
  );

  locator.registerFactory<AddressBloc>(
    () => AddressBloc(
      userRepository: locator(),
      addAddressUseCase: locator(),
      updateAddressUseCase: locator(),
      deleteAddressUseCase: locator(),
    ),
  );

  // Profile UseCases
  locator.registerFactory<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(repository: locator()),
  );
  locator.registerFactory<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(repository: locator()),
  );

  locator.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      userRepository: locator(),
      updateProfileUseCase: locator(),
      changePasswordUseCase: locator(),
    ),
  );
}

Future<void> _initSearchModule() async {
  locator.registerFactory<SearchProductsUseCase>(
    () => SearchProductsUseCase(locator()),
  );
  locator.registerFactory<SearchBloc>(
    () => SearchBloc(
      searchProductsUseCase: locator(),
      getCategoriesUseCase: locator(),
    ),
  );
}
