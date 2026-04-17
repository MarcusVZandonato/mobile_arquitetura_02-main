import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Para atualizar o ícone de favorito dinamicamente mesmo nesta tela
    final viewmodel = context.watch<ProductViewmodel>();
    
    // Procura o produto atualizado no viewmodel (pode ter sido favoritado)
    final currentProduct = viewmodel.products.firstWhere(
      (p) => p.id == product.id,
      orElse: () => product,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home),
            tooltip: 'Voltar ao Início',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                currentProduct.image,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    currentProduct.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    currentProduct.isFavorited
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: currentProduct.isFavorited ? Colors.green : Colors.grey,
                    size: 32,
                  ),
                  onPressed: () => viewmodel.toggleFavorite(currentProduct.id),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${currentProduct.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Descrição',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currentProduct.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
