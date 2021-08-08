import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menbar_application/collections/collection_speeches_widget.dart';


import  'package:persian_number_utility/persian_number_utility.dart';

import 'new_speech_instance_widget.dart';


class NewSpeeches extends StatelessWidget {

  List orators;
  List collections;
  NewSpeeches(this.orators,this.collections);

  Future<List> _getData() async {
    List news = await Hive.box('news').get('list');
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100,),
                                  Text(
                                    getDateTime(snapshot.data[index]["performed_at"]).toPersianDateStr(showDayStr: true),
                                    style: TextStyle(
                                      fontFamily: 'sans',
                                      fontSize: 17
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        snapshot.data[index]['title'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'sans',
                                        ),
                                      ),
                                      Text(
                                        getName(snapshot.data[index]['sokhanran']),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'sans',
                                        ),
                                      ),
                                    ],
                                  ),
                              ),
                              SizedBox(width: 20),
                              Container(
                                height: 120,
                                child: CachedNetworkImage(
                                    imageUrl: getImage(snapshot.data[index]['collection']),
                                  fadeInDuration:Duration(milliseconds: 500),
                                  fadeInCurve:Curves.easeInExpo,
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                            builder: (context) => CollectionInstance(
                                getImage(snapshot.data[index]['collection']),
                                getTitle(snapshot.data[index]['collection']),
                                getID(snapshot.data[index]['collection']),
                                getIsSequenced(snapshot.data[index]['collection']),
                                getName(snapshot.data[index]['sokhanran']),
                                getUrl(snapshot.data[index]['collection']),
                                getDonwloads(snapshot.data[index]['collection']),
                            )
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

    String oratorID = getID(oratorUrl);
    String oratorName = findNameByID(oratorID);

    return oratorName;
  }

  String getID(String url) {
    List splited = url.split("/");
    String  oratorID = splited[splited.length - 2];
    return oratorID;
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
    String  collectionID = getID(speechUrl);
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

  DateTime getDateTime(String date) {
    List splited = date.split('-');
    var year = int.parse(splited[0]);
    var month = int.parse(splited[1]);
    var day = int.parse(splited[2]);
    DateTime result = DateTime(year,month,day);
    return result;
  }

  String getTitle(collection) {
    String id = getID(collection);

    String title = 'failed to find';

    for(var collection in collections){
      if(collection['id'].toString() == id){
        title = collection['title'];
      }
    }

    return title;

  }

  bool getIsSequenced(collection) {
    String id = getID(collection);

    bool sequence = false;

    for(var collection in collections){
      if(collection['id'].toString() == id){
        sequence = collection['is_sequence'];
      }
    }

    return sequence;
  }

  String getUrl(collection) {
    String id = getID(collection);

    String url = 'failed to find';

    for(var collection in collections){
      if(collection['id'].toString() == id){
        url = collection["origin_url"];
      }
    }

    return url;
  }

  int? getDonwloads(collection) {
    String id = getID(collection);

    int? url = null;

    for(var collection in collections){
      if(collection['id'].toString() == id){
        if(collection["downloads"] == 0){
          url = null;
        } else {
          url = collection["downloads"];
        }
      }
    }

    return url;
  }
}