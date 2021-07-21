import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'CollectionInstance.dart';

class Sets extends StatelessWidget {

  const Sets({Key? key}) : super(key: key);

  Future<List> _getData() async {
    List result = [];

    String apiUrl = 'http://menbar.sobhe.ir/api/collections/';
    http.Response collectionsResponse = await http.get(Uri.parse(apiUrl));
    List collections = json.decode(collectionsResponse.body);
    for(var instance in collections){
      List temp = [];
      temp.add(instance['title']);
      temp.add(instance['image']);
      // http.Response oratorResponse = await http.get(Uri.parse(instance["sokhanran"]));
      // var oratorJson = json.decode(oratorResponse.body);
      //
      // temp.add(oratorJson['title']);

      result.add(temp);
    }
    return result;
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
                              Image.network(snapshot.data[index][1]),
                              Padding(
                                  padding: EdgeInsets.only(top: 130),
                                  child: Column(

                                    children: [
                                      Text(
                                        snapshot.data[index][0],
                                        style: TextStyle(
                                          backgroundColor: Colors.yellowAccent,
                                        ),
                                      ),// title of the speech
                                      Text(
                                          'orator name'
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
                            builder: (context) => CollectionInstance(snapshot.data[index][1])
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
}