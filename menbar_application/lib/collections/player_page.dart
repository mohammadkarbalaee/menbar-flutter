import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/collections/download_button.dart';
import 'package:menbar_application/reusable_widgets/header_button.dart';
import 'package:menbar_application/reusable_widgets/header_gradient.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';
import  'package:persian_number_utility/persian_number_utility.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class PlayerPage extends StatefulWidget {
  var title;
  var context;
  var url;
  var imageUrl;
  var orator;
  var speechTitle;
  AudioPlayer audioPlayer;

  PlayerPage(this.title,this.context,this.url,this.imageUrl,this.orator,this.speechTitle,this.audioPlayer);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {

  Duration duration = Duration();
  Duration position = Duration();
  bool is2k = false;


  @override
  void initState() {
    super.initState();

    widget.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    widget.audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });

    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    DownloadButton.showBottomPlayer(
        widget.context,
        widget.title,
        widget.url,
        widget.orator,
        widget.imageUrl,
        widget.speechTitle,
        false
    );
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(SharedData.mainColor),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.imageUrl),
                      ),
                    )
                ),
                HeaderGradient(widget.orator,widget.speechTitle),
              ],
            ),
            Container(
              height: 10,
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 1.5,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                  trackShape: CustomTrackShape(),
                ),
                child: Slider(
                  activeColor: Colors.yellow[500],
                  inactiveColor: Color(SharedData.mainColor),
                  value: position.inSeconds.toDouble(),
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  onChanged: (value){
                    setState(() {
                      widget.audioPlayer.seek(
                          new Duration(
                              seconds: value.toInt()
                          )
                      );
                      value = value;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    duration.toString().split('.')[0].toPersianDigit(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                  ),
                  Text(
                    position.toString().split('.')[0].toPersianDigit(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        var newTime = position.inSeconds - 10;
                        widget.audioPlayer.seek(
                            new Duration(
                                seconds: newTime
                            )
                        );
                      });
                    },
                    child: Icon(Icons.fast_rewind,color: Colors.white,size: 25,),
                    style: ElevatedButton.styleFrom(
                      primary: Color(SharedData.mainColor),
                      elevation: 0,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 30,),
                Container(
                  height: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      if(SharedData.isPlaying == true){
                        widget.audioPlayer.pause();
                        setState(() {
                          SharedData.isPlaying = false;
                        });
                      } else {
                        widget.audioPlayer.resume();
                        setState(() {
                          SharedData.isPlaying = true;
                        });
                      }
                    },
                    child: !SharedData.isPlaying ? Icon(Icons.play_arrow,size:25,color: Colors.white,) :
                    Icon(Icons.pause,size:25,color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[500],
                      elevation: 7,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 30,),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        var newTime = position.inSeconds + 10;
                        widget.audioPlayer.seek(
                            new Duration(
                                seconds: newTime
                            )
                        );
                      });
                    },
                    child: Icon(Icons.fast_forward,color: Colors.white,size: 25,),
                    style: ElevatedButton.styleFrom(
                      primary: Color(SharedData.mainColor),
                      elevation: 0,
                      shape: CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if(is2k){
                    widget.audioPlayer.setPlaybackRate(playbackRate: 1);
                  } else {
                    widget.audioPlayer.setPlaybackRate(playbackRate: 2);
                  }
                  setState(() {
                    is2k = !is2k;
                  });
                },
                child: Icon(
                  Icons.two_k_outlined,
                  color: is2k ? Colors.yellow[500] : Colors.white,
                  size: 30,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(SharedData.mainColor),
                  elevation: 0,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(SharedData.mainColor),
        leading: Container(),
        actions: [
          Container(
            width: 4 * (MediaQuery.of(context).size.width / 5),
            child: Center(
              child: Text(
                widget.title,
                textDirection: TextDirection.rtl,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'sans',
                  fontSize: 23,
                ),
              ),
            ),
          ),
          SizedBox(width: 5,),
          HeaderButton(
              icon: Icon(Icons.arrow_forward,color: Colors.white,),
              onPress: (){
                DownloadButton.showBottomPlayer(
                    widget.context,
                    widget.title,
                    widget.url,
                    widget.orator,
                    widget.imageUrl,
                    widget.speechTitle,
                    false
                );
                Navigator.pop(context);
              }
          )
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {Rect getPreferredRect({
  required RenderBox parentBox,
  Offset offset = Offset.zero,
  required SliderThemeData sliderTheme,
  bool isEnabled = false,
  bool isDiscrete = false,}) {final double? trackHeight = 1.5;
final double trackLeft = 0;
final double trackTop = 0;
final double trackWidth = parentBox.size.width;
return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight!);}}