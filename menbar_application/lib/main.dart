import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'firstpage/FirstPage.dart';

main() async{

  String oratorsApiUrl = 'http://menbar.sobhe.ir/api/sokhanrans/';
  http.Response oratorsResponse = await http.get(Uri.parse(oratorsApiUrl));
  List orators = json.decode(utf8.decode(oratorsResponse.bodyBytes));

  String apiUrl = 'http://menbar.sobhe.ir/api/collections/';
  http.Response collectionsResponse = await http.get(Uri.parse(apiUrl));
  List collections = json.decode(utf8.decode(collectionsResponse.bodyBytes));

  runApp(
      FirstActivity(orators,collections)
  );
}