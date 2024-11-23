// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String name;
  final String email;
  final String id;
  final String? imageUrl;
  final String? token;
  final bool detailsAdded;

  const User({
    required this.name,
    required this.email,
    required this.id,
    this.imageUrl,
    this.token,
    this.detailsAdded = false,
  });

  User copyWith({
    String? name,
    String? email,
    String? id,
    String? imageUrl,
    String? token,
    bool? detailsAdded,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      token: token ?? this.token,
      detailsAdded: detailsAdded ?? this.detailsAdded,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'imageUrl': imageUrl,
      'token': token,
      'detailsAdded': detailsAdded,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'].toString(),
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      detailsAdded: (map['detailsAdded'] ?? false) as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, id: $id, imageUrl: $imageUrl, token: $token, detailsAdded: $detailsAdded)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.token == token &&
        other.detailsAdded == detailsAdded;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        imageUrl.hashCode ^
        token.hashCode ^
        detailsAdded.hashCode;
  }
}
