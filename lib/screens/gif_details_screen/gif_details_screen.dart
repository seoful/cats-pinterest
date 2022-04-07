import 'dart:async';

import 'package:cats/blocs/recommendations_bloc/recommendations_bloc.dart';
import 'package:cats/components/animated_button.dart';
import 'package:cats/components/gif_tile.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/model/key_holder.dart';
import 'package:cats/repository/favourites_repository.dart';
import 'package:cats/routes/routes.dart';
import 'package:cats/routes/routes_settings/collection_choose_screen_settings.dart';
import 'package:cats/routes/routes_settings/gif_details_screen_settings.dart';
import 'package:cats/screens/gif_details_screen/appbar.dart';
import 'package:cats/utils/colors.dart';
import 'package:cats/utils/static_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:injector/injector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GifDetailsScreen extends StatefulWidget {
  GifDetailsScreen(GifDetailsScreenSettings settings)
      : gifBundle = settings.gifBundle,
        gifTag = settings.gifTag,
        keyHolder = settings.keyHolder,
        super(key: settings.key);

  final GifBundle gifBundle;

  final String gifTag;

  final KeyHolder<GifDetailsScreenState> keyHolder;

  @override
  State<GifDetailsScreen> createState() => GifDetailsScreenState();
}

class GifDetailsScreenState extends State<GifDetailsScreen> {
  late RecommendationsBloc _moreGifsBloc;

  final _scrollController = ScrollController();

  final GlobalKey _imageKey = GlobalKey();

  bool _appBarIsOverlaying = true;

  late String _imageTag;

  final _favouritesRepository =
      Injector.appInstance.get<FavouritesRepository>();

  late final StreamSubscription _favouritesSubscription;

  late bool _inFavourites;

  @override
  void initState() {
    _imageTag = widget.gifTag;

    _moreGifsBloc = RecommendationsBloc()..add(LoadRecommendations());
    _appBarIsOverlaying = true;
    // _overlay = OverlayEntry(builder: (context) => _buildOverlay(context));
    //
    // _scrollController.addListener(() {
    //   _overlay.markNeedsBuild();
    // });
    //
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   Overlay.of(context)!.insert(_overlay);
    // });

    _scrollController.addListener(() {
      final imageContext = _imageKey.currentContext;
      bool isOverlaying = true;
      if (imageContext != null) {
        final box = imageContext.findRenderObject() as RenderBox;
        isOverlaying = box.size.height - 40 > _scrollController.offset;
      }
      if (isOverlaying != _appBarIsOverlaying) {
        setState(() {
          _appBarIsOverlaying = isOverlaying;
        });
      }
    });

    _inFavourites = _favouritesRepository.find(widget.gifBundle.id).isNotEmpty;

    _favouritesSubscription = _favouritesRepository.stream.listen((value) {
      setState(() {
        _inFavourites =
            _favouritesRepository.find(widget.gifBundle.id).isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _favouritesSubscription.cancel();
    // _overlay.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScreen(context);
  }

  Widget _buildScreen(BuildContext context) {
    final gif = widget.gifBundle.sources.originalGif;
    return Material(
      child: Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: MyColors.grey(30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: _imageTag,
                              child: Image.network(
                                gif.url,
                                fit: BoxFit.fitWidth,
                                key: _imageKey,
                                loadingBuilder: (context, child, ___) =>
                                    AspectRatio(
                                  aspectRatio: gif.width / gif.height,
                                  child: SizedBox.expand(
                                    child: Container(
                                      color: Colors.grey,
                                      child: Stack(
                                        children: [
                                          const Center(
                                              child:
                                                  CupertinoActivityIndicator()),
                                          SizedBox.expand(child: child),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.gifBundle.normalizedTitle
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                  widget.gifBundle.user != null &&
                                          widget.gifBundle.username != null
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            AnimatedButton(
                                              onTap: () async => launch(widget
                                                  .gifBundle.user!.profileUrl),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Container(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 14),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child: Image.network(
                                                              widget
                                                                  .gifBundle
                                                                  .user!
                                                                  .avatarUrl),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        widget.gifBundle.user!
                                                            .displayName,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(
                                          width: 0,
                                          height: 0,
                                        ),
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.download_outlined,
                                        color: Colors.white,
                                      ),
                                      Row(
                                        children: [
                                          AnimatedButton(
                                            onTap: () async =>
                                                launch(widget.gifBundle.url),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                width: 110,
                                                height: 50,
                                                color: Colors.grey,
                                                child: const Center(
                                                    child: Text("To Site",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          AnimatedButton(
                                            onTap: () =>
                                                _manipulateFavourites(context),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              child: Container(
                                                width: 110,
                                                height: 50,
                                                color: _inFavourites
                                                    ? Colors.white
                                                    : Colors.red,
                                                child: Center(
                                                    child: Text(
                                                  _inFavourites
                                                      ? "Liked"
                                                      : "Like",
                                                  style: TextStyle(
                                                      color: _inFavourites
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      AnimatedButton(
                                        onTap: () => Share.share(gif.url),
                                        child: const Icon(
                                          Icons.ios_share,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: MyColors.grey(30),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "More",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              child: BlocBuilder<RecommendationsBloc,
                                  RecommendationBlocState>(
                                bloc: _moreGifsBloc,
                                builder: (context, state) {
                                  if (state is RecommendationsLoading) {
                                    return CupertinoActivityIndicator(
                                      color: MyColors.grey(200),
                                    );
                                  }
                                  if (state is RecommendationsLoaded) {
                                    return MasonryGridView.count(
                                      itemCount: state.gifs.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      itemBuilder: (context, index) {
                                        final gif = state.gifs[index];

                                        final key =
                                            GlobalKey<GifDetailsScreenState>();
                                        final keyHolder =
                                            widget.keyHolder.push(key);
                                        final tag = StaticMethods.compileTag(
                                            keyHolder, index, gif.id);

                                        final inFavourites = _favouritesRepository.find(gif.id).isNotEmpty;

                                        return GifTile(
                                          gif,
                                          heroTag: tag,
                                          onPressed: () =>
                                              Navigator.of(context).pushNamed(
                                            Routes.GIF_DETAILS_SCREEN,
                                            arguments: GifDetailsScreenSettings(
                                                gif, keyHolder, tag, key),
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
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: CustomAppBar(
                  buttonsInCircles: !_appBarIsOverlaying,
                  onBackPressed: () {
                    if (widget.keyHolder.mayPop) widget.keyHolder.pop();
                    Navigator.of(context).pop();
                  },
                  onClosePressed: () {
                    var keyHolder = widget.keyHolder;

                    if (keyHolder.previous != null) {
                      do {
                        keyHolder.key.currentState!.breakTag();
                        keyHolder = keyHolder.pop()!;
                      } while (keyHolder.mayPop);

                      keyHolder.key.currentState!.breakTag();
                    }

                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void breakTag() {
    setState(() {
      _imageTag = "broken" + widget.gifTag;
    });
  }

  void _manipulateFavourites(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.COLLECTION_CHOOSE_SCREEN,
        arguments: CollectionChooseScreenSettings(widget.gifBundle));
  }
}
