import 'package:flutter/cupertino.dart';

class NewSpeechInstance extends StatelessWidget {

  var image;
  NewSpeechInstance(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image),
    );
  }
}
