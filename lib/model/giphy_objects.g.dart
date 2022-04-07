// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'giphy_objects.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiphyResponse _$GiphyResponseFromJson(Map<String, dynamic> json) =>
    GiphyResponse(
      (json['data'] as List<dynamic>)
          .map((e) => GifBundle.fromJson(e as Map<String, dynamic>))
          .toList(),
      Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GiphyResponseToJson(GiphyResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
    };

GifBundle _$GifBundleFromJson(Map<String, dynamic> json) => GifBundle(
      json['id'] as String,
      json['url'] as String,
      json['embed_url'] as String,
      json['username'] as String?,
      json['source'] as String?,
      json['rating'] as String?,
      json['create_datetime'] as String?,
      json['update_datetime'] as String?,
      json['title'] as String?,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      GifSources.fromJson(json['images'] as Map<String, dynamic>),
      GifBundle._datetimeFromString(json['addTime'] as String?),
    );

Map<String, dynamic> _$GifBundleToJson(GifBundle instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'embed_url': instance.embedUrl,
      'username': instance.username,
      'source': instance.source,
      'rating': instance.rating,
      'create_datetime': instance.createDatetime,
      'update_datetime': instance.updateDatetime,
      'title': instance.title,
      'user': instance.user,
      'images': instance.sources,
      'addTime': GifBundle._datetimeToString(instance.addTime),
    };

GifSources _$GifSourcesFromJson(Map<String, dynamic> json) => GifSources(
      Gif.fromJson(json['fixed_height'] as Map<String, dynamic>),
      Gif.fromJson(json['original'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GifSourcesToJson(GifSources instance) =>
    <String, dynamic>{
      'fixed_height': instance.fixedHeightGif,
      'original': instance.originalGif,
    };

Gif _$GifFromJson(Map<String, dynamic> json) => Gif(
      json['url'] as String,
      Gif._lengthFromJson(json['width'] as String),
      Gif._lengthFromJson(json['height'] as String),
    );

Map<String, dynamic> _$GifToJson(Gif instance) => <String, dynamic>{
      'url': instance.url,
      'width': Gif._lengthToJson(instance.width),
      'height': Gif._lengthToJson(instance.height),
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      json['offset'] as int,
      json['total_count'] as int,
      json['count'] as int,
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'total_count': instance.totalCount,
      'count': instance.count,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['avatar_url'] as String,
      json['banner_url'] as String,
      json['profile_url'] as String,
      json['username'] as String,
      json['display_name'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'avatar_url': instance.avatarUrl,
      'banner_url': instance.bannerUrl,
      'profile_url': instance.profileUrl,
      'username': instance.username,
      'display_name': instance.displayName,
    };
