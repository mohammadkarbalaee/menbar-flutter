import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menbar_application/newspeeches/new_speeches_widget.dart';
import 'package:menbar_application/Orators/orators_view_widget.dart';
import 'package:menbar_application/collections/collections_main_widget.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {

  List orators = Hive.box('orators').get('list');
  List collections = Hive.box('collections').get('list');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 7.0,
            bottomOpacity: 1,
            leading:AboutButton(),
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 18,right: 10),
                child: Text(
                  'منبر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'sans',
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset('images/menbar_logo.png'),
              ),

            ],
            bottom: TabBar(
              indicatorColor: Colors.yellow,
              indicatorWeight: 2.5,
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      Text(
                          'سخنران ها',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'sans',
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.person),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Text(
                        'تازه ها',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          fontFamily: 'sans',
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.new_releases),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Text(
                        'مجموعه ها',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          fontFamily: 'sans',
                        ),
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.apps),
                    ],
                  ),
                )
              ],
            ),
            title: SearchButton(),
            backgroundColor: Color(0xff607d8d),
          ),
          body: TabBarView(
            children: [
              Orators(),
              NewSpeeches(this.orators,this.collections),
              Collections(this.orators),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutButton extends StatelessWidget {
  const AboutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 45,
        minWidth: 40,
        splashColor: Colors.grey,
        child: RaisedButton(
          elevation: 0,
          color: Color(0xff607d8d),
          onPressed: () {},
          child: Icon(Icons.messenger_outline,color: Colors.white,),
        ),
      ),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 50,
        minWidth:30,
        splashColor: Colors.grey,
        child: RaisedButton(
          elevation: 0,
          color: Color(0xff607d8d),
          onPressed: () {},
          child: Icon(Icons.search,color: Colors.white,),
        ),
      ),
    );
  }
}

