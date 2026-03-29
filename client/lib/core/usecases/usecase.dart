// ignore_for_file: one_member_abstracts

import 'package:client/core/utils/typedef.dart';

/// Base class for usecases that require parameters.
// ignore: avoid_types_as_parameter_names
abstract class UseCaseWithParams<Type, Params> {
  /// Creates a [UseCaseWithParams].
  const UseCaseWithParams();

  /// Executes the use case.
  ResultFuture<Type> call(Params params);
}

/// Base class for usecases that do not require parameters.
abstract class UseCaseWithoutParams<Type> {
  /// Creates a [UseCaseWithoutParams].
  const UseCaseWithoutParams();

  /// Executes the use case.
  ResultFuture<Type> call();
}
