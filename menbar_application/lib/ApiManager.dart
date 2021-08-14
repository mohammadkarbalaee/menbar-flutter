import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiManager {

  Future<List<dynamic>> getListData({urlForApiCall,}) async {
    http.Response serverResponse = await http.get(Uri.parse(urlForApiCall));
    List receivedList = json.decode(utf8.decode(serverResponse.bodyBytes));
    return receivedList;
  }

  Future<List> getSpeechesOfOrators({allOratorsList}) async {
    List result = [];
    String url;

    for(var i in allOratorsList){
      url = 'http://menbar.sobhe.ir/api/collections/?sokhanran=${i['id']}&start=0&count=500';
      http.Response severResponse = await http.get(Uri.parse(url));
      List speeches = json.decode(utf8.decode(severResponse.bodyBytes));
      result.add(speeches);
    }

    return result;
  }

  Future<List> getSpeechesOfCollections({allCollectionsList}) async {
    List result = [];
    String url;

    for(var i in allCollectionsList){
      url = 'http://menbar.sobhe.ir/api/sokhanranis/?collection=${i['id']}&start=0&count=500';
      http.Response serverResponse = await http.get(Uri.parse(url));
      List speeches = json.decode(utf8.decode(serverResponse.bodyBytes));
      result.add(speeches);
    }

    return result;
  }
}