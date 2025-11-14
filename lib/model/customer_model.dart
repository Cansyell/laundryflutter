class CustomerModel {
  final String? id; // ✅ Ganti jadi String?
  final String name;
  final String? phone;
  final String? address;

  // Constructor dengan default kosong (untuk state "belum dipilih")
  CustomerModel({
    this.id,
    this.name = '',
    this.phone,
    this.address,
  });

  // Factory dari JSON (API biasanya kirim id sebagai string/number)
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'];
    return CustomerModel(
      id: rawId != null ? rawId.toString() : null, // aman untuk int/string
      name: json['name'] ?? '',
      phone: json['phone'],
      address: json['address'],
    );
  }

  // Untuk kirim ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}