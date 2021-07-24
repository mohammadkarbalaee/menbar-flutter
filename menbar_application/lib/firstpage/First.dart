import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/firstpage/NewSpeeches.dart';
import 'package:menbar_application/firstpage/Orators.dart';
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
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset('images/menbar_logo.png'),
            ),
            actions: [
              AboutButton(),
              SearchButton(),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.people),
                  text: 'سخنران ها',
                ),
                Tab(
                  icon: Icon(Icons.new_releases),
                  text: 'تازه ها',
                ),
                Tab(
                  icon: Icon(Icons.apps),
                  text: 'مجموعه ها',
                )
              ],
            ),
            title: Text('منبر',textAlign: TextAlign.center,),
            backgroundColor: Color(0xff76b3af),
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
        minWidth: 50,
        splashColor: Colors.grey,
        child: RaisedButton(
          color: Color(0xff76b3af),
          onPressed: () {},
          child: Icon(Icons.message,color: Colors.white,),
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
          color: Color(0xff76b3af),
          onPressed: () {},
          child: Icon(Icons.search,color: Colors.white,),
        ),
      ),
    );
  }
}

