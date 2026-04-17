import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_02/domain/entities/product.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  final Product? productToEdit;

  const ProductFormPage({super.key, this.productToEdit});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late double _price;
  late String _description;
  late String _image;

  @override
  void initState() {
    super.initState();
    _title = widget.productToEdit?.title ?? '';
    _price = widget.productToEdit?.price ?? 0.0;
    _description = widget.productToEdit?.description ?? '';
    _image = widget.productToEdit?.image ?? '';
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final viewmodel = context.read<ProductViewmodel>();
    final isEditing = widget.productToEdit != null;

    final product = Product(
      id: isEditing ? widget.productToEdit!.id : DateTime.now().millisecondsSinceEpoch,
      title: _title,
      price: _price,
      description: _description,
      image: _image.isEmpty ? "https://via.placeholder.com/150" : _image,
      isFavorited: widget.productToEdit?.isFavorited ?? false,
    );

    if (isEditing) {
      viewmodel.updateProduct(product);
    } else {
      viewmodel.addProduct(product);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (value) => value!.isEmpty ? 'Informe um título' : null,
                  onSaved: (value) => _title = value!,
                ),
                TextFormField(
                  initialValue: widget.productToEdit != null ? _price.toString() : '',
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Informe um preço';
                    if (double.tryParse(value) == null) return 'Preço inválido';
                    return null;
                  },
                  onSaved: (value) => _price = double.parse(value!),
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                  onSaved: (value) => _description = value ?? '',
                ),
                TextFormField(
                  initialValue: _image,
                  decoration: const InputDecoration(labelText: 'URL da Imagem'),
                  onSaved: (value) => _image = value ?? '',
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    child: Text(isEditing ? 'Atualizar' : 'Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
