import 'package:flutter/material.dart';

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool isPlaying = false;
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
              isPlaying = !isPlaying;
            });
          },
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
