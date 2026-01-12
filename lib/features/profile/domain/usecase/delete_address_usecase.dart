import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/address_entity.dart';
import '../repository/user_repository.dart';

class DeleteAddressUseCase
    implements UsecaseWithParams<List<AddressEntity>, String> {
  final IUserRepository repository;
  DeleteAddressUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AddressEntity>>> call(String addressId) {
    return repository.deleteAddress(addressId);
  }
}
