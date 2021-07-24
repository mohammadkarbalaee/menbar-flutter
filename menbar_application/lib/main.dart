import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'firstpage/First.dart';

main() async{

  String oratorsApiUrl = 'http://menbar.sobhe.ir/api/sokhanrans/';
  http.Response oratorsResponse = await http.get(Uri.parse(oratorsApiUrl));
  List orators = json.decode(oratorsResponse.body);

  runApp(
      FirstActivity(orators)
  );
}