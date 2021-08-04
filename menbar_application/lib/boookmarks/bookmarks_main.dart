import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menbar_application/collections/collection_speeches_widget.dart';


class Bookmarks extends StatelessWidget {
  List orators;
  Bookmarks(this.orators);

  Future<Iterable> _getData() async {
    Iterable values = await Hive.box('bookmarks').values;
    List collections = [];
    for(var i in values){
      collections.add(i);
    }
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
                                                  snapshot.data[index]["sokhanran"],
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
                                snapshot.data[index]['is_squenced'],
                                snapshot.data[index]["sokhanran"],
                                snapshot.data[index]["origin_url"],
                                snapshot.data[index]['downloads'],
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
}