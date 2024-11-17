import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/consts/consts.dart';
import 'package:frontend/core/failures/failure.dart';
import 'package:frontend/core/models/user.dart';
import 'package:http/http.dart' as http;

class UserDetailsRepository {
  getUserPreferences(String token) async {
    try {
      final headers = {
        "Authorization": "Bearer $token", // Add JWT to Authorization header
        "Content-Type": "application/json",
      };

      const preferenceUrl = "$backendUrl/api/v1/user/preferences";

      http.Response response = await http.get(
        Uri.parse(preferenceUrl),
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
