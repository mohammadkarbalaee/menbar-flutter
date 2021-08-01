import 'package:flutter/cupertino.dart';

class CollectionInstance extends StatelessWidget {
  
  var image;
  CollectionInstance(this.image);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image),
    );
  }
}
