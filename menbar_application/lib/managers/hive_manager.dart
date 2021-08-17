import 'dart:io';
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

  Future<void> saveDataInHive({oratorsList,collectionsList,newOnesList}) async {
    saveGeneralLists(
        oratorsList: oratorsList,
        collectionsList: collectionsList,
        newOnesList: newOnesList,
    );
  }

  Future<void> saveGeneralLists({oratorsList,collectionsList,newOnesList}) async => putDataInBoxes(oratorsList,collectionsList,newOnesList);

  Future<void> putDataInBoxes(List<dynamic> receivedOrators,List<dynamic> receivedCollections,List<dynamic> receivedNewOnes) async {

    final Box collectionsBox = Hive.box('collections');
    final Box newOnesBox = Hive.box('news');
    final Box oratorsBox = Hive.box('orators');

    oratorsBox.put('list',receivedOrators);
    collectionsBox.put('list',receivedCollections);
    newOnesBox.put('list',receivedNewOnes);
  }

  static Future<List> getAllCollections() async {
    List collections = await Hive.box('collections').get('list');
    return collections;
  }

  static Future<List> getAllOrators() async {
    List orators = await Hive.box('orators').get('list');
    return orators;
  }

  static Future<List> getCollectionsById(int id) async {
    List speeches = await Hive.box('collectionsOfOrators').get('$id');
    return speeches;
  }

  static bool isBookmarksEmpty(){
    return Hive.box('bookmarks').isEmpty;
  }
}