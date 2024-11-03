import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_local_repository.g.dart';

@riverpod
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) =>
    AuthLocalRepository();

class AuthLocalRepository {
  static const tokenKey = 'x-auth-token';
  final storage = const FlutterSecureStorage();

  Future setToken(String? token) async {
    if (token != null) {
      await storage.write(key: tokenKey, value: token);
    }
  }

  Future<String?> getToken() async {
    String? value = await storage.read(key: tokenKey);
    return value;
  }
}
