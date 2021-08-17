import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/collections/collection_speeches_widget.dart';
import 'package:menbar_application/managers/hive_manager.dart';

import '../header_back_button.dart';
import '../shared_data.dart';

class OratorInstance extends StatelessWidget {
  var image;
  var name;
  var id;
  OratorInstance(this.image,this.name,this.id);

  Future<List> getData() async{
    return await HiveManager.getCollectionsById(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBar(name,image),
          CollectionsList(getData),
        ],
      )
    );
  }
}


Future<String> getName(String oratorUrl) async {
  List splited = oratorUrl.split("/");
  String  oratorID = splited[splited.length - 2];
  String oratorName = await findNameByID(oratorID);
  return oratorName;
}

Future<String> findNameByID(String oratorID) async {
  String name = 'failed to find';
  List orators = await HiveManager.getAllOrators();
  for(var orator in orators){
    if(orator['id'].toString() == oratorID){
      name = orator['title'];
    }
  }
  return name;
}

class AppBar extends StatelessWidget {
  var name;
  var image;

  AppBar(this.name, this.image);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: HeaderBackButton(
        icon: Icon(Icons.arrow_back,color: Colors.white,),
        onPress: () => Navigator.pop(context),
      ),
      primary: true,
      automaticallyImplyLeading: false,
      backgroundColor: Color(SharedData.mainColor),
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              name,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'sans'
              ),
            ),
          ),
        ),

        background: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(image),
                  ),
                )
            ),
            Positioned(
              child: PhysicalModel(
                borderRadius: BorderRadius.circular(0),
                color: Colors.black12,
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Container(
                    height: 60,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}


class CollectionsList extends StatelessWidget {
  var getDataFunction;

  CollectionsList(this.getDataFunction);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder(
        future: getDataFunction(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.data == null){
            return Center(
              child: Text('',),
            );
          }
          else {
            return ListView.builder(
              primary: false,
              shrinkWrap: true,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.data[index]['title'],
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                              height: 120,
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data[index]['image'],
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
              },
            );
          }
        },
      ),
    );
  }
}
