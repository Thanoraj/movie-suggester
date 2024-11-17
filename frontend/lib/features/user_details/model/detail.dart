// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Detail {
  final String name;

  Detail({
    required this.name,
  });

  Detail copyWith({
    String? name,
  }) {
    return Detail(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Detail.fromMap(Map<String, dynamic> map) {
    return Detail(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Detail.fromJson(String source) =>
      Detail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Detail(name: $name)';

  @override
  bool operator ==(covariant Detail other) {
    if (identical(this, other)) return true;

    return other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

// Specific categories like Language and Genre can use the same class
typedef Language = Detail;
typedef Genre = Detail;
