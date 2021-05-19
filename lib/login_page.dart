import 'package:flutter/material.dart';
import 'package:flutter_shared_pref_demo/screens/new_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailfn = FocusNode();
  FocusNode passwordfn = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login Page'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: emailController,
                focusNode: emailfn,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 14, 20, 14),
                  hintText: "Enter Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                )),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              focusNode: passwordfn,
              obscureText: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 14, 20, 14),
                hintText: "Enter Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              ),
            ),
            SizedBox(height: 46),
            MaterialButton(
              color: Colors.green,
              minWidth: 100,
              // height: size.height * 0.05,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.all(8),
              textColor: Colors.white,
              onPressed: () {
                onLogin();
              },
              child: Text(
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onLogin() {
    if (emailController.text == "") {
      print('Please Enter Email');
    } else if (passwordController.text == "") {
      print('Please Enter Password');
    } else {
      signInCall();
    }
  }

  static bool isValidEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  signInCall() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('mail', emailController.text.toString());
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => NotesHome()), (route) => false);
  }
}
