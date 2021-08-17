import 'package:flutter/material.dart';

class YellowBookMarkButton extends StatefulWidget {
  var functionOnClick;
  var isBookmarked;

  YellowBookMarkButton(this.functionOnClick,this.isBookmarked);

  @override
  _YellowBookMarkButtonState createState() => _YellowBookMarkButtonState();
}

class _YellowBookMarkButtonState extends State<YellowBookMarkButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.functionOnClick();
      },
      child: widget.isBookmarked ? Icon(Icons.bookmark,color: Colors.white,size: 25,):
      Icon(Icons.bookmark_border,color: Colors.white,size: 25,),
      style: ElevatedButton.styleFrom(
        primary: Colors.yellow[500],
        elevation: 7,
        shape: CircleBorder(),
      ),
    );
  }
}


class BookmarkButton extends StatefulWidget {
  var functionOnClick;
  var isBookmarked;

  BookmarkButton(this.functionOnClick,this.isBookmarked);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
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
          // onPressed: (){},
          onPressed: () {
            widget.functionOnClick();
          },
          child: widget.isBookmarked ? Icon(Icons.bookmark,color: Colors.white,): Icon(Icons.bookmark_border,color: Colors.white,),
        ),
      ),
    );
  }
}