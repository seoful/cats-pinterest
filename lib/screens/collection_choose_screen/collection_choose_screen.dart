import 'package:cats/blocs/collection_chooser_bloc/collection_choose_bloc.dart';
import 'package:cats/blocs/favourites_bloc/favourites_bloc.dart';
import 'package:cats/components/animated_button.dart';
import 'package:cats/model/collection_item.dart';
import 'package:cats/model/giphy_objects.dart';
import 'package:cats/routes/routes_settings/collection_choose_screen_settings.dart';
import 'package:cats/screens/collection_choose_screen/collection_choose_list_item.dart';
import 'package:cats/screens/collection_choose_screen/create_collection_dialog.dart';
import 'package:cats/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CollectionChooseScreen extends StatefulWidget {
  CollectionChooseScreen(CollectionChooseScreenSettings settings, {Key? key})
      : gif = settings.gifBundle,
        super(key: key);

  final GifBundle gif;

  @override
  State<CollectionChooseScreen> createState() => _CollectionChooseScreenState();
}

class _CollectionChooseScreenState extends State<CollectionChooseScreen> {
  late CollectionChooseBloc bloc;

  @override
  void initState() {
    bloc = CollectionChooseBloc(widget.gif);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.grey(30),
      child: SafeArea(
        child: Stack(
          children: [
            BlocProvider<CollectionChooseBloc>.value(
              value: bloc,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add,
                          color: Colors.transparent,
                        ),
                        const Text(
                          "Choose collection",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        AnimatedButton(
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                        color: MyColors.grey(130), height: 0, thickness: 0.5),
                    BlocBuilder<FavouritesBloc, FavouritesState>(
                      builder: (context, state) {
                        if (state is FavouritesNotInitialized) {
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        return BlocBuilder<CollectionChooseBloc,
                            CollectionChooseState>(
                          builder: (context, state) {
                            if (state is CollectionChooseListUpdate) {
                              return ListView(
                                physics: const BouncingScrollPhysics(),
                                children:
                                    _createList(state.collections, context),
                                shrinkWrap: true,
                              );
                            }
                            return Container();
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: AnimatedButton(
                onTap: () => Navigator.pop(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 50,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _createList(
      List<CollectionChooseItem> collections, BuildContext context) {
    final list = <Widget>[];
    list.addAll(collections.map((e) => CollectionChooseListItem(
          item: e,
          onPressed: () {
            if (e.gifCollectionStatus == GifCollectionStatus.notIncluded) {
              bloc.add(AddToCollection(e.name));
            }
            if (e.gifCollectionStatus == GifCollectionStatus.included) {
              bloc.add(RemoveFromCollection(e.name));
            }
          },
        )));

    list.add(AnimatedButton(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => CreateCollectionDialog(),
            barrierDismissible: false);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
              child: const Center(
                child: Icon(
                  Icons.add_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "Create New Collection",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    ));

    return list;
  }
}
