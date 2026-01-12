import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entity/product_entity.dart';
import '../repository/product_repository.dart';

class UpdateProductParams extends Equatable {
  final ProductEntity product;
  final File? image;
  final File? arModel;
  final List<File>? gallery;

  const UpdateProductParams({
    required this.product,
    this.image,
    this.arModel,
    this.gallery,
  });

  @override
  List<Object?> get props => [product, image, arModel, gallery];
}

class UpdateProductUseCase
    implements UsecaseWithParams<void, UpdateProductParams> {
  final IProductRepository repository;
  UpdateProductUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) {
    return repository.updateProduct(
      params.product,
      image: params.image,
      arModel: params.arModel,
      gallery: params.gallery,
    );
  }
}
