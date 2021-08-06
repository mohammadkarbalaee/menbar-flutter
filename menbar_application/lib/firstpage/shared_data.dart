import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
class Shared{
  static ValueNotifier<bool> isBookmarksEmpty = ValueNotifier<bool>(Hive.box('bookmarks').isEmpty);
}
