import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menbar_application/boookmarks/bookmarks_main.dart';
import 'package:menbar_application/shared_data.dart';
import 'package:menbar_application/new_speeches/new_speeches_widget.dart';
import 'package:menbar_application/Orators/orators_view_widget.dart';
import 'package:menbar_application/collections/collections_main_widget.dart';

import 'about_page_widget.dart';

var isSearching = false;
var filterValue = '';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  List orators = Hive.box('orators').get('list');
  var showDeleteButton = false;
  List collections = Hive.box('collections').get('list');

  List<Widget> threeTabs = [
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
    ),
  ];

  List<Widget> fourTabs = [
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
    ),
    Tab(
      child: Row(
        children: [
          Text(
            'نشان ها',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'sans',
            ),
          ),
          SizedBox(width: 5,),
          Icon(Icons.bookmark),
        ],
      ),
    ),
  ];

  List<Widget> normalActions = [
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
  ];

  List<Widget> getThree(){
    return [
      Orators(),
      NewSpeeches(this.orators,this.collections),
      Collections(this.orators,value : filterValue),
    ];
  }

  List<Widget> getFour(){
    return [
      Orators(),
      NewSpeeches(this.orators,this.collections),
      Collections(this.orators,value : filterValue),
      Bookmarks(this.orators),
    ];
  }

  final fieldText = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: ValueListenableBuilder(

        builder: (BuildContext context, value, Widget? child) {
          return DefaultTabController(
              initialIndex: 1,
              length: SharedData.isBookmarksEmpty.value ? 3 : 4,
              child: Builder(
                builder: (context){
                  return Scaffold(
                    appBar: AppBar(
                      elevation: 7.0,
                      bottomOpacity: 1,
                      leading:isSearching ? showDeleteButton ? Container(
                        child: ButtonTheme(
                          height: 45,
                          minWidth: 40,
                          splashColor: Colors.grey,
                          child: RaisedButton(
                            elevation: 0,
                            color: Color(0xff607d8d),
                            onPressed: () {
                              setState(() {
                                fieldText.text = '';
                              });
                            },
                            child: Icon(Icons.clear,color: Colors.white,),
                          ),
                        ),
                      ): Container() : AboutButton(),
                      actions: isSearching ? [
                      Container(
                        width: 300,
                        child: TextField(
                          controller: fieldText,
                          onChanged: (value) {
                            setState(() {
                              showDeleteButton = true;
                              filterValue = value;
                            });
                          },
                          cursorColor: Colors.yellow,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textDirection: TextDirection.rtl,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: 'جستجو',
                            hintTextDirection: TextDirection.rtl,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: ButtonTheme(
                          height: 50,
                          minWidth:30,
                          splashColor: Colors.grey,
                          child: RaisedButton(
                            elevation: 0,
                            color: Color(0xffffff),
                            onPressed: (){
                              setState(() {
                                fieldText.text = '';
                                filterValue = '';
                                isSearching = !isSearching;
                              });
                            },
                            child: Icon(Icons.arrow_forward,color: Colors.white,),
                          ),
                        ),
                      ),
                      ]: normalActions,
                    bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.yellow,
                    indicatorWeight: 2.5,
                    tabs: SharedData.isBookmarksEmpty.value ? threeTabs : fourTabs,
                    ),
                    title: isSearching ? Container() :
                    Container(
                      child: ButtonTheme(
                        height: 50,
                        minWidth:30,
                        splashColor: Colors.grey,
                        child: RaisedButton(
                          elevation: 0,
                          color: Color(0xff607d8d),
                          onPressed: () {
                            setState(() {
                              DefaultTabController.of(context)!.animateTo(2);
                              isSearching = !isSearching;
                            });
                          },
                          child: Icon(Icons.search,color: Colors.white,),
                        ),
                      ),
                    ),
                    backgroundColor: Color(0xff607d8d),
                  ),
                  body: TabBarView(
                  children: SharedData.isBookmarksEmpty.value ? getThree(): getFour(),
                  ),
                  );
                },
              )
          );
        },
        valueListenable: SharedData.isBookmarksEmpty,
        child: Container(),
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
          onPressed: () {
            Navigator.of(context,rootNavigator: false).push(MaterialPageRoute(
                builder: (context) => AboutPage(),
                fullscreenDialog: true
            )
            );
          },
          child: Icon(Icons.messenger_outline,color: Colors.white,),
        ),
      ),
    );
  }
}
