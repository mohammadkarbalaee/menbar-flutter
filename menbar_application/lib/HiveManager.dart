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

  Future<void> saveDataInHive({oratorsList,collectionsList,newOnesList,speechesOfCollections,speechesOfOrators}) async {

    saveSpeechesOfCollections(
      speechesOfCollections: speechesOfCollections
    );

    saveSpeechesOfOrators(
      speechesOfOrators: speechesOfOrators
    );

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


  void saveSpeechesOfOrators({speechesOfOrators}) async {
    final speechesBox = Hive.box('collectionsOfOrators');
    List orators = getAllCollections();

    for(var i = 0;i < speechesOfOrators.length; i++){
      speechesBox.put('${orators[i]['id']}',speechesOfOrators[i]);
    }
  }

  void saveSpeechesOfCollections({speechesOfCollections}){
    final speechesBox = Hive.box('speeches');
    List collections = getAllCollections();

    for(var i = 0;i < speechesOfCollections.length; i++){
      speechesBox.put('${collections[i]['id']}',speechesOfCollections[i]);
    }
  }

  getAllCollections() async {
    List collections = await Hive.box('orators').get('list');
    return collections;
  }

  getAllOrators() async {
    List orators = await Hive.box('orators').get('list');
    return orators;
  }
}