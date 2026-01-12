import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/repository/product_repository.dart';

class CreateProductParams extends Equatable {
  final ProductEntity product;
  final File image;
  final File? arModel;
  final List<File>? gallery;

  const CreateProductParams({
    required this.product,
    required this.image,
    this.arModel,
    this.gallery,
  });

  @override
  List<Object?> get props => [product, image, arModel, gallery];
}

class CreateProductUseCase
    implements UsecaseWithParams<void, CreateProductParams> {
  final IProductRepository _repository;

  CreateProductUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(CreateProductParams params) async {
    return await _repository.createProduct(
      params.product,
      params.image,
      params.arModel,
      params.gallery,
    );
  }
}
