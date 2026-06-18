import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/presentation/pages/login_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_details_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_form_page.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  void _logout(BuildContext context) {
    context.read<AuthViewmodel>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ProductViewmodel>();
    final auth = context.watch<AuthViewmodel>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Produtos'),
            if (user != null)
              Text(
                'Olá, ${user.firstName}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '${viewmodel.favoriteCount} ♥',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewmodel,
        builder: (context, _) {
          if (viewmodel.isLoading && viewmodel.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewmodel.error != null && viewmodel.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(viewmodel.error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: viewmodel.loadProducts,
                      child: const Text("Tentar novamente"),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              if (viewmodel.isLoading) const LinearProgressIndicator(),
              if (viewmodel.error != null)
                Container(
                  width: double.infinity,
                  color: Colors.red.shade400,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    viewmodel.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              SwitchListTile(
                title: const Text("Mostrar apenas favoritos"),
                value: viewmodel.showOnlyFavorites,
                onChanged: viewmodel.setShowOnlyFavorites,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewmodel.products.length,
                  itemBuilder: (context, index) {
                    final product = viewmodel.products[index];

                    return Container(
                      color: product.isFavorited
                          ? Colors.yellow.withValues(alpha: 0.5)
                          : Colors.transparent,
                      child: ListTile(
                        leading: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 50),
                        ),
                        title: Text(product.title),
                        subtitle: Text("\$${product.price}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        ProductFormPage(productToEdit: product),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  viewmodel.deleteProduct(product.id),
                            ),
                            IconButton(
                              icon: Icon(
                                product.isFavorited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    product.isFavorited ? Colors.green : null,
                              ),
                              onPressed: () =>
                                  viewmodel.toggleFavorite(product.id),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailsPage(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addBtn',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductFormPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'refreshBtn',
            onPressed: viewmodel.loadProducts,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
