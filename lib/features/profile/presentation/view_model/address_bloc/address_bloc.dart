import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_hariyo/features/profile/domain/repository/user_repository.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/add_address_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/delete_address_usecase.dart';
import 'package:sajilo_hariyo/features/profile/domain/usecase/update_address_usecase.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_event.dart';
import 'package:sajilo_hariyo/features/profile/presentation/view_model/address_bloc/address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final IUserRepository userRepository;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;

  AddressBloc({
    required this.userRepository,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
  }) : super(const AddressState()) {
    on<LoadAddressesEvent>(_onLoadAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await userRepository.getProfile();
    result.fold(
      (failure) => emit(
        state.copyWith(status: AddressStatus.failure, message: failure.message),
      ),
      (user) => emit(
        state.copyWith(
          status: AddressStatus.success,
          addresses: user.addresses ?? [],
        ),
      ),
    );
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await addAddressUseCase(event.address);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AddressStatus.failure, message: failure.message),
      ),
      (addresses) => emit(
        state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          message: "Address added successfully",
        ),
      ),
    );
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await updateAddressUseCase(event.address);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AddressStatus.failure, message: failure.message),
      ),
      (addresses) => emit(
        state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          message: "Address updated successfully",
        ),
      ),
    );
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await deleteAddressUseCase(event.addressId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: AddressStatus.failure, message: failure.message),
      ),
      (addresses) => emit(
        state.copyWith(
          status: AddressStatus.success,
          addresses: addresses,
          message: "Address deleted successfully",
        ),
      ),
    );
  }
}
