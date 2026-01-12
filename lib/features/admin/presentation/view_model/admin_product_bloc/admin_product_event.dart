import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';

sealed class AdminProductEvent extends Equatable {
  const AdminProductEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminProductsEvent extends AdminProductEvent {
  final String? category;
  final String? search;
  final bool isRefresh;

  const LoadAdminProductsEvent({this.category, this.search, this.isRefresh = false});

  @override
  List<Object> get props => [category ?? '', search ?? '', isRefresh];
}

class LoadAdminCategoriesEvent extends AdminProductEvent {
  const LoadAdminCategoriesEvent();
}

class CreateProductEvent extends AdminProductEvent {
  final ProductEntity product;
  final File image;
  final File? arModel;
  final List<File>? gallery;

  const CreateProductEvent({
    required this.product,
    required this.image,
    this.arModel,
    this.gallery,
  });
}

class UpdateProductEvent extends AdminProductEvent {
  final ProductEntity product;
  final File? image;
  final File? arModel;
  final List<File>? gallery;

  const UpdateProductEvent({
    required this.product,
    this.image,
    this.arModel,
    this.gallery,
  });
}

class DeleteProductEvent extends AdminProductEvent {
  final String productId;

  const DeleteProductEvent(this.productId);
}
