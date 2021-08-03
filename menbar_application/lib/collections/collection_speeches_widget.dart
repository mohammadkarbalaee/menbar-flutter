import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class CollectionInstance extends StatelessWidget {

  var image;
  var title;
  var id;
  var isSequenced;
  var orator;
  var url;
  var downloads;
  var collection = [];

  CollectionInstance(
      this.image,
      this.title,
      this.id,
      this.isSequenced,
      this.orator,
      this.url,
      this.downloads
      );

  Future<List> _getData() async {
    List speeches = await Hive.box('speeches').get('$id');

    return isSequenced ? new List.from(speeches.reversed) : speeches;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff607d8d),
            expandedHeight: 270,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
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
                                      child: Text(
                                        title,
                                        textDirection: TextDirection.rtl,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'sans'
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: InkWell(
                                        child: Text(
                                          url,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline,
                                            color: Colors.yellow[600],
                                          ),
                                        ),
                                        onTap: () => launch(url),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        orator,
                                        textDirection: TextDirection.rtl,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15,
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
                  ),
                ],
              ),
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              BackButton(),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 35,
              child: Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                ),
                elevation: 3,
                color: Color(0xfff5f5f5),
                child: Text(
                  'بیش از  $downloads دریافت از این مجموعه',
                  style: TextStyle(
                    fontFamily: 'sans',
                    fontSize: 18,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(

            child: FutureBuilder(

                future: _getData(),

                builder: (BuildContext context,AsyncSnapshot snapshot){

                  return ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,

                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 10,
                        thickness: 1.5,
                        color: Colors.black38,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        dense: true,
                        title: Text(
                          snapshot.data[index]['title'],
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans',
                            fontSize: 19,
                          ),
                        ),
                        subtitle: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${snapshot.data[index]["file_size"]} مگابایت',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'sans',
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 30,),
                                Text(
                                  '${snapshot.data[index]["duration"]} دقیقه',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'sans',
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        leading: DownloadButton(),
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}


class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 50,
        minWidth:30,
        splashColor: Colors.grey,
        child: RaisedButton(
          elevation: 0,
          color: Color(0xffffff),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_forward,color: Colors.white,),
        ),
      ),
    );
  }
}

class DownloadButton extends StatefulWidget {
  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  var boool = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          boool ? Container(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.black38,
            ),
          )
              : Text(''),
          OutlinedButton(
            child: boool ? Icon(Icons.close, size: 25,) : Icon(Icons.get_app, size: 25,),
            onPressed: () {
              setState(() {
                boool = !boool;
              });
            },
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0,
              shape: CircleBorder(),
            ),
          ),
        ],
      )
    );
  }
}
