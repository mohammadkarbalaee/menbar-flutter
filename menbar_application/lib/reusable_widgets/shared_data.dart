
import 'package:flutter/material.dart';

import '../managers/hive_manager.dart';

class SharedData{
  static ValueNotifier<bool> isBookmarksEmpty = ValueNotifier<bool>(HiveManager.isBookmarksEmpty());
  static final mainColor = 0xff607d8d;
  static bool isPlaying = false;
}
