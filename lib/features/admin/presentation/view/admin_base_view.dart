import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_dashboard_view.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_orders_view.dart';
import 'package:sajilo_hariyo/features/admin/presentation/view/admin_products_view.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view/profile_view.dart';

class AdminBaseView extends StatefulWidget {
  const AdminBaseView({super.key});

  @override
  State<AdminBaseView> createState() => _AdminBaseViewState();
}

class _AdminBaseViewState extends State<AdminBaseView> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardView(),
    const AdminProductsView(),
    const AdminOrdersView(),
    const ProfileView(), // Reuse existing Profile View
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF3A7F5F),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.layoutDashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.package),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.listOrdered),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
