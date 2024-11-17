import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/consts/consts.dart';
import 'package:frontend/core/failures/failure.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_details_repository.g.dart';

@riverpod
UserDetailsRepository userDetailsRepository(UserDetailsRepositoryRef ref) =>
    UserDetailsRepository();

class UserDetailsRepository {
  Future<Either<Failure, Map<String, List<String>>>> getUserPreferences(
      String token) async {
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
        return Right(
          transformToListString(
            res['result'],
          ),
        );
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

  Map<String, List<String>> transformToListString(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is List) {
        // Ensure every element in the list is a String
        final list = value.whereType<String>().toList();
        return MapEntry(key, list);
      } else {
        throw ArgumentError("Value for key $key is not a List<String>");
      }
    });
  }

  Future<Either<Failure, String>> saveUserPreferences(
    String token,
    List<String> preferredGenres,
    List<String> preferredLanguages,
  ) async {
    try {
      final headers = {
        "Authorization": "Bearer $token", // Add JWT to Authorization header
        "Content-Type": "application/json",
      };

      const preferenceUrl = "$backendUrl/api/v1/user/update-preferences";

      final body = jsonEncode({
        "preferred_genres": preferredGenres,
        "preferred_languages": preferredLanguages,
      });

      http.Response response = await http.post(Uri.parse(preferenceUrl),
          headers: headers, body: body);

      await Future.delayed(Duration(seconds: 10));

      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(res['message']);
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
