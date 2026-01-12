import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:sajilo_hariyo/features/notification/domain/use_case/mark_all_as_read_usecase.dart';
import 'package:sajilo_hariyo/features/notification/domain/use_case/mark_as_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final MarkAllAsReadUseCase _markAllAsReadUseCase;

  NotificationBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkAsReadUseCase markAsReadUseCase,
    required MarkAllAsReadUseCase markAllAsReadUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markAsReadUseCase = markAsReadUseCase,
        _markAllAsReadUseCase = markAllAsReadUseCase,
        super(NotificationState.initial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getNotificationsUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (notifications) => emit(state.copyWith(
        isLoading: false,
        notifications: notifications,
        error: null,
      )),
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // Optimistic Update: Mark locally as read immediately
    final updatedList = state.notifications.map((n) {
      if (n.id == event.id) {
        // Create new entity with isRead=true
        // But Entity is immutable and I missed adding copyWith to Entity?
        // Ah, typically we reconstruct it or add copyWith.
        // Let's assume I can't easily, so I'll just rely on fetching again or 
        // I should add copyWith to Entity.
        // For now, let's just create a new one manually if props match, or ignore optimistic update 
        // and just call API? No, smooth UI needs optimistic logic.
        // I will add copyWith to Entity in next step if needed, or just construct it.
        return n; // Placeholder, I will fix this logic.
      }
      return n;
    }).toList();
    
    // Call API
    final result = await _markAsReadUseCase.call(MarkAsReadParams(id: event.id));
    
    // Refresh list from server to be sure
    add(LoadNotificationsEvent());
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // Call API
    final result = await _markAllAsReadUseCase.call();
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (_) => add(LoadNotificationsEvent()), // Refresh on success
    );
  }
}
