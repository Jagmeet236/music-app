import 'package:client/core/utils/typedef.dart';
import 'package:equatable/equatable.dart';

/// Converts a JSON map into a [UserModel] object.
UserModel userModelFromJson(Map<String, dynamic> json) =>
    UserModel.fromJson(json);

/// Converts a [UserModel] object into a JSON map.
DataMap userModelToJson(UserModel user) => user.toJson();

/// A model class representing a user.
///
/// Includes:
/// - Serialization methods (`fromJson`, `toJson`)
/// - Null safety
/// - Value equality via [Equatable]
/// - A `copyWith` method for immutability and convenience
class UserModel extends Equatable {
  /// Creates a new [UserModel] instance.
  const UserModel({this.id, this.email, this.name});

  /// Factory constructor to create a [UserModel] from a JSON map.
  factory UserModel.fromJson(DataMap json) => UserModel(
    id: json['id'] as String?,
    email: json['email'] as String?,
    name: json['name'] as String?,
  );

  /// The unique identifier of the user.
  final String? id;

  /// The user's email address.
  final String? email;

  /// The user's display name.
  final String? name;

  /// Converts the [UserModel] to a JSON map.
  DataMap toJson() => {'id': id, 'email': email, 'name': name};

  /// Creates a copy of the [UserModel] with optional updated fields.
  UserModel copyWith({String? id, String? email, String? name}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name)';
  }

  @override
  List<Object?> get props => [id, email, name];
}
