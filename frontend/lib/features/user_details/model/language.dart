// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Language {
  final String name;
  Language({
    required this.name,
  });

  Language copyWith({
    String? name,
  }) {
    return Language(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Language.fromJson(String source) =>
      Language.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Language(name: $name)';

  @override
  bool operator ==(covariant Language other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
