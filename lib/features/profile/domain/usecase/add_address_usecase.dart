import 'package:dartz/dartz.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/address_entity.dart';
import '../repository/user_repository.dart';

class AddAddressUseCase
    implements UsecaseWithParams<List<AddressEntity>, AddressEntity> {
  final IUserRepository repository;
  AddAddressUseCase({required this.repository});

  @override
  Future<Either<Failure, List<AddressEntity>>> call(AddressEntity address) {
    return repository.addAddress(address);
  }
}
