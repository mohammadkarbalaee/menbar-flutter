import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CollectionInstance extends StatefulWidget {

  var image;
  var title;
  var id;
  var isSequenced;

  CollectionInstance(this.image,this.title,this.id,this.isSequenced);

  @override
  _CollectionInstanceState createState() => _CollectionInstanceState();
}

class _CollectionInstanceState extends State<CollectionInstance> {
  var collection = [];
  Future<List> _getData() async {
    List speeches = await Hive.box('speeches').get('${widget.id}');

    return widget.isSequenced ? new List.from(speeches.reversed) : speeches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color(0xff607d8d),
            expandedHeight: 270,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(widget.image,fit:BoxFit.cover,),
              title: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right:10),
                  child: Text(
                    widget.title,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'sans'
                    ),
                  ),
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
            leading: BackButton(),
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
                        height: 15,
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
          child: Icon(Icons.arrow_back,color: Colors.white,),
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
