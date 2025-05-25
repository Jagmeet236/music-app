import 'package:client/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Represents a future that returns either an error message [String]
/// or a success result of type [T].
typedef ResultFuture<T> = Future<Either<AppFailure, T>>;

/// Shorthand for a data payload.
typedef DataMap = Map<String, dynamic>;
