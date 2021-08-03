import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'firstpage/first_widget.dart';

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
  await Hive.openBox('speeches');
  await Hive.openBox('collectionsOfOrators');
//getting the made boxes
  final oratorsBox = Hive.box('orators');
  final collectionsBox = Hive.box('collections');
  final newsBox = Hive.box('news');
//getting data from server
  String oratorsApiUrl = 'http://menbar.sobhe.ir/api/sokhanrans/';
  http.Response oratorsResponse = await http.get(Uri.parse(oratorsApiUrl));
  List oratorsServer = json.decode(utf8.decode(oratorsResponse.bodyBytes));

  String collectionsApiUrl = 'http://menbar.sobhe.ir/api/collections/';
  http.Response collectionsResponse = await http.get(Uri.parse(collectionsApiUrl));
  List collectionsServer = json.decode(utf8.decode(collectionsResponse.bodyBytes));

  String newsApiUrl = 'http://menbar.sobhe.ir/api/sokhanranis/?start=0&count=100';
  http.Response newsResponse = await http.get(Uri.parse(newsApiUrl));
  List newsServer = json.decode(utf8.decode(newsResponse.bodyBytes));

  getSpeechesOfCollections();
  getSpeechesOfOrators();

//saving data in DB
  oratorsBox.put('list',oratorsServer);
  collectionsBox.put('list',collectionsServer);
  newsBox.put('list',newsServer);
//retrieving data from DB

  runApp(
      HomePage(),
  );
}

void getSpeechesOfOrators() async {
  final speechesBox = Hive.box('collectionsOfOrators');
  List orators = await Hive.box('orators').get('list');

  for(var i in orators){
    String url = 'http://menbar.sobhe.ir/api/collections/?sokhanran=${i['id']}&start=0&count=500';
    http.Response newsResponse = await http.get(Uri.parse(url));
    List speeches = json.decode(utf8.decode(newsResponse.bodyBytes));
    speechesBox.put('${i['id']}',speeches);
  }
}

void getSpeechesOfCollections() async {
  final speechesBox = Hive.box('speeches');
  List collections = await Hive.box('collections').get('list');

  for(var i in collections){
    String url = 'http://menbar.sobhe.ir/api/sokhanranis/?collection=${i['id']}&start=0&count=500';
    http.Response newsResponse = await http.get(Uri.parse(url));
    List speeches = json.decode(utf8.decode(newsResponse.bodyBytes));
    speechesBox.put('${i['id']}',speeches);
  }
}

