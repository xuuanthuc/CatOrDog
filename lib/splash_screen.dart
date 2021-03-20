import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home_screen.dart';
class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      photoSize: 200,

      navigateAfterSeconds: HomeScreen(),
      image: Image.asset('assets/images/dogcat.png', width: 200, height: 200,),
    );
  }
}
