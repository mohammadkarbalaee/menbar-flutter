import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

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
          icon: Icon(Icons.play_arrow,size:25,color: Colors.black54,),
          onPressed: () {
          },
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
