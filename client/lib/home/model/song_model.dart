import 'package:client/core/utils/typedef.dart';
import 'package:equatable/equatable.dart';

/// Converts a JSON map into a [SongModel] object.
SongModel songModelFromJson(DataMap json) => SongModel.fromJson(json);

/// Converts a [SongModel] object into a JSON map.
DataMap songModelToJson(SongModel song) => song.toJson();

/// A model class representing a song.
///
/// Includes:
/// - Serialization methods (`fromJson`, `toJson`)
/// - Null safety
/// - Value equality via [Equatable]
/// - A `copyWith` method for immutability and convenience
class SongModel extends Equatable {
  /// Creates a new [SongModel] instance.
  const SongModel({
    this.id,
    this.songName,
    this.artist,
    this.hexCode,
    this.songUrl,
    this.thumbnailUrl,
  });

  /// Factory constructor to create a [SongModel] from a JSON map.
  factory SongModel.fromJson(DataMap json) => SongModel(
    id: json['id']?.toString(),
    songName: json['song_name']?.toString(),
    artist: json['artist']?.toString(),
    hexCode: json['hex_code']?.toString(),
    songUrl: json['song_url']?.toString(),
    thumbnailUrl: json['thumbnail_url']?.toString(),
  );

  /// The unique identifier of the song.
  final String? id;

  /// The name of the song.
  final String? songName;

  /// The name of the artist.
  final String? artist;

  /// The hex color code associated with the song (possibly for theming).
  final String? hexCode;

  /// The URL where the song audio file is stored.
  final String? songUrl;

  /// The URL of the song's thumbnail image.
  final String? thumbnailUrl;

  /// Converts the [SongModel] to a JSON map.
  DataMap toJson() => {
    'id': id,
    'song_name': songName,
    'artist': artist,
    'hex_code': hexCode,
    'song_url': songUrl,
    'thumbnail_url': thumbnailUrl,
  };

  /// Creates a copy of the [SongModel] with optional updated fields.
  SongModel copyWith({
    String? id,
    String? songName,
    String? artist,
    String? hexCode,
    String? songUrl,
    String? thumbnailUrl,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      artist: artist ?? this.artist,
      hexCode: hexCode ?? this.hexCode,
      songUrl: songUrl ?? this.songUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  String toString() {
    return 'SongModel(id: $id, songName: $songName, artist: $artist, '
        'hexCode: $hexCode, songUrl: $songUrl, thumbnailUrl: $thumbnailUrl,)';
  }

  @override
  List<Object?> get props => [
    id,
    songName,
    artist,
    hexCode,
    songUrl,
    thumbnailUrl,
  ];
}
