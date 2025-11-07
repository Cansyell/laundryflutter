// lib/model/category_model.dart
class CategoryModel {
  String? id;
  String name;
  String? type;

  CategoryModel({this.id, required this.name, this.type});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString(),
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