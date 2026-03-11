import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    super.id,
    super.title,
    super.description,
    super.price,
    super.thumbnail,
    super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      thumbnail: json['thumbnail'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }
}

class ProductResponse extends ProductResponseEntity {
  ProductResponse({
    List<ProductModel>? products,
    super.total,
    super.skip,
    super.limit,
  }) : super(products: products);

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: json['products'] != null
          ? (json['products'] as List).map((i) => ProductModel.fromJson(i)).toList()
          : null,
      total: json['total'],
      skip: json['skip'],
      limit: json['limit'],
    );
  }
}
