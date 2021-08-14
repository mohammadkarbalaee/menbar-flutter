import 'package:flutter/material.dart';
import 'package:menbar_application/ApiManager.dart';
import 'package:menbar_application/HiveManager.dart';
import 'firstpage/first_widget.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ApiManager apiManager = ApiManager();
  final HiveManager databaseManager = HiveManager();

  await databaseManager.initializeHiveDatabase();
  await databaseManager.makeHiveBoxes();
  databaseManager.saveDataInHive();

  runApp(HomePage());
}