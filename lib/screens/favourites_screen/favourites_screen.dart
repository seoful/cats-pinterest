import 'package:cats/blocs/favourites_bloc/favourites_bloc.dart';
import 'package:cats/components/scrollable_up.dart';
import 'package:cats/model/collection_item.dart';
import 'package:cats/screens/favourites_screen/favourites_item.dart';
import 'package:cats/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FavouritesScreen extends StatefulWidget {
  FavouritesScreen({Key? key}) : super(key: key);

  @override
  State<FavouritesScreen> createState() => FavouritesScreenState();
}

class FavouritesScreenState extends State<FavouritesScreen> {
  final scrollController = ScrollController();

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
                child: BlocBuilder<FavouritesBloc, FavouritesState>(
                  buildWhen: (previous, current) =>
                      current is FavouritesUpdated || current is FavouritesNotInitialized,
                  builder: (context, state) {
                    if (state is FavouritesNotInitialized) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    if (state is FavouritesUpdated) {
                      return _buildList(state.collections);
                    }
                    return Container();
                  },
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

  Widget _buildList(List<CollectionItem> collections) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: collections.map((e) => FavouritesItem(collection: e)).toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
