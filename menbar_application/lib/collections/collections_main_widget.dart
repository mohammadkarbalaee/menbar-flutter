import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'collection_speeches_widget.dart';

var titles;
var oratorList;

class Collections extends StatefulWidget {
  List orators;
  var value;
  Collections(this.orators,{this.value});

  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {

  Future<List> _getData() async {
    List collections = await Hive.box('collections').get('list');

    if(titles == null){
      List temp = [];
      for(var i in collections){
        temp.add(i['title']);
      }
      titles = temp;
    }

    if(oratorList == null){
      List temp = [];
      for(var i in collections){
        temp.add(i['sokhanran']);
      }
      oratorList = temp;
    }

    if(widget.value == null || widget.value == ''){
      return collections;
    } else {
      print(widget.value);
      List matchedJsonsByTitle = getMatchedJsons(getMatchedTitles(widget.value),collections,'title');
      if(matchedJsonsByTitle == []){
        return getMatchedJsons(getMatchedOrators(widget.value),collections,'sokhanran');
      } else {
        return matchedJsonsByTitle;
      }
    }
  }

  @override

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(

          future: _getData(),

          builder: (BuildContext context,AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Center(
                child: CircularProgressIndicator()
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          elevation: 20,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Image.network(snapshot.data[index]['image'],),
                              ),
                              Positioned(
                                  child: PhysicalModel(
                                    borderRadius: BorderRadius.circular(0),
                                    color: Colors.black26,
                                    elevation: 30,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10),
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
                                                Flexible(
                                                    child: Text(
                                                      snapshot.data[index]['title'],
                                                      textDirection: TextDirection.rtl,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          fontFamily: 'sans'
                                                      ),
                                                    ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Flexible(
                                                    child: Text(
                                                      getName(snapshot.data[index]["sokhanran"]),
                                                      textDirection: TextDirection.rtl,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          fontFamily: 'sans'
                                                      ),
                                                    ),
                                                ),
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
                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                            builder: (context) => CollectionInstance(
                                snapshot.data[index]['image'],
                                snapshot.data[index]['title'],
                                snapshot.data[index]['id'],
                                snapshot.data[index]["is_sequence"],
                                getName(snapshot.data[index]["sokhanran"]),
                                snapshot.data[index]["origin_url"],
                                snapshot.data[index]['downloads']
                            ),
                            fullscreenDialog: true
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

    for(var orator in widget.orators){
      if(orator['id'].toString() == oratorID){
        name = orator['title'];
      }
    }

    return name;
  }
}

List getMatchedJsons(List matchedTitles,List collections,String type) {
  List result = [];
  for(var i in matchedTitles){
    for(var j in collections){
      if(i == j[type]){
        result.add(j);
      }
    }
  }
  return result;
}

List getMatchedTitles(value) {
  List result = [];
  for(var i in titles){
    if(i != null){
      if(i.contains(value)){
        result.add(i);
      }
    }
  }
  return result;
}

List getMatchedOrators(value) {
  List result = [];
  for(var i in oratorList){
    if(i != null){
      if(i.contains(value)){
        result.add(i);
      }
    }
  }
  return result;
}