// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authViewModelHash() => r'a6dfd27d5722fa50d9f5a3fa31406fb674342be3';

/// Manages authentication state and operations using [AuthRepository].
///
/// Copied from [AuthViewModel].
@ProviderFor(AuthViewModel)
final authViewModelProvider =
    AutoDisposeNotifierProvider<AuthViewModel, AuthState>.internal(
  AuthViewModel.new,
  name: r'authViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthViewModel = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
