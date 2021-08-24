import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/collections/download_button.dart';
import 'package:menbar_application/reusable_widgets/header_button.dart';
import 'package:menbar_application/reusable_widgets/header_gradient.dart';
import 'package:menbar_application/reusable_widgets/shared_data.dart';

class PlayerPage extends StatefulWidget {
  var title;
  var context;
  var url;
  var imageUrl;
  var orator;
  var speechTitle;

  PlayerPage(this.title,this.context,this.url,this.imageUrl,this.orator,this.speechTitle);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(SharedData.mainColor),
        body: Container(
          child: Column(
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
              )
            ],
          ),
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
                  widget.speechTitle
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