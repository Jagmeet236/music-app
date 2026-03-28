// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recently_played_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentlyPlayedViewModelHash() =>
    r'3dab5d58ade6225d64cc128f0e55fa3551884ca5';

/// ViewModel responsible for managing the state of
///  recently played songs.
/// It listens to the current song and current user
/// to update the list.
///
/// Copied from [RecentlyPlayedViewModel].
@ProviderFor(RecentlyPlayedViewModel)
final recentlyPlayedViewModelProvider = AutoDisposeAsyncNotifierProvider<
    RecentlyPlayedViewModel, List<SongModel>>.internal(
  RecentlyPlayedViewModel.new,
  name: r'recentlyPlayedViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentlyPlayedViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentlyPlayedViewModel = AutoDisposeAsyncNotifier<List<SongModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
