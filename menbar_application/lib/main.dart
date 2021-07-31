import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'firstpage/first_page.dart';

main() async {
  //make sure all are initialized
  WidgetsFlutterBinding.ensureInitialized();
  //initializing Database
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  Hive.init(appDocPath);
  //making the needed boxes
  await Hive.openBox('orators');
  await Hive.openBox('collections');
  await Hive.openBox('news');
  //getting the made boxes
  final oratorsBox = Hive.box('orators');
  final collectionsBox = Hive.box('collections');
  //getting data from server
  String oratorsApiUrl = 'http://menbar.sobhe.ir/api/sokhanrans/';
  http.Response oratorsResponse = await http.get(Uri.parse(oratorsApiUrl));
  List oratorsServer = json.decode(utf8.decode(oratorsResponse.bodyBytes));
  String apiUrl = 'http://menbar.sobhe.ir/api/collections/';
  http.Response collectionsResponse = await http.get(Uri.parse(apiUrl));
  List collectionsServer = json.decode(utf8.decode(collectionsResponse.bodyBytes));
  //saving data in DB
  oratorsBox.put('orators',oratorsServer);
  collectionsBox.put('collections',collectionsServer);
  //retrieving data from DB
  List orators = await oratorsBox.get('orators');
  List collections = await collectionsBox.get('collections');

  runApp(
      FirstActivity(orators,collections)
  );
}