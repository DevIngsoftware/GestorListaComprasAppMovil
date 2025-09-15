class Product {
  int? id;
  String name;
  int quantity;
  String? note;
  bool acquired;

  Product({
    this.id,
    required this.name,
    required this.quantity,
    this.note,
    this.acquired = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        quantity: json['quantity'],
        note: json['note'],
        acquired: json['acquired'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'note': note,
        'acquired': acquired,
      };
}
