import 'package:cats/model/key_holder.dart';

class StaticMethods{
  static String compileTag(KeyHolder keyHolder, int index, String tag){
    return keyHolder.hashCode.toString() + "/" + index.toString()  + "/"+  tag;
  }
}