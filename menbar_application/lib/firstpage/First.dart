import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/firstpage/NewSpeeches.dart';
import 'package:menbar_application/Orators/OratorsView.dart';
import 'package:menbar_application/collections/collectionsView.dart';

// ignore: must_be_immutable
class FirstActivity extends StatelessWidget {

  List orators;

  FirstActivity(this.orators);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 7.0,
            bottomOpacity: 1,
            leading:AboutButton(),
            actions: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'منبر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Image.asset('images/menbar_logo.png'),
              ),

            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      Text(
                          'سخنران ها',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold
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
              NewSpeeches(),
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
