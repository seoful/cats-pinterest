import 'package:chopper/chopper.dart';

import '../model/giphy_objects.dart';

part 'gif_get_service.chopper.dart';

@ChopperApi(baseUrl: "/search")
abstract class GifGetService extends ChopperService {
  @Get(path: "")
  @FactoryConverter(request: RequestConverters.addCatToQuery)
  Future<Response<GiphyResponse>> getGifs(
      @Query("limit") responseLimit, @Query() offset, @Query() rating,
      [@Query("q") String query = ""]);

  @Get(path: "https://api.giphy.com/v1/gifs/random")
  Future<Response<GifBundle>> getRandomGif([@Query() tag = "cat"]);

  static GifGetService create([ChopperClient? client]) =>
      _$GifGetService(client);
}

class RequestConverters {
  static Future<Request> addCatToQuery(Request request) async {
    final String query = request.parameters["q"];
    if (!query.contains("cat")) request.parameters["q"] += " cat";
    return request;
  }
}
