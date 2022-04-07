
import 'package:cats/screens/favourites_screen/favourites_screen.dart';
import 'package:cats/screens/home_screen/bottom_bar.dart';
import 'package:cats/screens/search_screen/search_screen.dart';
import 'package:cats/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PageController _pageController = PageController(initialPage: 0);

  final _searchKey = GlobalKey<SearchScreenState>();

  final _favouritesKey = GlobalKey<FavouritesScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.grey(15),
      child: Stack(
        children: [
          SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SearchScreen(),
                FavouritesScreen(),
              ],
            )
          ),
          BottomBar(
            icons: const [
              Icons.auto_awesome_mosaic,
              Icons.favorite_border_rounded
            ],
            onTap: (previousIndex, newIndex) {
              if (previousIndex == newIndex) {
                if(newIndex == 0) {
                  _searchKey.currentState!.scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOutQuad);
                }
                else if(newIndex == 1){
                  _favouritesKey.currentState!.scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.easeOutQuad);
                }
              } else {
                _pageController.jumpToPage(newIndex);
              }
            },
            color: MyColors.grey(10),
            borderRadius: 20,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
