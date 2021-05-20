import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/home.dart';
// import 'package:flutter_shared_pref_demo/home.dart';
import 'package:flutter_shared_pref_demo/login_page.dart';
import 'package:flutter_shared_pref_demo/screens/new_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  String newUserEmail;

  @override
  void initState() {
    getUserData().whenComplete(() async {
      Timer(Duration(seconds: 3),
          () => newUserEmail != null ? gotoHome() : gotoLogin());
    });
    super.initState();
  }

  // _intiTimer() async {
  //   Timer(Duration(seconds: 3), userEmail == null ? gotoLogin() : gotoHome());
  // }

  Future getUserData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainEmail = sharedPreferences.getString('mail');
    setState(() {
      newUserEmail = obtainEmail;
    });
    print('user email is $newUserEmail');
  }

  gotoLogin() async {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        ),
        (Route<dynamic> route) => false);
  }

  gotoHome() async {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.all(16),
            child: FlutterLogo()),
      ),
    );
  }
}
