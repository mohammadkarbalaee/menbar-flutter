import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CollectionInstance.dart';

class Collections extends StatelessWidget {

  List orators;
  Collections(this.orators);

  Future<List> _getData() async {
    List result = [];

    String apiUrl = 'http://menbar.sobhe.ir/api/collections/';
    http.Response collectionsResponse = await http.get(Uri.parse(apiUrl));
    List collections = json.decode(utf8.decode(collectionsResponse.bodyBytes));
    return collections;
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

        body: FutureBuilder(

          future: _getData(),

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
            }
            else {

              return GridView.builder(

                  itemCount: snapshot.data.length,

                  itemBuilder: (context,index) {

                    return GestureDetector(

                      child: Container(

                        child: Card(

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 10,
                          child: Stack(

                            children: [
                              Image.network(snapshot.data[index]['image']),
                              Padding(
                                  padding: EdgeInsets.only(top: 130),
                                  child: Column(

                                    children: [
                                      Text(
                                        snapshot.data[index]['title'],
                                        style: TextStyle(
                                          backgroundColor: Colors.yellowAccent,
                                        ),
                                      ),// title of the speech
                                      Text(
                                          getName(snapshot.data[index]["sokhanran"])
                                      )//orator title
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CollectionInstance(snapshot.data[index]['image'])
                        )
                        );
                      },
                    );
                  }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              );
            }
          },
        )
      ),
    );
  }

  String getName(String oratorUrl) {

    List splited = oratorUrl.split("/");
    String  oratorID = splited[splited.length - 2];
    String oratorName = findNameByID(oratorID);

    return oratorName;
  }

  String findNameByID(String oratorID) {

    String name = 'failed to find';

    for(var orator in orators){
      if(orator['id'].toString() == oratorID){
        name = orator['title'];
      }
    }

    return name;
  }
}