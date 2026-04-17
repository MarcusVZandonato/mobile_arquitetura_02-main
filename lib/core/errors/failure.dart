import 'package:mobile_arquitetura_02/domain/entities/product.dart';

class Failure implements Exception {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}

class OfflineFailure extends Failure {
  final List<Product>? cachedData;

  OfflineFailure(super.message, {this.cachedData});
}
