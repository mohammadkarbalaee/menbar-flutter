import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:menbar_application/firstpage/shared_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:animations/animations.dart';

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

    List speeches = Hive.box('speeches').get('${widget.id}');
     allSpeeches = widget.isSequenced ? new List.from(speeches.reversed) : speeches;

    isBookmarked = getIsBookmarked();
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
                    leading: BookmarkButton(),
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
                                  image: NetworkImage(widget.image),
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
                  ),
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
                  ),
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
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    final box = Hive.box('bookmarks');
                                    if(isBookmarked){
                                      box.delete(globalId);
                                      isBookmarked = !isBookmarked;
                                      Shared.isBookmarksEmpty.value = box.isEmpty;
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

                                      box.put(globalId,collection);
                                      isBookmarked = !isBookmarked;
                                      Shared.isBookmarksEmpty.value = false;
                                    }
                                  });
                                },
                                child: isBookmarked ? Icon(Icons.bookmark,color: Colors.white,size: 25,):
                                Icon(Icons.bookmark_border,color: Colors.white,size: 25,),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.yellow[500],
                                  elevation: 7,
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 6,
              ),
            ),
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
                            leading: DownloadButton(allSpeeches[index]['file'] == null ? "": allSpeeches[index]['file']),
                          ),
                          Divider(
                            height: 10,
                            thickness: 1.5,
                            color: Colors.black38,
                          ),
                      ],
                      );
                    }
                )
            ),
            // SliverToBoxAdapter(
            //
            //   child: FutureBuilder(
            //
            //       future: _getData(),
            //
            //       builder: (BuildContext context,AsyncSnapshot snapshot){
            //
            //         if(snapshot.data == null){
            //           return Padding(
            //           padding: const EdgeInsets.only(top: 30.0),
            //             child: Center(
            //               child: CircularProgressIndicator()
            //             ),
            //           );
            //         }
            //         else {
            //           return ListView.separated(
            //             primary: false,
            //             shrinkWrap: true,
            //             itemCount: snapshot.data.length,
            //
            //             separatorBuilder: (BuildContext context, int index) {
            //               return Divider(
            //                 height: 10,
            //                 thickness: 1.5,
            //                 color: Colors.black38,
            //               );
            //             },
            //             itemBuilder: (BuildContext context, int index) {
            //               return
            //             },
            //           );
            //         }
            //       }
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}


class HeaderButton extends StatefulWidget {
  var icon;
  var onPress;

  HeaderButton({this.icon,this.onPress});

  @override
  _HeaderButtonState createState() => _HeaderButtonState();
}

class _HeaderButtonState extends State<HeaderButton> {

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
          onPressed: widget.onPress,
          child: widget.icon,
        ),
      ),
    );
  }
}


class BookmarkButton extends StatefulWidget {
  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {


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
          // onPressed: (){},
          onPressed: () {
            setState(() {
              final box = Hive.box('bookmarks');
              if(isBookmarked){
                box.delete(globalId);
                isBookmarked = !isBookmarked;
                Shared.isBookmarksEmpty.value = box.isEmpty;
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

                box.put(globalId,collection);
                isBookmarked = !isBookmarked;
                Shared.isBookmarksEmpty.value = false;
              }
            });
          },
          child: isBookmarked ? Icon(Icons.bookmark,color: Colors.white,): Icon(Icons.bookmark_border,color: Colors.white,),
        ),
      ),
    );
  }
}
class DownloadButton extends StatefulWidget {
  String url;

  DownloadButton(this.url);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  var buttonStatus = false;
  double progress = 0;
  var isDownloaded = false;
  var isInProgress = false;
  var downloadStream;

  @override
  void initState() {
    super.initState();
    isDownloaded = getIsDownloaded(widget.url);
  }

  Future startDownload(String url,bool pause) async {

    if(url == ""){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'فایل صوتی سخنرانی برای دانلود موجود نیست',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    if(pause){

    } else {
      final request = Request('GET', Uri.parse(url));
      final response = await Client().send(request);
      final voiceLength = response.contentLength;

      final file = await getFile(url);
      final downloadedBytes = <int> [];

      response.stream.listen(
            (newBytes) {
          downloadedBytes.addAll(newBytes);

          setState(() {
            if (voiceLength != null) {
              progress = downloadedBytes.length / voiceLength;
            }
          });
        },
        onDone: () async {
          setState(() {
            isDownloaded = !isDownloaded;
          });

          await file.writeAsBytes(downloadedBytes);
          downloadedBytes.clear();
          Hive.box('downloadeds').put(widget.url, true);
        },
      );
    }
}

  Future<File> getFile(fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/filename");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          buttonStatus ? Container(
            height: 47,
            width: 47,
            child: isDownloaded ? Container() : progress <= 0.01 ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black26),
            ):CircularProgressIndicator(
              value: progress,
              valueColor: AlwaysStoppedAnimation(Color(0xff607d8d)),
              strokeWidth: 5,
              backgroundColor: Colors.white,
            )
          )
              :
          Container(
              height: 47,
              width: 47,
              child: CircularProgressIndicator(
                value: progress == 1 ? 0 : progress,
                valueColor: AlwaysStoppedAnimation(Colors.black26),
                strokeWidth: 5,
                backgroundColor: Colors.white,
              ),
          ),
          Container(
            height: 100,
            child: OutlinedButton(
              child: isDownloaded ? Icon(Icons.play_arrow, size: 25,color: Colors.white,) : buttonStatus ? Icon(Icons.close, size: 25,) : Icon(Icons.get_app, size: 25,),
              onPressed: isDownloaded ? (){} :(){
                setState(() {
                  buttonStatus = !buttonStatus;
                  if(isInProgress == false){
                    startDownload(widget.url,false);
                    isInProgress = !isInProgress;
                  }
                  else {
                    startDownload(widget.url,true);
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                primary: Colors.black,
                backgroundColor: isDownloaded ? Colors.grey :Colors.white,
                elevation: 0,
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      )
    );
  }

  bool getIsDownloaded(String url) {
    final box = Hive.box('downloadeds');
    bool isDownloaded = box.get(url) == null ? false : true;
    return isDownloaded;
  }
}

String cutUrl(String url){
  List pieces = url.split('/');
  return pieces.length != 1? pieces[2] : "";
}

bool getIsBookmarked() {
  final box = Hive.box('bookmarks');
  bool isBookmarked = box.get(globalId) == null ? false : true;
  return isBookmarked;
}

