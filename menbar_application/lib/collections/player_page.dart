import 'package:flutter/material.dart';
import 'package:menbar_application/collections/download_button.dart';
import 'package:menbar_application/reusable_widgets/header_button.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';

class PlayerPage extends StatefulWidget {
  var title;
  var context;
  var url;
  var imageUrl;
  var orator;

  PlayerPage(this.title,this.context,this.url,this.imageUrl,this.orator);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(

        ),
        appBar: AppBar(
          backgroundColor: Color(SharedData.mainColor),
          leading: Container(),
          actions: [
            Center(
              child: Text(
                widget.title,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'sans',
                  fontSize: 23,
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
                );
                Navigator.pop(context);
              }
            )
          ],
        ),
      ),
    );
  }
}