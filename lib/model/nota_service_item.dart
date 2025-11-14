import 'service_model.dart';

class NotaServiceItem {
  final int? id;
  final String name;
  final double price;
  final String? type;
  final int minOrder;
  int quantity;

  NotaServiceItem({
    this.id,
    required this.name,
    required this.price,
    this.type,
    required this.minOrder,
    this.quantity = 1,
  });

  // Factory buat convert dari ServiceModel ke NotaServiceItem
  factory NotaServiceItem.fromServiceModel(ServiceModel service) {
    return NotaServiceItem(
      id: service.id,
      name: service.name,
      price: service.price,
      type: service.type,
      minOrder: service.minOrder ?? 1,
      quantity: 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'service_id': id,
    'add_on_id': null,
    'quantity': quantity,
    'weight': null,
    'unit_price': price,
  };
}