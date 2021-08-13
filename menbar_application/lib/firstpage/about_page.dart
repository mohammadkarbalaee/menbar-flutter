import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_flutter_app_icons.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff607d8d),
        leading: Container(),
        actions: [
          Center(
            child: Text(
                'درباره منبر',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'sans',
                fontSize: 23,
              ),
            ),
          ),
          SizedBox(width: 5,),
          Container(
            child: ButtonTheme(
              height: 50,
              minWidth:30,
              splashColor: Colors.grey,
              child: RaisedButton(
                elevation: 0,
                color: Color(0xffffff),
                onPressed: () => Navigator.pop(context),
                child: Icon(Icons.arrow_forward,color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'منبر را برای دنیای نو درست کرده ایم که بسیار نیازمند شنیدن از سعادت است و شنیدن راه رسیدن به سعادت, شاید شیرین تر از پیمودن آن باشد.',
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
              'سخنرانی های بیشتر',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: 'sans',
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'نرم‌افزار را با تعداد محدودی سخنرانی آماده کرده ایم و میخواهیم از شما بشنویم که کدام سخنرانی ها را بیشتر میخواهید که اضافه شوند. برای این کار از بخش نظرهای بازار استفاده کنید',
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
                          'ثبت نظر',
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
      ),
      bottomSheet: Row(
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
                      'حریم خصوصی و امنیت',
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
      ),
    );
  }
}
