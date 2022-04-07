import 'package:cats/model/collection_item.dart';
import 'package:cats/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouritesItem extends StatelessWidget {
  const FavouritesItem({Key? key, required this.collection}) : super(key: key);

  final CollectionItem collection;

  @override
  Widget build(BuildContext context) {
    final Widget noGifPlaceholder = SizedBox.expand(child:Container(
      color: MyColors.grey(130),
      // child: Icon(Icons.more_horiz_rounded),
    ),);

    final gifs = <Widget>[
      noGifPlaceholder,
      noGifPlaceholder,
      noGifPlaceholder,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 3.0 / 2.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 2, child: noGifPlaceholder),
                Container(width: 1,color: Colors.transparent,),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Flexible(flex:1,child: noGifPlaceholder),
                      Container(height: 1,color: Colors.transparent,),
                      Flexible(flex:1,child: noGifPlaceholder),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 15,),
              Text(collection.name,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),),
              SizedBox(height: 10,),
              Text(collection.gifBundles.length.toString() + " cats",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.white),),
            ],
          ),
        )
      ],
    );
  }
}
