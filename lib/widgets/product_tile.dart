import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;

  const ProductTile({
    super.key,
    required this.product,
    required this.onChanged,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Checkbox(
          value: product.acquired,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: product.acquired ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: product.note != null && product.note!.isNotEmpty
            ? Text('Cantidad: ${product.quantity} • ${product.note}')
            : Text('Cantidad: ${product.quantity}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.deepPurple),
          onPressed: onEdit,
        ),
      ),
    );
  }
}
