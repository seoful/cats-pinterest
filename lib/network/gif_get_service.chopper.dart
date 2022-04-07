// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gif_get_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$GifGetService extends GifGetService {
  _$GifGetService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = GifGetService;

  @override
  Future<Response<GiphyResponse>> getGifs(
      dynamic responseLimit, dynamic offset, dynamic rating,
      [String query = ""]) {
    final $url = '/search';
    final $params = <String, dynamic>{
      'limit': responseLimit,
      'offset': offset,
      'rating': rating,
      'q': query
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<GiphyResponse, GiphyResponse>($request,
        requestConverter: RequestConverters.addCatToQuery);
  }

  @override
  Future<Response<GifBundle>> getRandomGif([dynamic tag = "cat"]) {
    final $url = 'https://api.giphy.com/v1/gifs/random';
    final $params = <String, dynamic>{'tag': tag};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<GifBundle, GifBundle>($request);
  }
}
