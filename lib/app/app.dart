import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/app/service_locator/service_locator.dart';
import 'package:sajilo_hariyo/app/theme/theme_data.dart';
import 'package:sajilo_hariyo/features/auth/presentation/view_model/user_cubit/user_cubit.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_bloc.dart';
import 'package:sajilo_hariyo/features/cart/presentation/view_model/cart_bloc/cart_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/profile_bloc/profile_bloc.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/wishlist_bloc/wishlist_bloc.dart';
import 'package:sajilo_hariyo/features/orders/presentation/view_model/order_bloc/order_bloc.dart';
import 'package:sajilo_hariyo/features/splash/presentation/view/splash_view.dart';
import 'package:sajilo_hariyo/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view_model/notification_bloc/notification_bloc.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view_model/notification_bloc/notification_event.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_dashboard_bloc/admin_dashboard_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_product_bloc/admin_product_bloc.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view_model/admin_order_bloc/admin_order_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: locator<SplashCubit>()),
        BlocProvider.value(value: locator<UserCubit>()),
        BlocProvider(create: (_) => locator<CartBloc>()..add(LoadCartItems())),
        BlocProvider(create: (_) => locator<WishlistBloc>()),
        BlocProvider(create: (_) => locator<AddressBloc>()),
        BlocProvider(create: (_) => locator<ProfileBloc>()),
        BlocProvider(create: (_) => locator<OrderBloc>()),
        BlocProvider(create: (_) => locator<NotificationBloc>()..add(LoadNotificationsEvent())),
        BlocProvider(create: (_) => locator<AdminDashboardBloc>()),
        BlocProvider(create: (_) => locator<AdminProductBloc>()),
        BlocProvider(create: (_) => locator<AdminOrderBloc>()),
      ],
      child: MaterialApp(
        title: 'Sajilo Hariyo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getApplicationTheme(),
        builder: (context, child) {
          return Stack(children: [if (child != null) child]);
        },
        home: const SplashView(),
      ),
    );
  }
}
