import 'package:flutter/material.dart';
import 'package:menbar_application/managers/api_manager.dart';
import 'firstpage/firstpage_widget.dart';
import 'managers/hive_manager.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var apiCallUrls = {
    'getNewOnes' : 'http://menbar.sobhe.ir/api/sokhanranis/?start=0&count=30',
    'getCollections' : 'http://menbar.sobhe.ir/api/collections/',
    'getOrators' : 'http://menbar.sobhe.ir/api/sokhanrans/',
  };

  final ApiManager apiManager = ApiManager();
  final HiveManager databaseManager = HiveManager();

  await databaseManager.initializeHiveDatabase();
  await databaseManager.makeHiveBoxes();

  databaseManager.saveDataInHive(
    oratorsList: await apiManager.getListData(
        urlForApiCall: apiCallUrls['getOrators']
    ),
    collectionsList: await apiManager.getListData(
        urlForApiCall: apiCallUrls['getCollections']
    ),
    newOnesList: await apiManager.getListData(
        urlForApiCall: apiCallUrls['getNewOnes']
    ),
  );

  apiManager.getAndSaveSpeechesOfCollections(
    allCollectionsList: await databaseManager.getAllCollections(),
  );

  apiManager.getAndSaveSpeechesOfOrators(
  allOratorsList: await databaseManager.getAllOrators(),
  );

  runApp(HomePage());
}