class SliderModel {
  final String id;
  final String photoUrl;
  final String description;

  SliderModel({required this.id, required this.photoUrl, required this.description});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['_id'] ?? '',
      photoUrl: json['photo_url'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class CategoryModel {
  final String id;
  final String title;
  final String icon;

  CategoryModel({required this.id, required this.title, required this.icon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class ProductModel {
  final String id;
  final String title;
  final num currentPrice;
  final List<String> photos;
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.currentPrice,
    required this.photos,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      currentPrice: json['current_price'] ?? 0,
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] ?? '',
    );
  }
}