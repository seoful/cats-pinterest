import 'package:cats/model/giphy_objects.dart';
import 'package:cats/model/key_holder.dart';
import 'package:cats/screens/gif_details_screen/gif_details_screen.dart';
import 'package:flutter/material.dart';

class GifDetailsScreenSettings {
  final GifBundle gifBundle;
  final KeyHolder<GifDetailsScreenState> keyHolder;
  final String gifTag;

  final Key key;


  GifDetailsScreenSettings(this.gifBundle, this.keyHolder, this.gifTag, this.key);
}