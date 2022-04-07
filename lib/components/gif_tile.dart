import 'package:cats/model/giphy_objects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GifTile extends StatefulWidget {
  const GifTile(this.gifBundle,
      {Key? key,
      required this.onPressed,
      required this.heroTag,
      this.popUpActions})
      : assert(onPressed != null),
        super(key: key);

  final GifBundle gifBundle;

  final String heroTag;

  final Function()? onPressed;

  final List<CupertinoContextMenuAction>? popUpActions;

  @override
  State<GifTile> createState() => _GifTileState();
}

class _GifTileState extends State<GifTile> {
  @override
  void initState() {
    // precacheImage(NetworkImage(widget.gifBundle.sources.originalGif.url), context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Gif gif = widget.gifBundle.sources.originalGif;

    return Builder(builder: (context) {
      return CupertinoContextMenu(
        previewBuilder: (context, animation, child) => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(gif.url),
        ),
        actions: widget.popUpActions ?? [],
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Hero(
            tag: widget.heroTag,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                gif.url,
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingInfo) => AspectRatio(
                  aspectRatio: gif.width / gif.height,
                  child: Container(
                    color: Colors.grey,
                    child: Stack(
                      children: [
                        const Center(child: CupertinoActivityIndicator()),
                        SizedBox.expand(child: child)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
