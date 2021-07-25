import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:menbar_application/newspeeches/NewSpeechInstance.dart';
import 'dart:convert';

class NewSpeeches extends StatelessWidget {

  List orators;
  List collections;
  NewSpeeches(this.orators,this.collections);

  Future<List> _getData() async {

    String apiUrl = 'http://menbar.sobhe.ir/api/sokhanranis/';
    http.Response collectionsResponse = await http.get(Uri.parse(apiUrl));
    List news = json.decode(utf8.decode(collectionsResponse.bodyBytes));
    return news;
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

                return ListView.builder(

                  itemCount: snapshot.data.length,

                  itemBuilder: (context,index) {

                    return GestureDetector(

                      child: Container(

                        child: Card(

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                  child:Container(
                                    height: 100,
                                    width: 500,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          snapshot.data[index]['title'],
                                          textAlign: TextAlign.end,
                                        ),
                                        Text(
                                          getName(snapshot.data[index]['sokhanran']),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          snapshot.data[index]["performed_at"],
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    ),
                                  ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 120,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Image.network(getImage(snapshot.data[index]['collection'])),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => NewSpeechInstance(getImage(snapshot.data[index]['collection']))
                        )
                        );
                      },
                    );
                  },
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

  String getImage(speechUrl) {
    List splited = speechUrl.split("/");
    String  collectionID = splited[splited.length - 2];
    String collectionImage = findImageByID(collectionID);

    return collectionImage;
  }

  String findImageByID(String collectionID) {
    String image = 'failed to find';

    for(var collection in collections){
      if(collection['id'].toString() == collectionID){
        image = collection['image'];
      }
    }

    return image;
  }
}