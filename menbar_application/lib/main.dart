import 'package:flutter/material.dart';
import 'package:menbar_application/managers/ApiManager.dart';
import 'firstpage/first_widget.dart';
import 'managers/HiveManager.dart';

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
    oratorsList: apiManager.getListData(
        urlForApiCall: apiCallUrls['getOrators']
    ),
    collectionsList: apiManager.getListData(
        urlForApiCall: apiCallUrls['getCollections']
    ),
    newOnesList: apiManager.getListData(
        urlForApiCall: apiCallUrls['getNewOnes']
    ),
    speechesOfCollections: apiManager.getSpeechesOfCollections(
        allCollectionsList: databaseManager.getAllCollections(),
    ),
    speechesOfOrators: apiManager.getSpeechesOfOrators(
      allOratorsList: databaseManager.getAllOrators(),
    ),
  );

  runApp(HomePage());
}