import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/managers/hive_manager.dart';
import 'package:menbar_application/reusable_widgets/header_gradient.dart';

import 'orator_instance_widget.dart';

class Orators extends StatelessWidget {

  Future<List> _getData() async {
    List orators = await HiveManager.getAllOrators();
    return orators;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            bool isNotReady = snapshot.data == null;

            return isNotReady ? LoadingWidget() : ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context,index) {
                return GestureDetector(
                    child: OratorCardWidget(
                      snapshot.data[index]['image'],
                      snapshot.data[index]['title'],
                    ),
                    onTap: (){
                      navigateToInstance(
                          context:context,
                          imageUrl: snapshot.data[index]['image'],
                          title: snapshot.data[index]['title'],
                          id: snapshot.data[index]['id']
                      );
                    }
                );
              },
            );
          },
        )
    );
  }
}

navigateToInstance({context,imageUrl,title,id}) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) =>
          OratorInstance(
            imageUrl,
            title,
            id,
          )
    )
  );
}

class OratorCardWidget extends StatelessWidget {
  var imageUlr;
  var oratorName;

  OratorCardWidget(this.imageUlr,this.oratorName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        elevation: 10,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            BackgroundImage(imageUlr),
            HeaderGradient(oratorName,''),
          ],
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '',
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  var imageUrl;

  BackgroundImage(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4,bottom: 4),
      child: Card(
        elevation: 10,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 210,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            fadeInDuration:Duration(milliseconds: 500),
            fadeInCurve:Curves.easeInExpo,
          ),
        ),
      ),
    );
  }
}