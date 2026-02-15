class SongModel {
  final String id;
  final String title;
  final String artist;
  final String userId;
  final String songUrl;
  final String thumbnailUrl;
  final String colorHexCode;

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    required this.userId,
    required this.songUrl,
    required this.thumbnailUrl,
    required this.colorHexCode,
  });

  /// Copy constructor
  SongModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? userId,
    String? songUrl,
    String? thumbnailUrl,
    String? colorHexCode,
  }) => SongModel(
    id: id ?? this.id,
    title: title ?? this.title,
    artist: artist ?? this.artist,
    userId: userId ?? this.userId,
    songUrl: songUrl ?? this.songUrl,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    colorHexCode: colorHexCode ?? this.colorHexCode,
  );

  /// Create a SongModel from JSON
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      userId: json['user_id'] ?? '',
      songUrl: json['song_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      colorHexCode: json['color_hex_code'] ?? '',
    );
  }

  /// Convert SongModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'user_id': userId,
      'song_url': songUrl,
      'thumbnail_url': thumbnailUrl,
      'color_hex_code': colorHexCode,
    };
  }
}
