import 'package:cats/blocs/search_bloc/search_bloc.dart';
import 'package:cats/components/gif_tile.dart';
import 'package:cats/components/scrollable_up.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/model/key_holder.dart';
import 'package:cats/repository/favourites_repository.dart';
import 'package:cats/routes/routes.dart';
import 'package:cats/routes/routes_settings/gif_details_screen_settings.dart';
import 'package:cats/screens/gif_details_screen/gif_details_screen.dart';
import 'package:cats/utils/colors.dart';
import 'package:cats/utils/static_methods.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:injector/injector.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {
  final _gifDetailsKey = GlobalKey<GifDetailsScreenState>();

  late final TextEditingController _textController;

  final _searchBloc = Injector.appInstance.get<SearchBloc>();

  final _scrollOffset = 500;

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    scrollController.addListener(_onScroll);
    context.read<SearchBloc>().add(SearchMoreGifs());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SingleChildScrollView(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: MyColors.grey(30),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoSearchTextField(
                      controller: _textController,
                      onSuffixTap: () {
                        _textController.clear();
                        _onQueryChanged("");
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      onChanged: _onQueryChanged,
                      onSubmitted: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      style: TextStyle(color: MyColors.grey(200)),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<SearchBloc, SearchBlocState>(
                      builder: (context, state) {
                        if (state is SearchFirstPageLoading) {
                          return Center(
                              child: CupertinoActivityIndicator(
                            color: MyColors.grey(200),
                          ));
                        }
                        if (state is SearchLoadedNothing) {
                          return _buildEmptyList(context);
                        }
                        if (state is SearchLoaded) {
                          return _buildList(context, state.gifs);
                        }
                        if (state is SearchLoadingNextPage) {
                          return _buildList(context, state.gifs);
                        }
                        if (state is SearchLoadedToEnd) {
                          return _buildList(context, state.gifs);
                        }
                        if (state is SearchFirstPageLoadingFail) {
                          return _buildErrorScreen(context);
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<GifBundle> gifs) {
    return Flexible(
      child: MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: gifs.length,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final gifBundle = gifs.elementAt(index);
          final keyHolder = KeyHolder<GifDetailsScreenState>(_gifDetailsKey);
          final tag = StaticMethods.compileTag(keyHolder, index, gifBundle.id);
          final inFavourites = Injector.appInstance
              .get<FavouritesRepository>()
              .find(gifBundle.id)
              .isNotEmpty;
          return GifTile(
            gifBundle,
            heroTag: tag,
            onPressed: () => Navigator.of(context).pushNamed(
              Routes.GIF_DETAILS_SCREEN,
              arguments: GifDetailsScreenSettings(
                  gifBundle, keyHolder, tag, _gifDetailsKey),
            ),
            popUpActions: [
              CupertinoContextMenuAction(
                  child: const Text(
                    "Like",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  trailingIcon: inFavourites
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded),
              const CupertinoContextMenuAction(
                  child: Text(
                    "Save",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  trailingIcon: Icons.download_outlined),
              const CupertinoContextMenuAction(
                  child: Text(
                    "Share",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                  trailingIcon: Icons.ios_share),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorScreen(BuildContext context) {
    return const Center(child: Text("Error"));
  }

  Widget _buildEmptyList(BuildContext context) {
    return const Center(child: Text("Nothing Found"));
  }

  void _onScroll() {
    if (_searchBloc.state is SearchLoaded) {
      if (scrollController.position.maxScrollExtent -
              scrollController.position.pixels <=
          _scrollOffset) {
        _searchBloc.add(SearchMoreGifs(_textController.value.text));
      }
    }
  }

  void _onQueryChanged(String query) {
    EasyDebounce.debounce("new_query", const Duration(milliseconds: 400), () {
      _searchBloc.add(SearchMoreGifs(query));
    });
  }

  @override
  bool get wantKeepAlive => true;


}
