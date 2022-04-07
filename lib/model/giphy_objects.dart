import 'package:json_annotation/json_annotation.dart';

part 'giphy_objects.g.dart';

@JsonSerializable()
class GiphyResponse {
  final List<GifBundle> data;
  final Pagination pagination;

  GiphyResponse(this.data, this.pagination);

  factory GiphyResponse.fromJson(Map<String, dynamic> json) =>
      _$GiphyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GiphyResponseToJson(this);
}

@JsonSerializable()
class GifBundle {
  final String id;
  final String url;
  @JsonKey(name: "embed_url")
  final String embedUrl;
  final String? username;
  final String? source;
  final String? rating;
  @JsonKey(name: "create_datetime")
  final String? createDatetime;
  @JsonKey(name: "update_datetime")
  final String? updateDatetime;
  final String? title;
  final User? user;
  @JsonKey(name: "images")
  final GifSources sources;
  @JsonKey(toJson: _datetimeToString, fromJson: _datetimeFromString)
  final DateTime? addTime;

  String get normalizedTitle {
    if (title != null) {
      try {
        final trashBeginIndex = "GIF".allMatches(title.toString()).first.start;
        if (trashBeginIndex == 0) return "=^..^=";
        return title!.substring(0, trashBeginIndex - 1);
      } on Exception catch (_) {
        return "=^..^=";
      }
    }

    return "=^..^=";
  }

  GifBundle(
      this.id,
      this.url,
      this.embedUrl,
      this.username,
      this.source,
      this.rating,
      this.createDatetime,
      this.updateDatetime,
      this.title,
      this.user,
      this.sources,
      this.addTime);

  factory GifBundle.fromJson(Map<String, dynamic> json) {
    return json["data"] == null
        ? _$GifBundleFromJson(json)
        : _$GifBundleFromJson(json["data"]);
  }

  Map<String, dynamic> toJson() => _$GifBundleToJson(this);

  static String _datetimeToString(DateTime? dateTime) =>
      dateTime.toString() ?? "";

  static DateTime? _datetimeFromString(String? string) =>
      string == null ? null : DateTime.tryParse(string);

  @override
  String toString() {
    return 'GifBundle{id: $id, url: $url, embedUrl: $embedUrl, username: $username, source: $source, rating: $rating, createDatetime: $createDatetime, updateDatetime: $updateDatetime, title: $title, user: $user, sources: $sources}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GifBundle &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          embedUrl == other.embedUrl &&
          username == other.username &&
          source == other.source &&
          rating == other.rating &&
          createDatetime == other.createDatetime &&
          updateDatetime == other.updateDatetime &&
          title == other.title &&
          user == other.user &&
          sources == other.sources;

  @override
  int get hashCode =>
      id.hashCode ^
      url.hashCode ^
      embedUrl.hashCode ^
      username.hashCode ^
      source.hashCode ^
      rating.hashCode ^
      createDatetime.hashCode ^
      updateDatetime.hashCode ^
      title.hashCode ^
      user.hashCode ^
      sources.hashCode;

  GifBundle copyWith({
    String? id,
    String? url,
    String? embedUrl,
    String? username,
    String? source,
    String? rating,
    String? createDatetime,
    String? updateDatetime,
    String? title,
    User? user,
    GifSources? sources,
    DateTime? addTime,
  }) {
    return GifBundle(
      id ?? this.id,
      url ?? this.url,
      embedUrl ?? this.embedUrl,
      username ?? this.username,
      source ?? this.source,
      rating ?? this.rating,
      createDatetime ?? this.createDatetime,
      updateDatetime ?? this.updateDatetime,
      title ?? this.title,
      user ?? this.user,
      sources ?? this.sources,
      addTime ?? this.addTime,
    );
  }
}

@JsonSerializable()
class GifSources {
  ///Data on versions of this GIF with a fixed height of 200 pixels. Good for mobile use.
  @JsonKey(name: "fixed_height")
  final Gif fixedHeightGif;

  ///Data on the original version of this GIF. Good for desktop use.
  @JsonKey(name: "original")
  final Gif originalGif;

  factory GifSources.fromJson(Map<String, dynamic> json) =>
      _$GifSourcesFromJson(json);

  GifSources(this.fixedHeightGif, this.originalGif);

  Map<String, dynamic> toJson() => _$GifSourcesToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GifSources &&
          runtimeType == other.runtimeType &&
          fixedHeightGif == other.fixedHeightGif &&
          originalGif == other.originalGif;

  @override
  int get hashCode => fixedHeightGif.hashCode ^ originalGif.hashCode;
}

@JsonSerializable()
class Gif {
  final String url;
  @JsonKey(fromJson: _lengthFromJson, toJson: _lengthToJson)
  final int width;
  @JsonKey(fromJson: _lengthFromJson, toJson: _lengthToJson)
  final int height;

  Gif(this.url, this.width, this.height);

  factory Gif.fromJson(Map<String, dynamic> json) => _$GifFromJson(json);

  Map<String, dynamic> toJson() => _$GifToJson(this);

  static int _lengthFromJson(String length) => int.parse(length);

  static String _lengthToJson(int length) => length.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gif &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          width == other.width &&
          height == other.height;

  @override
  int get hashCode => url.hashCode ^ width.hashCode ^ height.hashCode;
}

@JsonSerializable()
class Pagination {
  final int offset;
  @JsonKey(name: "total_count")
  final int totalCount;
  final int count;

  Pagination(this.offset, this.totalCount, this.count);

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);

  @override
  String toString() {
    return 'Pagination{offset: $offset, totalCount: $totalCount, count: $count}';
  }
}

@JsonSerializable()
class User {
  @JsonKey(name: "avatar_url")
  final String avatarUrl;
  @JsonKey(name: "banner_url")
  final String bannerUrl;
  @JsonKey(name: "profile_url")
  final String profileUrl;
  final String username;
  @JsonKey(name: "display_name")
  final String displayName;

  User(this.avatarUrl, this.bannerUrl, this.profileUrl, this.username,
      this.displayName);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          avatarUrl == other.avatarUrl &&
          bannerUrl == other.bannerUrl &&
          profileUrl == other.profileUrl &&
          username == other.username &&
          displayName == other.displayName;

  @override
  int get hashCode =>
      avatarUrl.hashCode ^
      bannerUrl.hashCode ^
      profileUrl.hashCode ^
      username.hashCode ^
      displayName.hashCode;
}
