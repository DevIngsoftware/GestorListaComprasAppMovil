import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/shopping_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_tile.dart';
import 'edit_item_page.dart';
import '../models/product.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  @override
  void initState() {
    super.initState();
    // Carga inicial de productos sin esperar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShoppingProvider>(context, listen: false).fetchProducts();
    });
  }
  
  // Widget para el estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_checkout_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Tu lista está vacía', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Agrega tu primer producto con el botón "+"',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShoppingProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7F53AC), Color(0xFF647DEE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Mi Lista de Compras', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await auth.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => shop.fetchProducts(),
          child: shop.items.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                  itemCount: shop.items.length,
                  itemBuilder: (_, i) {
                    final p = shop.items[i];
                    return Dismissible(
                      key: ValueKey(p.id ?? i),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.delete_sweep_outlined, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        shop.removeProduct(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${p.name} eliminado')),
                        );
                      },
                      child: ProductTile(
                        product: p,
                        onChanged: (_) => shop.toggleAcquired(p),
                        onEdit: () => _openEditModal(context, p),
                      ),
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF7F53AC),
          icon: const Icon(Icons.add),
          label: const Text('Agregar'),
          onPressed: () => _openEditModal(context, null),
        ),
      ),
    );
  }

  void _openEditModal(BuildContext context, Product? product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Permite ver el borde redondeado del contenido
      builder: (_) => Container(
        // Contenedor que aplica el borde redondeado y color de fondo
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: EditItemPage(product: product),
        ),
      ),
    );
  }
}