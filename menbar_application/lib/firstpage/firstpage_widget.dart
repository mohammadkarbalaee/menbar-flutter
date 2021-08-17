import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:menbar_application/boookmarks/bookmarks_main.dart';
import 'package:menbar_application/managers/hive_manager.dart';
import 'package:menbar_application/reusable_widgets/header_button.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';
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
  List orators = HiveManager.getAllOrators();
  var showDeleteButton = false;
  List collections = HiveManager.getAllCollections();

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
    ),//orators Tag
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
    ),// news Tab
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
    ),// collections Tab
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
    ),//orators tab
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
    ),// news Tab
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
    ),//collections tab
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
    ),//bookmarks tab
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
    ),//title
    Padding(
      padding: EdgeInsets.all(10),
      child: Image.asset('images/menbar_logo.png'),
    ),//logo
  ];

  List<Widget> getThreeTabs(){
    return [
      Orators(),
      NewSpeeches(this.orators,this.collections),
      Collections(this.orators,value : filterValue),
    ];
  }

  List<Widget> getFourTabs(){
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
                      leading:isSearching ? showDeleteButton ? HeaderButton(
                        icon: Icon(Icons.clear,color: Colors.white,),
                        onPress: () {
                          setState(() {
                            fieldText.text = '';
                          });
                        }
                      ): Container() : HeaderButton(
                        icon: Icon(Icons.messenger_outline,color: Colors.white,),
                        onPress: () {
                          Navigator.of(context,rootNavigator: false).push(MaterialPageRoute(
                                builder: (context) => AboutPage(),
                                fullscreenDialog: true
                            )
                          );
                        }
                      ),
                      actions: isSearching ? [
                      Container(
                        width: 200,
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
                      HeaderButton(
                        icon: Icon(Icons.arrow_forward,color: Colors.white,),
                        onPress:() {
                          setState(() {
                            fieldText.text = '';
                            filterValue = '';
                            isSearching = !isSearching;
                          });
                        }
                    )
                      ]: normalActions,
                    bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.yellow,
                    indicatorWeight: 2.5,
                    tabs: SharedData.isBookmarksEmpty.value ? threeTabs : fourTabs,
                    ),
                    title: isSearching ? Container() :
                    HeaderButton(
                        icon:Icon(Icons.search,color: Colors.white,),
                        onPress: (){
                          setState(() {
                            DefaultTabController.of(context)!.animateTo(2);
                            isSearching = !isSearching;
                          });
                        }
                    ),
                    backgroundColor: Color(0xff607d8d),
                  ),
                  body: TabBarView(
                  children: SharedData.isBookmarksEmpty.value ? getThreeTabs(): getFourTabs(),
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