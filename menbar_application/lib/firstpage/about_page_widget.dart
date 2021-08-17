import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menbar_application/reusable_widgets/header_back_button.dart';
import 'my_flutter_app_icons.dart';

List texts = [
  'درباره منبر',
  'منبر را برای دنیای نو درست کرده ایم که بسیار نیازمند شنیدن از سعادت است و شنیدن راه رسیدن به سعادت, شاید شیرین تر از پیمودن آن باشد.',
  'سخنرانی های بیشتر',
  'نرم‌افزار را با تعداد محدودی سخنرانی آماده کرده ایم و میخواهیم از شما بشنویم که کدام سخنرانی ها را بیشتر میخواهید که اضافه شوند. برای این کار از بخش نظرهای بازار استفاده کنید',
  'ثبت نظر',
  'حریم خصوصی و امنیت',
];

class AboutPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff607d8d),
        leading: Container(),
        actions: [
          Center(
            child: Text(
              texts[0],
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'sans',
                fontSize: 23,
              ),
            ),
          ),
          SizedBox(width: 5,),
          HeaderBackButton(
            icon: Icon(Icons.arrow_forward,color: Colors.white,),
            onPress: () => Navigator.pop(context),
          )
        ],
      ),
      body: AboutBody(),
      bottomSheet:SecurityFooter(),
    );
  }
}

class SecurityFooter extends StatelessWidget {
  const SecurityFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          child: ButtonTheme(
            height: 50,
            minWidth:30,
            splashColor: Colors.grey,
            child: RaisedButton(
              elevation: 0,
              color: Color(0xffffff),
              onPressed: () {},
              child: Row(
                children: [
                  Text(
                    texts[5],
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'sans',
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.security_outlined,color: Colors.black,size: 18,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AboutBody extends StatelessWidget {
  const AboutBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            texts[1],
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'sans',
              fontSize: 19,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            texts[2],
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'sans',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 10,),
          Text(
            texts[3],
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'sans',
              fontSize: 19,
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Container(
                width: 150,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        texts[4],
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          fontFamily: 'sans',
                        ),
                      ),
                      SizedBox(width: 10,),
                      Icon(MyFlutterApp.bazaar_icon,size: 30,),
                    ],
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff607d80),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}