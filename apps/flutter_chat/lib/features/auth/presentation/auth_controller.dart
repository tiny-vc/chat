import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';

class AuthController extends ChangeNotifier {
  AuthController({required AuthRepository repository})
    : _repository = repository;

  final AuthRepository _repository;
  bool _disposed = false;
  bool isLoading = false;
  String? errorMessage;

  void clearError() {
    if (_disposed || errorMessage == null) return;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<bool> login(String username, String password) async {
    return _run(
      () => _repository.login(username: username, password: password),
    );
  }

  Future<bool> register(
    String username,
    String nickname,
    String password,
  ) async {
    return _run(
      () => _repository.register(
        username: username,
        nickname: nickname,
        password: password,
      ),
    );
  }

  Future<bool> _run(Future<void> Function() operation) async {
    if (_disposed || isLoading) return false;
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await operation();
      return !_disposed;
    } on DioException catch (error) {
      // Do not render internal server messages or exception strings.
      errorMessage = switch (error.response?.statusCode) {
        400 => '输入格式不正确，请检查后重试',
        401 => '用户名或密码不正确',
        403 => '账号暂时无法使用，请联系管理员',
        409 => '用户名已被使用，请换一个',
        429 => '操作过于频繁，请稍后再试',
        final int status when status >= 500 => '服务暂时不可用，请稍后重试',
        _ => '无法连接服务器，请检查网络后重试',
      };
      return false;
    } catch (_) {
      errorMessage = '暂时无法完成操作，请稍后重试';
      return false;
    } finally {
      isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }
}
