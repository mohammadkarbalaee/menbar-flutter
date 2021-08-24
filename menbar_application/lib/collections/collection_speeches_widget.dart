import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:menbar_application/managers/hive_manager.dart';
import 'package:menbar_application/reusable_widgets/header_button.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:animations/animations.dart';

import 'bookmark_buttons.dart';
import 'download_button.dart';

var globalTitle;
var globalImage;
var globalId;
var globalIsSequenced;
var globalOrator;
var globalUrl;
var globalDownloads;
var showIt = true;
var isBookmarked;

var allSpeeches;

class CollectionInstance extends StatefulWidget {

  var image;
  var title;
  var id;
  var isSequenced;
  var orator;
  var url;
  var downloads;

  CollectionInstance(image, title, id, isSequenced, orator, url, downloads){
    this.image = image;
    this.title = title;
    this.id = id;
    this.isSequenced = isSequenced;
    this.orator = orator;
    this.url = url == null ? "" : url;
    this.downloads = downloads;
    globalId = id;
    globalTitle = title;
    globalImage = image;
    globalIsSequenced = isSequenced;
    globalOrator = orator;
    globalUrl = url;
    globalDownloads = downloads;
  }

  @override
  _CollectionInstanceState createState() => _CollectionInstanceState();
}

class _CollectionInstanceState extends State<CollectionInstance> with SingleTickerProviderStateMixin{
  var collection = [];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    List speeches = HiveManager.getSpeechesById(widget.id);

     allSpeeches = widget.isSequenced ? new List.from(speeches.reversed) : speeches;

    isBookmarked = HiveManager.getIsBookmarked(globalId);
    _controller = AnimationController(
        vsync: this,
        value: 1,
        duration: Duration(milliseconds: 2300),
        reverseDuration: Duration(milliseconds: 1300),
    )..addStatusListener((status) {});
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification){
          setState(() {
            if(notification.direction == ScrollDirection.reverse){
              _controller.reverse();
            } else if(notification.direction == ScrollDirection.forward){
               _controller.forward();
            }
          });
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverStack(
              positionedAlignment: Alignment.topLeft,
                children: [
                  SliverAppBar(
                    primary: true,
                    leading: BookmarkButton(
                        (){
                          bookmarkAction();
                        },
                      isBookmarked,
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: Color(SharedData.mainColor),
                    expandedHeight: 260,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget.image),
                                ),
                              )
                          ),
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                    ]
                                )
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: 10,bottom: 10),
                              child: Container(
                                height: 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.title,
                                            textDirection: TextDirection.rtl,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 26,
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
                                          width: 110,
                                          child: InkWell(
                                            child: Text(
                                              cutUrl(widget.url),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                decoration: TextDecoration.underline,
                                                color: Colors.yellow[500],
                                              ),
                                            ),
                                            onTap: () => launch(widget.url),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            widget.orator,
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
                        ],
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                    actions: [
                      HeaderButton(
                        icon: Icon(Icons.arrow_forward,color: Colors.white,),
                        onPress: () => Navigator.pop(context),
                      ),
                    ],
                  ),//app bar
                  SliverToBoxAdapter(
                    child:AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => FadeScaleTransition(
                        animation: _controller,
                        child: child,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 290),
                        child: Container(
                          height: 38,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            margin: EdgeInsets.zero,
                            semanticContainer: true,
                            elevation: 3,
                            color: Color(0xfff5f5f5),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6,bottom: 6,right: 15),
                              child: Text(
                                widget.downloads == null ? "" :
                                'بیش از  ${widget.downloads} دریافت از این مجموعه',
                                style: TextStyle(
                                  fontFamily: 'sans',
                                  fontSize: 15,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),//downloads quantity label
                  SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => FadeScaleTransition(
                        animation: _controller,
                        child: child,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 260,right: 290),
                        child: Container(
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 35,bottom: 0,),
                              child: YellowBookMarkButton(
                                  (){
                                    bookmarkAction();
                                  },
                                isBookmarked,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),//yellow bookmark button
                ]
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 6,
              ),
            ),//space between
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context,index){
                      return Column(
                        children:[
                          ListTile(
                            dense: true,
                            title: Text(
                              allSpeeches[index]['title'],
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
                                      allSpeeches[index]['file_size'] == null ? "":
                                      '${allSpeeches[index]["file_size"]} مگابایت',
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                        fontFamily: 'sans',
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 30,),
                                    Text(
                                      allSpeeches[index]['duration'] == null ? "" :
                                      '${allSpeeches[index]["duration"]} دقیقه',
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
                            leading: DownloadButton(
                                allSpeeches[index]['file'] == null ? "": allSpeeches[index]['file'],
                              widget.image,
                              allSpeeches[index]['title'],
                              widget.orator,
                              widget.title
                            ),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1.5,
                            color: Colors.black38,
                          ),
                      ],
                      );
                    },
                  childCount: allSpeeches.length,
                )
            ),//speeches list
          ],
        ),
      ),
    );
  }

  void bookmarkAction() {
    setState(() {
      if(isBookmarked){
        HiveManager.deleteBookmard(globalId);
        isBookmarked = !isBookmarked;
        SharedData.isBookmarksEmpty.value = HiveManager.isBookmarksEmpty();
      } else {
        var collection = {
          'title': globalTitle,
          'image': globalImage,
          'id' : globalId,
          'is_squenced':globalIsSequenced,
          'sokhanran': globalOrator,
          'url': globalUrl,
          'downloads': globalDownloads,
        };
        HiveManager.putBookmarked(globalId, collection);
        isBookmarked = !isBookmarked;
        SharedData.isBookmarksEmpty.value = false;
      }
    });
  }
}