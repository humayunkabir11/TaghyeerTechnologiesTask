class ProductEntity {
  final int? id;
  final String? title;
  final String? description;
  final double? price;
  final String? thumbnail;
  final List<String>? images;

  ProductEntity({
    this.id,
    this.title,
    this.description,
    this.price,
    this.thumbnail,
    this.images,
  });
}

class ProductResponseEntity {
  final List<ProductEntity>? products;
  final int? total;
  final int? skip;
  final int? limit;

  ProductResponseEntity({
    this.products,
    this.total,
    this.skip,
    this.limit,
  });
}
