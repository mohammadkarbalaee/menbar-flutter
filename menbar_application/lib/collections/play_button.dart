import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';

class PlayButton extends StatefulWidget {
  var path;
  AudioPlayer audioPlayer;

  PlayButton(this.path,this.audioPlayer);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {

  @override
  void initState() {
    super.initState();
    widget.audioPlayer.play(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: OutlinedButton(
        onPressed: (){
        },
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.white38,
        ),
        child: IconButton(
          icon: SharedData.isPlaying ? Icon(Icons.play_arrow,size:25,color: Colors.black54,) :
          Icon(Icons.pause,size:25,color: Colors.black54,),
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {

              if(SharedData.isPlaying == true){
                widget.audioPlayer.pause();
              } else {
                widget.audioPlayer.resume();
              }

              SharedData.isPlaying = !SharedData.isPlaying;
            });
          },
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
