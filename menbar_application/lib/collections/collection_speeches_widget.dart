import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CollectionInstance extends StatelessWidget {

  var image;
  var title;

  CollectionInstance(this.image,this.title);

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
              background: Image.network(image,fit:BoxFit.cover,),
              title: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right:10),
                  child: Text(
                    title,
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

            //convert it to ListView.separated

            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: [
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
                Card(
                  child: ListTile(title: Text('1'),),
                  elevation: 0,
                ),
              ],
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
