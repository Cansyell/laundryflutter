// lib/model/service_model.dart
import 'category_model.dart';

class ServiceModel {
  final int? id;
  final String name;
  final int? categoryId;
  final double price;
  final double? discount;
  final int? minOrder;
  final String? type;
  final String? estimate;
  final String? description;
  final CategoryModel? category;

  ServiceModel({
    this.id,
    required this.name,
    this.categoryId,
    required this.price,
    this.discount,
    this.minOrder,
    this.type,
    this.estimate,
    this.description,
    this.category,
  });

  // Helper untuk safe parsing double
  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    
    if (value is double) return value;
    if (value is int) return value.toDouble();
    
    if (value is String) {
      final cleanValue = value.trim().replaceAll(',', '.');
      try {
        return double.parse(cleanValue);
      } catch (e) {
        print('⚠️ Error parsing double from "$value": $e');
        return defaultValue;
      }
    }
    
    return defaultValue;
  }

  // Helper untuk safe parsing int
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    
    if (value is int) return value;
    if (value is double) return value.toInt();
    
    if (value is String) {
      try {
        return int.parse(value.trim());
      } catch (e) {
        print('⚠️ Error parsing int from "$value": $e');
        return defaultValue;
      }
    }
    
    return defaultValue;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    try {
      return ServiceModel(
        id: _parseInt(json['id']),
        name: json['name']?.toString() ?? '',
        categoryId: json['category_id'] != null 
            ? _parseInt(json['category_id']) 
            : null,
        price: _parseDouble(json['price'], defaultValue: 0.0),
        discount: json['discount'] != null 
            ? _parseDouble(json['discount'], defaultValue: 0.0)
            : null,
        minOrder: json['min_order'] != null 
            ? _parseInt(json['min_order'], defaultValue: 1)
            : null,
        type: json['type']?.toString(),
        estimate: json['estimate']?.toString(),
        description: json['description']?.toString(),
        category: json['category'] != null 
            ? CategoryModel.fromJson(json['category'])
            : null,
      );
    } catch (e) {
      print('❌ Error parsing ServiceModel from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (categoryId != null) 'category_id': categoryId,
      'price': price,
      if (discount != null) 'discount': discount,
      if (minOrder != null) 'min_order': minOrder,
      if (type != null) 'type': type,
      if (estimate != null) 'estimate': estimate,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return 'ServiceModel(id: $id, name: $name, price: $price, discount: $discount)';
  }
}