import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:menbar_application/collections/play_button.dart';
import 'package:menbar_application/managers/hive_manager.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';
import 'package:path_provider/path_provider.dart';


class DownloadButton extends StatefulWidget {
  String url;
  String imageUrl;
  String title;
  String orator;

  DownloadButton(this.url,this.imageUrl,this.title,this.orator);

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
                child: isDownloaded ? Icon(Icons.play_arrow, size: 25,color: Colors.white,) : buttonStatus ? Icon(Icons.close, size: 25,) : Icon(Icons.get_app, size: 25,),
                onPressed: isDownloaded ? (){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        padding: EdgeInsets.zero,
                        elevation: 500,
                        backgroundColor: Colors.white,
                        content: Container(
                          height: 120,
                          child: Card(
                            elevation: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: PlayButton(),
                                  flex: 3,
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.title,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: 'sans',
                                        ),
                                      ),
                                      Text(
                                        widget.orator,
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
                                SizedBox(width: 20),
                                Flexible(
                                    flex: 3,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.imageUrl,
                                      fadeInDuration:Duration(milliseconds: 500),
                                      fadeInCurve:Curves.easeInExpo,
                                      fit: BoxFit.fitHeight,
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                        duration: Duration(seconds: 3),
                      )
                  );
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
}

String cutUrl(String url){
  List pieces = url.split('/');
  return pieces.length != 1? pieces[2] : "";
}