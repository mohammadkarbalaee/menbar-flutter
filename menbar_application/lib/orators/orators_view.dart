import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'orator_instance.dart';

class Orators extends StatelessWidget {

  Future<List> _getData() async {

    String oratorsApiUrl = 'http://menbar.sobhe.ir/api/sokhanrans/';
    http.Response oratorsResponse = await http.get(Uri.parse(oratorsApiUrl));
    List orators = json.decode(utf8.decode(oratorsResponse.bodyBytes));
    return orators;
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
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(top: 4,bottom: 4,left: 1,right: 1),
                                child: Card(
                                  elevation: 10,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 210,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(snapshot.data[index]['image']),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                child: PhysicalModel(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.black38,
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
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'sans',
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
                            builder: (context) => OratorInstance(snapshot.data[index]['image'])
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
}