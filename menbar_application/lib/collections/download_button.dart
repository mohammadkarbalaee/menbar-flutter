import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:menbar_application/collections/play_button.dart';
import 'package:menbar_application/collections/player_page.dart';
import 'package:menbar_application/managers/hive_manager.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';
import 'package:path_provider/path_provider.dart';


class DownloadButton extends StatefulWidget {
  String url;
  String imageUrl;
  String title;
  String orator;
  String speechTitle;
  static AudioPlayer _audioPlayerController = AudioPlayer();

  static void showBottomPlayer(
      mainContext,
      title,
      url,
      orator,
      imageUrl,
      speechTitle,
      shouldStart
      ){
    showFlash(
        context: mainContext,
        persistent: true,
        builder: (context,controller){
          return Flash.bar(
            useSafeArea: false,
            enableVerticalDrag: false,
            onTap: (){
              controller.dismiss();
              Navigator.of(context,rootNavigator: false).push(MaterialPageRoute(
                  builder: (context) => PlayerPage(
                    title,
                    mainContext,
                    url,
                    imageUrl,
                    orator,
                    speechTitle,
                    _audioPlayerController,
                  ),
              )
              );
            },
            controller: controller,
            child: Container(
              height: 90,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PlayButton(
                              url,
                            _audioPlayerController,
                            shouldStart
                          ),
                          SizedBox(width: 120,),
                          Container(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'sans',
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  orator,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'sans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fadeInDuration:Duration(milliseconds: 500),
                      fadeInCurve:Curves.easeInExpo,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  DownloadButton(this.url,this.imageUrl,this.title,this.orator,this.speechTitle);

  @override
  _DownloadButtonState createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  var buttonStatus = false;
  double progress = 0;
  var isInProgress = false;
  var isPaused = false;
  var isDownloaded = false;

  @override
  void initState() {
    super.initState();
    isDownloaded = HiveManager.getIsDownloaded(widget.url);
    progress = HiveManager.getProgress(widget.url);
  }

  Future startDownload(String url) async {

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



    final request = Request('GET', Uri.parse(url));
    final response = await Client().send(request);
    final voiceLength = response.contentLength;

    final file = await getFile(url);
    final downloadedBytes = <int> [];
    int wasteSize = 0;
    var shouldResume = false;

    response.stream.listen(
          (newBytes) async {
        if(isPaused == false && shouldResume == false){
          downloadedBytes.addAll(newBytes);
          setState(() {
            if (voiceLength != null) {
              progress = downloadedBytes.length / voiceLength;
            }
          });
        } else if(isPaused == false && shouldResume == true) {
          wasteSize += newBytes.length;
          if(wasteSize >= downloadedBytes.length){
            shouldResume = false;
          }
        } else {
          HiveManager.putPaused(widget.url, progress);
          await file.writeAsBytes(downloadedBytes);
          isInProgress = !isInProgress;
        }
      },
      onDone: () async {
        if(isPaused == false){
          setState(() {
            isDownloaded = true;
          });

          await file.writeAsBytes(downloadedBytes);
          downloadedBytes.clear();
          HiveManager.putDownloaded(widget.url);
        }
      },
    );
  }


  Future<File> getFile(fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    print("${directory.path}/filename");

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
                  valueColor: AlwaysStoppedAnimation(Color(SharedData.mainColor)),
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
                child: isDownloaded ?
                    Icon(Icons.play_arrow, size: 25,color: Colors.white,)
                    : buttonStatus ? Icon(Icons.close, size: 25,)
                    : Icon(Icons.get_app, size: 25,),
                onPressed: isDownloaded ? (){

                  var data = HiveManager.getPlayingData();
                  bool isBottomPlayerDifferent = true;

                  if(!HiveManager.getIsPlayingEmpty()){
                    isBottomPlayerDifferent = data['title'] != widget.title;
                  }

                  if(isBottomPlayerDifferent){

                    DownloadButton.showBottomPlayer(
                        context,
                        widget.title,
                        widget.url,
                        widget.orator,
                        widget.imageUrl,
                        widget.speechTitle,
                      true
                    );

                    HiveManager.putPlayer(
                      'data',
                      {
                        'title':widget.title,
                        'url':widget.url,
                        'orator':widget.orator,
                        'imageUrl':widget.imageUrl,
                        'speechTitle': widget.speechTitle
                      }
                    );
                  }
                } :(){
                  setState(() {
                    buttonStatus = !buttonStatus;

                    if(isInProgress == true){
                      isPaused = !isPaused;
                    }
                    if(isInProgress == false){
                      startDownload(widget.url);
                      isInProgress = !isInProgress;
                    }
                  });
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black,
                  backgroundColor: isDownloaded ? Color(SharedData.mainColor) :Colors.white,
                  elevation: 0,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ],
        )
    );
  }
}

String cutUrl(String url){
  List pieces = url.split('/');
  return pieces.length != 1? pieces[2] : "";
}