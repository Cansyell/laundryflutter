// lib/model/transaction_model.dart

class TransactionModel {
  final int? id;
  final String? customerId;
  final String transactionDate;
  final String estimatedFinish;
  final double totalAmount;
  final String paymentStatus; // 'paid' atau 'unpaid'
  final String status; // 'pending', 'process', 'done'
  final List<TransactionItemModel> items;
  final String? notes;

  TransactionModel({
    this.id,
    this.customerId,
    required this.transactionDate,
    required this.estimatedFinish,
    required this.totalAmount,
    this.paymentStatus = 'unpaid',
    this.status = 'pending',
    required this.items,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'transaction_date': transactionDate,
      'estimated_finish': estimatedFinish,
      'total_amount': totalAmount,
      'payment_status': paymentStatus,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      customerId: json['customer_id']?.toString(),
      transactionDate: json['transaction_date'] ?? '',
      estimatedFinish: json['estimated_finish'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paymentStatus: json['payment_status'] ?? 'unpaid',
      status: json['status'] ?? 'pending',
      items: (json['items'] as List?)
              ?.map((item) => TransactionItemModel.fromJson(item))
              .toList() ??
          [],
      notes: json['notes'],
    );
  }
}

class TransactionItemModel {
  final int? id;
  final int? serviceId;
  final String serviceName;
  final double price;
  final int quantity;
  final double subtotal;

  TransactionItemModel({
    this.id,
    this.serviceId,
    required this.serviceName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: json['id'],
      serviceId: json['service_id'],
      serviceName: json['service_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }
}