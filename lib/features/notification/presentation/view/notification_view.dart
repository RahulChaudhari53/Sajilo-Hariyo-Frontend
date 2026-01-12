import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sajilo_hariyo/features/notification/domain/entity/notification_entity.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view_model/notification_bloc/notification_bloc.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view_model/notification_bloc/notification_event.dart';
import 'package:sajilo_hariyo/features/notification/presentation/view_model/notification_bloc/notification_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors
    final Color primaryGreen = const Color(0xFF3A7F5F);
    final Color cardColor = const Color(0xFFF8F3ED);
    final Color darkText = const Color(0xFF1B3A29);

    return Scaffold(
      backgroundColor: cardColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: darkText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: darkText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.checkCheck, color: primaryGreen),
            tooltip: "Mark all as read",
            onPressed: () {
              context.read<NotificationBloc>().add(MarkAllAsReadEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          if (state.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<NotificationBloc>().add(LoadNotificationsEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final item = state.notifications[index];
                return Dismissible(
                  key: Key(item.id ?? index.toString()),
                  direction: DismissDirection.endToStart,
                  background: _buildDismissBackground(),
                  onDismissed: (direction) {

                  },
                  confirmDismiss: (direction) async => false, 
                  child: _buildNotificationCard(item, context, primaryGreen, darkText),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(LucideIcons.trash2, color: Colors.white),
    );
  }

  Widget _buildNotificationCard(
    NotificationEntity item,
    BuildContext context,
    Color primaryGreen,
    Color darkText,
  ) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (item.type) {
      case 'order':
        icon = LucideIcons.truck;
        iconColor = primaryGreen;
        iconBg = const Color(0xFFDEEAD8);
        break;
      case 'promo':
        icon = LucideIcons.tag;
        iconColor = const Color(0xFFE07A5F);
        iconBg = const Color(0xFFFFEBE6);
        break;
      case 'system':
      case 'info':
      default:
        icon = LucideIcons.info;
        iconColor = const Color(0xFF5A6ECD);
        iconBg = const Color(0xFFE8EAF6);
        break;
    }

    return GestureDetector(
      onTap: () {
        if (!item.isRead && item.id != null) {
          context.read<NotificationBloc>().add(MarkAsReadEvent(item.id!));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: item.isRead
              ? null
              : Border.all(color: primaryGreen.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: darkText,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        timeago.format(item.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.message,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!item.isRead)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bellOff, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No Notifications",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll notify you when something arrives.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}
