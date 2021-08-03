import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OratorInstance extends StatelessWidget {

  var image;
  var name;
  OratorInstance(this.image,this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: true,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xff607d8d),
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    name,
                    textDirection: TextDirection.rtl,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'sans'
                    ),
                  ),
                ),
              ),

              background: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(image),
                        ),
                      )
                  ),
                  Positioned(
                    child: PhysicalModel(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.black12,
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          height: 60,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Text(''),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              HeaderButton(
                icon: Icon(Icons.arrow_forward,color: Colors.white,),
                onPress: () => Navigator.pop(context),
              ),
            ],
          ),
          SliverToBoxAdapter(

          )
        ],
      )
    );
  }
}


class HeaderButton extends StatelessWidget {
  var icon;
  var onPress;

  HeaderButton({this.icon,this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 50,
        minWidth:30,
        splashColor: Colors.grey,
        child: RaisedButton(
          elevation: 0,
          color: Color(0xffffff),
          onPressed: onPress,
          child: icon,
        ),
      ),
    );
  }
}
