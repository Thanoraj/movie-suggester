// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:frontend/features/user_details/model/detail.dart';

class UserDetails {
  final List<Detail> preferredGenres;
  final List<Detail> preferredLanguages;

  UserDetails({
    required this.preferredGenres,
    required this.preferredLanguages,
  });

  UserDetails copyWith({
    List<Detail>? preferredGenres,
    List<Detail>? preferredLanguages,
  }) {
    return UserDetails(
      preferredGenres: preferredGenres ?? this.preferredGenres,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'preferredGenres': preferredGenres.map((x) => x.toMap()).toList(),
      'preferredLanguages': preferredLanguages.map((x) => x.toMap()).toList(),
    };
  }

  factory UserDetails.fromMap(Map<String, List<String>> map) {
    return UserDetails(
      preferredGenres: List<Genre>.from(
        (map['preferred_genres'] as List<String>).map<Detail>(
          (x) => Genre.fromMap({'name': x}),
        ),
      ),
      preferredLanguages: List<Language>.from(
        (map['preferred_languages'] as List<String>).map<Detail>(
          (x) => Language.fromMap({'name': x}),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, List<String>>);

  @override
  String toString() =>
      'UserDetails(preferredGenres: $preferredGenres, preferredLanguages: $preferredLanguages)';

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return listEquals(other.preferredGenres, preferredGenres) &&
        listEquals(other.preferredLanguages, preferredLanguages);
  }

  @override
  int get hashCode => preferredGenres.hashCode ^ preferredLanguages.hashCode;
}
