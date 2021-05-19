import 'dart:async';

import 'package:flutter/material.dart';
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
          () => newUserEmail == null ? gotoLogin() : gotoHome());
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

  // getUser() async {
  //   try {
  //     sharedPreferences = await SharedPreferences.getInstance();
  //     if (sharedPreferences == null) {
  //       gotoLogin();
  //     } else {
  //       var getEmail = sharedPreferences.getString('email');
  //       setState(() {
  //         userEmail = getEmail;
  //       });
  //       print(userEmail);
  //     }
  //   } catch (e) {
  //     print(e);
  //     gotoLogin();
  //   }
  // }

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
          builder: (BuildContext context) => NotesHome(),
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
