import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_02/presentation/pages/login_page.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  final client = http.Client();
  final authDatasource = AuthRemoteDatasource(client);
  final productDatasource = ProductRemoteDatasource(client);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(productDatasource, cache);

  runApp(MyApp(authDatasource: authDatasource, repository: repository));
}

class MyApp extends StatelessWidget {
  final AuthRemoteDatasource authDatasource;
  final ProductRepositoryImpl repository;

  const MyApp({
    super.key,
    required this.authDatasource,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewmodel(authDatasource)),
        ChangeNotifierProvider(
          create: (_) => ProductViewmodel(repository)..loadProducts(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DummyJSON Store',
        home: LoginPage(),
      ),
    );
  }
}
