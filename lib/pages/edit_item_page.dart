import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/shopping_provider.dart';

class EditItemPage extends StatefulWidget {
  final Product? product;
  const EditItemPage({super.key, this.product});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _noteController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '1');
    _noteController = TextEditingController(text: widget.product?.note ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final shop = Provider.of<ShoppingProvider>(context, listen: false);
    
    final product = Product(
      id: widget.product?.id,
      name: _nameController.text.trim(),
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      note: _noteController.text.trim(),
      acquired: widget.product?.acquired ?? false,
    );

    try {
      if (widget.product == null) {
        await shop.addProduct(product);
      } else {
        await shop.updateProduct(product);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título del modal
            Text(
              isEditing ? 'Editar Producto' : 'Agregar Producto',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Campo de Nombre
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del producto'),
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre no puede estar vacío';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Fila para Cantidad y Notas
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Ingrese una cantidad';
                      if (int.tryParse(value) == null || int.parse(value) < 1) {
                        return 'Debe ser > 0';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(labelText: 'Nota (opcional)'),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Botón de acción
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Actualizar' : 'Agregar'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}