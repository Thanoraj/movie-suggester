// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:frontend/core/models/user.dart';

class VerificationStatus {
  final bool verified;
  final String? message;
  final bool expired;
  final String? token;
  final User? user;

  VerificationStatus({
    required this.verified,
    required this.message,
    required this.expired,
    required this.token,
    required this.user,
  });

  VerificationStatus copyWith({
    bool? verified,
    String? message,
    bool? expired,
    String? token,
    User? user,
  }) {
    return VerificationStatus(
      verified: verified ?? this.verified,
      message: message ?? this.message,
      expired: expired ?? this.expired,
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verified': verified,
      'message': message,
      'expired': expired,
      'token': token,
      'user': user?.toMap(),
    };
  }

  factory VerificationStatus.fromMap(Map<String, dynamic> map) {
    print(map);
    return VerificationStatus(
      verified: map['verified'] as bool,
      message: map['message'] as String?,
      expired: map['expired'] as bool,
      token: map['token'] != null ? map['token'] as String : null,
      user: map['user'] != null
          ? User.fromMap(map['user'] as Map<String, dynamic>).copyWith(
              token: map['token'] as String?,
              detailsAdded: false,
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationStatus.fromJson(String source) =>
      VerificationStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VerificationStatus(verified: $verified, message: $message, expired: $expired, token: $token, user: $user)';
  }

  @override
  bool operator ==(covariant VerificationStatus other) {
    if (identical(this, other)) return true;

    return other.verified == verified &&
        other.message == message &&
        other.expired == expired &&
        other.token == token &&
        other.user == user;
  }

  @override
  int get hashCode {
    return verified.hashCode ^
        message.hashCode ^
        expired.hashCode ^
        token.hashCode ^
        user.hashCode;
  }
}
