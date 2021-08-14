import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {

  Future<void> initializeHiveDatabase() async {
    Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
    String appDocumentPath = appDocumentDirectory.path;
    Hive.init(appDocumentPath);
  }

  Future<void> makeHiveBoxes() async {
    await Hive.openBox('orators');
    await Hive.openBox('collections');
    await Hive.openBox('news');
    await Hive.openBox('speeches');
    await Hive.openBox('collectionsOfOrators');
    await Hive.openBox('bookmarks');
    await Hive.openBox('downloadeds');
    await Hive.openBox('pauseds');
  }

  void saveDataInHive() {
    saveSpeechesOfCollections();
    saveSpeechesOfOrators();
    saveGeneralLists();
  }


  Future<void> saveGeneralLists() async => putDataInBoxes(await getOrators(),await getCollections(),await getNewOnes());

  Future<void> putDataInBoxes(List<dynamic> receivedOrators,List<dynamic> receivedCollections,List<dynamic> receivedNewOnes) async {

    final Box collectionsBox = Hive.box('collections');
    final Box newOnesBox = Hive.box('news');
    final Box oratorsBox = Hive.box('orators');

    oratorsBox.put('list',receivedOrators);
    collectionsBox.put('list',receivedCollections);
    newOnesBox.put('list',receivedNewOnes);
  }

  Future<List<dynamic>> getNewOnes() async {

    String newsOnesApiUrl = 'http://menbar.sobhe.ir/api/sokhanranis/?start=0&count=30';
    http.Response serverResponse = await http.get(Uri.parse(newsOnesApiUrl));
    List newOnesList = json.decode(utf8.decode(serverResponse.bodyBytes));

    return newOnesList;

  }

  Future<List<dynamic>> getCollections() async {
    String collectionsApiUrl = 'http://menbar.sobhe.ir/api/collections/';
    http.Response collectionsResponse = await http.get(Uri.parse(collectionsApiUrl));
    List collectionsServer = json.decode(utf8.decode(collectionsResponse.bodyBytes));
    return collectionsServer;
  }

  Future<List<dynamic>> getOrators() async {
    String oratorsApiUrl = 'http://menbar.sobhe.ir/api/sokhanrans/';
    http.Response oratorsResponse = await http.get(Uri.parse(oratorsApiUrl));
    List oratorsServer = json.decode(utf8.decode(oratorsResponse.bodyBytes));
    return oratorsServer;
  }

  void saveSpeechesOfOrators() async {
    final speechesBox = Hive.box('collectionsOfOrators');
    List orators = await Hive.box('orators').get('list');

    for(var i in orators){
      String url = 'http://menbar.sobhe.ir/api/collections/?sokhanran=${i['id']}&start=0&count=500';
      http.Response newsResponse = await http.get(Uri.parse(url));
      List speeches = json.decode(utf8.decode(newsResponse.bodyBytes));
      speechesBox.put('${i['id']}',speeches);
    }
  }

  void saveSpeechesOfCollections() async {
    final speechesBox = Hive.box('speeches');
    List collections = await Hive.box('collections').get('list');

    for(var i in collections){
      String url = 'http://menbar.sobhe.ir/api/sokhanranis/?collection=${i['id']}&start=0&count=500';
      http.Response newsResponse = await http.get(Uri.parse(url));
      List speeches = json.decode(utf8.decode(newsResponse.bodyBytes));
      speechesBox.put('${i['id']}',speeches);
    }
  }
}