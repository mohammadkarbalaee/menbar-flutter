import 'package:flutter/cupertino.dart';

class OratorInstance extends StatelessWidget {

  var image;
  OratorInstance(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image),
    );
  }
}
