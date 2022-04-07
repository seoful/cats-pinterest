import 'dart:io';

import 'package:cats/blocs/favourites_bloc/favourites_bloc.dart';
import 'package:cats/blocs/search_bloc/search_bloc.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/network/gif_get_service.dart';
import 'package:cats/network/json_serializable_converter.dart';
import 'package:cats/repository/favourites_repository.dart';
import 'package:cats/routes/routes.dart';
import 'package:cats/routes/routes_settings/collection_choose_screen_settings.dart';
import 'package:cats/routes/routes_settings/gif_details_screen_settings.dart';
import 'package:cats/screens/collection_choose_screen/collection_choose_screen.dart';
import 'package:cats/screens/gif_details_screen/gif_details_screen.dart';
import 'package:cats/screens/home_screen/home_screen.dart';
import 'package:cats/utils/consts.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:injector/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final injector = Injector.appInstance;

  final chopperClient = ChopperClient(
      baseUrl: "https://api.giphy.com/v1/gifs",
      services: [GifGetService.create()],
      interceptors: [
        (Request request) async {
          request.parameters
              .addEntries([const MapEntry("api_key", Constants.apiKey)]);
          return request;
        }
      ],
      converter: JsonSerializableConverter(const {
        GiphyResponse: GiphyResponse.fromJson,
        GifBundle: GifBundle.fromJson
      }));
  injector.registerSingleton<ChopperClient>(() => chopperClient);

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  final favouritesRepository = FavouritesRepository();

  final favouritesBloc = FavouritesBloc();

  final searchBloc = SearchBloc();

  injector.registerSingleton<FavouritesRepository>(() => favouritesRepository);
  injector.registerSingleton<FavouritesBloc>(() => favouritesBloc);
  injector.registerSingleton<SearchBloc>(() => searchBloc);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: Injector.appInstance.get<FavouritesBloc>()),
        BlocProvider.value(value: Injector.appInstance.get<SearchBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:
            ThemeData(primarySwatch: Colors.blue, fontFamily: "HelveticaNeue"),
        initialRoute: Routes.HOME_SCREEN,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.HOME_SCREEN:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case Routes.GIF_DETAILS_SCREEN:
        return CupertinoPageRoute(
          builder: (context) =>
              GifDetailsScreen(settings.arguments as GifDetailsScreenSettings),
        );
      case Routes.COLLECTION_CHOOSE_SCREEN:
        return MaterialPageRoute(
          builder: (context) => CollectionChooseScreen(
              settings.arguments as CollectionChooseScreenSettings),
        );
    }
    return null;
  }
}
