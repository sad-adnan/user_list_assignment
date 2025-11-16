import 'dart:math';

import 'package:hive/hive.dart';

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String get fullName => '$firstName $lastName'.trim();

  // The API does not return a phone number, so we fake a Bangladeshi number.
  String get phoneNumber {
    const operatorPrefixes = ['013', '014', '015', '016', '017', '018', '019'];
    final seededRandom = Random(id);
    final operator =
        operatorPrefixes[seededRandom.nextInt(operatorPrefixes.length)];
    final lastDigits = seededRandom
        .nextInt(10000000)
        .toString()
        .padLeft(7, '0');
    return '+88$operator$lastDigits';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final id = reader.read() as int;
    final email = reader.read() as String;
    final firstName = reader.read() as String;
    final lastName = reader.read() as String;
    final avatar = reader.read() as String;

    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..write(obj.id)
      ..write(obj.email)
      ..write(obj.firstName)
      ..write(obj.lastName)
      ..write(obj.avatar);
  }
}
