import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ApiManager {

  Future<List<dynamic>> getListData({urlForApiCall,}) async {
    http.Response serverResponse = await http.get(Uri.parse(urlForApiCall));
    List receivedList = json.decode(utf8.decode(serverResponse.bodyBytes));
    return receivedList;
  }


  Future<void> getAndSaveSpeechesOfOrators({allOratorsList}) async {
    final speechesBox = Hive.box('collectionsOfOrators');
    for(var i in allOratorsList){
      String url = 'http://menbar.sobhe.ir/api/collections/?sokhanran=${i['id']}&start=0&count=500';
      http.Response severResponse = await http.get(Uri.parse(url));
      List speeches = json.decode(utf8.decode(severResponse.bodyBytes));
      speechesBox.put('${i['id']}',speeches);
    }
  }

  Future<void> getAndSaveSpeechesOfCollections({allCollectionsList}) async {
    final speechesBox = Hive.box('speeches');
    for(var i in allCollectionsList){
      String url = 'http://menbar.sobhe.ir/api/sokhanranis/?collection=${i['id']}&start=0&count=500';
      http.Response serverResponse = await http.get(Uri.parse(url));
      List speeches = json.decode(utf8.decode(serverResponse.bodyBytes));
      speechesBox.put('${i['id']}',speeches);
    }
  }
}