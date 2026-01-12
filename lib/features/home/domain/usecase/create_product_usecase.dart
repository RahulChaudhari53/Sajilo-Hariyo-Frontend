import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/product_entity.dart';
import '../repository/product_repository.dart';

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
  final IProductRepository repository;
  CreateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CreateProductParams params) {
    return repository.createProduct(
      params.product,
      params.image,
      params.arModel,
      params.gallery,
    );
  }
}
