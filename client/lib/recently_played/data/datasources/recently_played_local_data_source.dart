import 'dart:convert';
import 'package:client/home/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'recently_played_local_data_source.g.dart';

/// Interface for the local data source that handles recently played songs.
abstract class RecentlyPlayedLocalDataSource {
  /// Retrieves the list of recently played songs for the given [userId].
  Future<List<SongModel>> getRecentlyPlayedSongs(String userId);

  /// Saves the list of recently played [songs] for the given [userId].
  Future<void> saveRecentlyPlayedSongs(String userId, List<SongModel> songs);

  /// Clears the entire list of recently played songs for the given [userId].
  Future<void> clearRecentlyPlayedSongs(String userId);

  /// Removes a specific song by [songId] for the given [userId].
  Future<void> removeRecentlyPlayedSong(String userId, String songId);
}

/// Provides an instance of [RecentlyPlayedLocalDataSource].
@Riverpod(keepAlive: true)
RecentlyPlayedLocalDataSource recentlyPlayedLocalDataSource(
  RecentlyPlayedLocalDataSourceRef ref,
) {
  return RecentlyPlayedLocalDataSourceImpl();
}

/// Concrete implementation of [RecentlyPlayedLocalDataSource] 
/// using [SharedPreferences].
class RecentlyPlayedLocalDataSourceImpl
    implements RecentlyPlayedLocalDataSource {
  String _getKey(String userId) => 'recent_songs_$userId';

  @override
  Future<List<SongModel>> getRecentlyPlayedSongs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getKey(userId));
    if (jsonString != null) {
      try {
        final jsonList = jsonDecode(jsonString) as List<dynamic>;
        return jsonList
            .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } on Exception catch (e) {
        debugPrint(e.toString());
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> saveRecentlyPlayedSongs(
    String userId,
    List<SongModel> songs,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = songs.map((e) => e.toJson()).toList();
    await prefs.setString(_getKey(userId), jsonEncode(jsonList));
  }

  @override
  Future<void> clearRecentlyPlayedSongs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getKey(userId));
  }

  @override
  Future<void> removeRecentlyPlayedSong(String userId, String songId) async {
    final songs = await getRecentlyPlayedSongs(userId);
    // Right-shift / O(n) removal
    songs.removeWhere((s) => s.id == songId);
    await saveRecentlyPlayedSongs(userId, songs);
  }
}
