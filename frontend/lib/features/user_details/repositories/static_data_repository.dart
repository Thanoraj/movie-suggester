import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:frontend/core/consts/consts.dart';
import 'package:frontend/core/failures/failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'static_data_repository.g.dart';

@riverpod
StaticDataRepository staticDataRepository(StaticDataRepositoryRef ref) =>
    StaticDataRepository();

class StaticDataRepository {
  Future<Either<Failure, Map>> getAvailableGenresAndLanguages(
      String token) async {
    try {
      final headers = {
        "Authorization": "Bearer $token", // Add JWT to Authorization header
        "Content-Type": "application/json",
      };

      const preferenceUrl = "$backendUrl/api/v1/languages-and-genres";

      http.Response response = await http.get(
        Uri.parse(preferenceUrl),
        headers: headers,
      );

      final res = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right({
          "genres": res['genres'],
          "languages": res['languages'],
        });
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
