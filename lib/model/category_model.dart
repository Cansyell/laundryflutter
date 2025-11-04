// lib/models/category_model.dart
class CategoryModel {
  final int? id;
  final String name;
  final String? type;

  CategoryModel({
    this.id,
    required this.name,
    this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
    };
  }
}