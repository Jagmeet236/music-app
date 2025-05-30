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
  const UserModel({this.id, this.email, this.name, this.token});

  /// Factory constructor to create a [UserModel] from a JSON map.
  factory UserModel.fromJson(DataMap json) => UserModel(
    id: json['id']?.toString(),
    email: json['email']?.toString(),
    name: json['name']?.toString(),
    token: json['token']?.toString(),
  );

  /// The unique identifier of the user.
  final String? id;

  /// The user's email address.
  final String? email;

  /// The user's display name.
  final String? name;

  /// An optional authentication token for the user.
  final String? token;

  /// Converts the [UserModel] to a JSON map.
  DataMap toJson() => {
    'id': id,
    'email': email,
    'name': name,
    if (token != null) 'token': token,
  };

  /// Creates a copy of the [UserModel] with optional updated fields.
  UserModel copyWith({String? id, String? email, String? name, String? token}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, )';
  }

  @override
  List<Object?> get props => [id, email, name];
}
