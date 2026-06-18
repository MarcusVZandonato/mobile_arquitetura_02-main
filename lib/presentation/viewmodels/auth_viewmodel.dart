import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_02/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_02/domain/entities/user.dart';

class AuthViewmodel extends ChangeNotifier {
  final AuthRemoteDatasource _datasource;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthViewmodel(this._datasource);

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<bool> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      _error = 'Preencha o usuário e a senha';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final model = await _datasource.login(username, password);
      _user = model.toEntity();
      return true;
    } on Exception catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } catch (e) {
      _error = 'Erro inesperado: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _error = null;
    notifyListeners();
  }
}
