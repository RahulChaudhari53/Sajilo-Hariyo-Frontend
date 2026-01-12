import 'package:dartz/dartz.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';

abstract class UsecaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class UsecaseWithoutParams<SuccessType> {
  Future<Either<Failure, SuccessType>> call();
}
