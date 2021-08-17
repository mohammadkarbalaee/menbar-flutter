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

  static List getAllCollections() {
    List collections = Hive.box('collections').get('list');
    return collections;
  }

  static List getAllOrators() {
    List orators = Hive.box('orators').get('list');
    return orators;
  }

  static Future<List> getCollectionsById(int id) async {
    List speeches = await Hive.box('collectionsOfOrators').get('$id');
    return speeches;
  }

  static bool isBookmarksEmpty(){
    return Hive.box('bookmarks').isEmpty;
  }

  static Future<List> getAllNewOnes() async {
    return await Hive.box('news').get('list');
  }

  static bool getIsBookmarked(id) {
    final box = Hive.box('bookmarks');
    bool isBookmarked = box.get(id) == null ? false : true;
    return isBookmarked;
  }

  static bool getIsDownloaded(String url) {
    final box = Hive.box('downloadeds');
    bool isDownloaded = box.get(url) == null ? false : true;
    return isDownloaded;
  }

  static double getProgress(url) {
    double progress = Hive.box('pauseds').get(url) == null ? 0 : Hive.box('pauseds').get(url);
    return progress;
  }

  static void putDownloaded(String url) {
    Hive.box('downloadeds').put(url, true);
  }

  static void putPaused(String url,double progress) {
    Hive.box('pauseds').put(url, progress);
  }

  static void deleteBookmard(id){
    final box = Hive.box('bookmarks');
    box.delete(id);
  }

  static bool getIsBookmarkedEmpty(){
    final box = Hive.box('bookmarks');
    return box.isEmpty;
  }

  static void putBookmarked(id,collection){
    final box = Hive.box('bookmarks');
    box.put(id,collection);
  }

  static List getSpeechesById(int id) {
    List speeches = Hive.box('speeches').get('${id}');
    return speeches;
  }

  static Future<Iterable> getBookmarkBoxValues() async{
    return Hive.box('bookmarks').values;
  }
}