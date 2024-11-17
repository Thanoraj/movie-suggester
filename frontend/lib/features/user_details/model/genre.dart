// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Genre {
  final String name;

  Genre({
    required this.name,
  });

  Genre copyWith({
    String? name,
  }) {
    return Genre(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Genre.fromJson(String source) =>
      Genre.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Genre(name: $name)';

  @override
  bool operator ==(covariant Genre other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
