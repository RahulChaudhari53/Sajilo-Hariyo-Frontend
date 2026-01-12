import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/app/usecase/usecase.dart';
import 'package:sajilo_hariyo/core/error/failure.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_hariyo/features/home/domain/repository/product_repository.dart';

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
  final IProductRepository _repository;

  UpdateProductUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdateProductParams params) async {
    return await _repository.updateProduct(
      params.product,
      image: params.image,
      arModel: params.arModel,
      gallery: params.gallery,
    );
  }
}
