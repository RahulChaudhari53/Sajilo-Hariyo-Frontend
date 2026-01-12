import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sajilo_hariyo/app/constant/api_endpoints.dart';
import 'package:sajilo_hariyo/features/home/data/model/category_api_model.dart';
import 'package:sajilo_hariyo/features/home/data/model/product_api_model.dart';
import 'package:sajilo_hariyo/features/home/domain/entity/product_entity.dart';
import '../product_data_source.dart';

class ProductRemoteDataSource implements IProductDataSource {
  final Dio _dio;
  ProductRemoteDataSource(this._dio);

  @override
  Future<List<ProductApiModel>> getProducts({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    try {
      final url = ApiEndpoints.getProductsWithQuery(
        category: category,
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
      );

      var response = await _dio.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['data']['products'];
        return productsJson
            .map((json) => ProductApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<ProductApiModel> getProductById(String id) async {
    try {
      var response = await _dio.get(ApiEndpoints.getProductById(id));
      if (response.statusCode == 200) {
        return ProductApiModel.fromJson(response.data['data']['product']);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> createProduct(
    ProductEntity product,
    File image,
    File? arModel,
    List<File>? gallery,
  ) async {
    try {
      String fileName = image.path.split('/').last;

      FormData formData = FormData.fromMap({
        "name": product.name,
        "botanicalName": product.botanicalName,
        "family": product.family,
        "price": product.price,
        "stock": product.stock,
        "description": product.description,
        "category": product.categoryId,
        "difficulty": product.difficulty,
        "light": product.light,
        "water": product.water,
        "temperature": product.temperature,
        "humidity": product.humidity,
        "height": product.height,
        "potSize": product.potSize,
        "isPetFriendly": product.isPetFriendly.toString(),
        "isAirPurifying": product.isAirPurifying.toString(),
        "isTrending": product.isTrending.toString(),
        "image": await MultipartFile.fromFile(
          image.path,
          filename: fileName,
          contentType: MediaType("image", "jpeg"),
        ),
      });

      // Add AR Model if exists
      if (arModel != null) {
        formData.files.add(
          MapEntry(
            "arModel",
            await MultipartFile.fromFile(
              arModel.path,
              filename: arModel.path.split('/').last,
              contentType: MediaType(
                "application",
                "octet-stream",
              ), // Standard for .glb
            ),
          ),
        );
      }

      // Add Gallery if exists
      if (gallery != null && gallery.isNotEmpty) {
        for (var file in gallery) {
          formData.files.add(
            MapEntry(
              "gallery",
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
                contentType: MediaType("image", "jpeg"),
              ),
            ),
          );
        }
      }

      var response = await _dio.post(
        ApiEndpoints.createProduct,
        data: formData,
      );
      if (response.statusCode != 201) {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> updateProduct(
    ProductEntity product, {
    File? image,
    File? arModel,
    List<File>? gallery,
  }) async {
    try {
      // Logic same as create but using PATCH and making files optional
      FormData formData = FormData.fromMap({
        "name": product.name,
        "botanicalName": product.botanicalName,
        "family": product.family,
        "price": product.price,
        "stock": product.stock,
        "description": product.description,
        "category": product.categoryId,
        "difficulty": product.difficulty,
        "light": product.light,
        "water": product.water,
        "temperature": product.temperature,
        "humidity": product.humidity,
        "height": product.height,
        "potSize": product.potSize,
        "isPetFriendly": product.isPetFriendly.toString(),
        "isAirPurifying": product.isAirPurifying.toString(),
        "isTrending": product.isTrending.toString(),
      });

      if (image != null) {
        formData.files.add(
          MapEntry(
            "image",
            await MultipartFile.fromFile(
              image.path,
              contentType: MediaType("image", "jpeg"),
            ),
          ),
        );
      }

      if (arModel != null) {
        formData.files.add(
          MapEntry(
            "arModel",
            await MultipartFile.fromFile(
              arModel.path,
              contentType: MediaType("application", "octet-stream"),
            ),
          ),
        );
      }

      var response = await _dio.patch(
        ApiEndpoints.updateProduct(product.id!),
        data: formData,
      );

      if (response.statusCode != 200) {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      var response = await _dio.delete(ApiEndpoints.deleteProduct(id));
      if (response.statusCode != 204) {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  @override
  Future<List<CategoryApiModel>> getCategories() async {
    try {
      var response = await _dio.get(ApiEndpoints.getCategories);
      if (response.statusCode == 200) {
        // Backend returns { status: "success", data: { categories: [...] } }
        final List<dynamic> categoriesJson =
            response.data['data']['categories'];
        return categoriesJson
            .map((json) => CategoryApiModel.fromJson(json))
            .toList();
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}
