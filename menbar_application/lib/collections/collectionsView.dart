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
                  '',
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
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 10,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Image.network(snapshot.data[index]['image']),
                              Positioned(
                                  child: PhysicalModel(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.black26,
                                    elevation: 30,
                                    child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                        height: 50,
                                        width: 1000,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  snapshot.data[index]['title'],
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ), // title of the speech
                                                SizedBox(width: 15,),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  getName(snapshot.data[index]["sokhanran"]),
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 15,),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
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