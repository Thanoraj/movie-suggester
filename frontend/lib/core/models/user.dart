// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String name;
  final String email;
  final String id;
  final String? imageUrl;
  final String? token;

  const User({
    required this.name,
    required this.email,
    required this.id,
    this.imageUrl,
    this.token,
  });

  User copyWith({
    String? name,
    String? email,
    String? id,
    String? imageUrl,
    String? token,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'id': id,
      'imageUrl': imageUrl,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'].toString(),
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(name: $name, email: $email, id: $id, imageUrl: $imageUrl, token: $token)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.imageUrl == imageUrl &&
        other.token == token;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        id.hashCode ^
        imageUrl.hashCode ^
        token.hashCode;
  }
}
