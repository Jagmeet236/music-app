// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authViewModelHash() => r'878c092d10514ce01764df7f78e8533934331392';

/// ViewModel for managing authentication state and operations.
///
/// Copied from [AuthViewModel].
@ProviderFor(AuthViewModel)
final authViewModelProvider =
    AutoDisposeNotifierProvider<AuthViewModel, AsyncValue<UserModel?>>.internal(
  AuthViewModel.new,
  name: r'authViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthViewModel = AutoDisposeNotifier<AsyncValue<UserModel?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
