import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/consts/consts.dart';
import 'package:frontend/core/failures/failure.dart';
import 'package:frontend/core/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) =>
    AuthRemoteRepository();

class AuthRemoteRepository {
  Future<Either<Failure, User>> signUp(
      String name, String email, String password) async {
    try {
      const headers = {
        "Content-type": "application/json",
      };

      final body = jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      });

      const registerUrl = "$backendUrl/api/v1/register";

      http.Response response = await http.post(
        Uri.parse(registerUrl),
        headers: headers,
        body: body,
      );

      print(response.statusCode);

      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201) {
        return Right(User.fromMap(res['result']).copyWith(token: res['token']));
      } else {
        return Left(
          Failure(
            message: res['message'],
          ),
        );
      }
    } catch (e) {
      return Left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, User>> signIn(String email, String password) async {
    try {
      const headers = {
        "Content-type": "application/json",
      };

      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      const registerUrl = "$backendUrl/api/v1/login";

      http.Response response = await http.post(
        Uri.parse(registerUrl),
        headers: headers,
        body: body,
      );

      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(User.fromMap(res['result']).copyWith(token: res['token']));
      } else {
        return Left(
          Failure(
            message: res['message'],
          ),
        );
      }
    } catch (e) {
      return Left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, User>> getUser(String token) async {
    try {
      final headers = {
        "Authorization": "Bearer $token", // Add JWT to Authorization header
        "Content-Type": "application/json",
      };

      const registerUrl = "$backendUrl/api/v1/user";

      http.Response response = await http.get(
        Uri.parse(registerUrl),
        headers: headers,
      );

      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(User.fromMap(res['result']).copyWith(token: token));
      } else {
        return Left(
          Failure(
            message: res['message'],
          ),
        );
      }
    } catch (e) {
      return Left(
        Failure(
          message: e.toString(),
        ),
      );
    }
  }
}
