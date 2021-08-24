import 'package:flutter/material.dart';

class HeaderGradient extends StatelessWidget {
  var oratorName;
  var speechName;

  HeaderGradient(this.oratorName,this.speechName);

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
            height: 70,
            width: 1000,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        speechName,
                        style: TextStyle(
                          fontSize: 22,
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
      ),
    );
  }
}