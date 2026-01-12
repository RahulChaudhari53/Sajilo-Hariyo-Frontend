import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/profile/domain/entity/address_entity.dart';
import 'package:sajilo_hariyo/features/profile/domain/repository/user_repository.dart';

class UpdateAddressUseCase implements UsecaseWithParams<List<AddressEntity>, AddressEntity> {
  final IUserRepository repository;
  UpdateAddressUseCase({required this.repository});
  
  @override
  Future<Either<Failure, List<AddressEntity>>> call(AddressEntity params) {
    return repository.updateAddress(params);
  }
}
