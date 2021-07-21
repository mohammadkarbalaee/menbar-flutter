import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Sets extends StatelessWidget {
  const Sets({Key? key}) : super(key: key);

  Future<List> _getCollections() async {
    String apiUrl = 'http://menbar.sobhe.ir/api/collections/';
    http.Response response = await http.get(Uri.parse(apiUrl));
    List result = json.decode(response.body);
    return result;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: _getCollections(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(
                child: Text(
                  '....در حال بارگیری مجموعه ها',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index) {
                    return GestureDetector(
                      child: Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                          child: Row(
                            children: [
                              Text(
                                  snapshot.data[index]['title']
                              ),
                              Image.network(snapshot.data[index]["image"],height: 100,),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          },
        )
      ),
    );
  }
}