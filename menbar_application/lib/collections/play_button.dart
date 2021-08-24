import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  var path;

  PlayButton(this.path);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  late AudioPlayer audioPlayer;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.play(widget.path);
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
          icon: isPlaying ? Icon(Icons.play_arrow,size:25,color: Colors.black54,) :
          Icon(Icons.pause,size:25,color: Colors.black54,),
          splashColor: Colors.transparent,
          onPressed: () {
            setState(() {

              if(isPlaying == true){
                audioPlayer.pause();
              } else {
                audioPlayer.resume();
              }

              isPlaying = !isPlaying;
            });
          },
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
