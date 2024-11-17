// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:frontend/features/user_details/model/genre.dart';
import 'package:frontend/features/user_details/model/language.dart';

class UserDetails {
  final List<Genre> preferredGenres;
  final List<Language> preferredLanguages;

  UserDetails({
    required this.preferredGenres,
    required this.preferredLanguages,
  });

  UserDetails copyWith({
    List<Genre>? preferredGenres,
    List<Language>? preferredLanguages,
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

  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      preferredGenres: List<Genre>.from(
        (map['preferredGenres'] as List<int>).map<Genre>(
          (x) => Genre.fromMap(x as Map<String, dynamic>),
        ),
      ),
      preferredLanguages: List<Language>.from(
        (map['preferredLanguages'] as List<int>).map<Language>(
          (x) => Language.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

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
