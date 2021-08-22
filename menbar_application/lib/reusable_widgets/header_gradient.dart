import 'package:flutter/material.dart';

class HeaderGradient extends StatelessWidget {
  var oratorName;
  HeaderGradient(this.oratorName);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black,
                ]
            )
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Container(
            height: 50,
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      oratorName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}