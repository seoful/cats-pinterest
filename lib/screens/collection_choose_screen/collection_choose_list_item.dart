import 'package:cats/components/animated_button.dart';
import 'package:cats/model/collection_item.dart';
import 'package:cats/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CollectionChooseListItem extends StatelessWidget {
  final CollectionChooseItem item;

  final Function() onPressed;

  const CollectionChooseListItem(
      {Key? key, required this.item, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final previewImage = item.collectionGif != null
        ? Image.network(
            item.collectionGif!.url,
            fit: item.collectionGif!.width > item.collectionGif!.height
                ? BoxFit.fitHeight
                : BoxFit.fitWidth,
            loadingBuilder: (_, child, ___) => Center(
                child: Stack(
              children: [
                const Center(child:  CupertinoActivityIndicator()),
                SizedBox.expand(child: child),
              ],
            )),
          )
        : const Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
          );

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: MyColors.grey(130), width: 0.5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 45,
                  width: 45,
                  color: MyColors.grey(130),
                  child: previewImage,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                item.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
            ],
          ),
          _createButton(),
        ],
      ),
    );
  }

  Widget _createButton() {
    final color = item.gifCollectionStatus == GifCollectionStatus.notIncluded
        ? Colors.red
        : MyColors.grey(130);
    Widget child;
    switch (item.gifCollectionStatus) {
      case GifCollectionStatus.included:
        child = const Text(
          "Remove",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
        );
        break;
      case GifCollectionStatus.notIncluded:
        child = const Text(
          "Add",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
        );
        break;
      case GifCollectionStatus.inProgress:
        child = const CupertinoActivityIndicator();
        break;
    }

    return AnimatedButton(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 35,
          color: color,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
