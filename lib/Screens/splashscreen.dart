import 'dart:async';
import 'package:flutter/material.dart';
import 'package:social_media_app/Screens/HomeScreen.dart';
import 'package:social_media_app/auth/login.dart';
import 'package:social_media_app/Screens/BaseScreen.dart';

// Replace 'YourAppLogo.png' with your actual app logo image path
const String splashImage = 'assets/images/instalogo.png';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigating to the home screen after 3 seconds
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => BaseScreen(title: '',), // Replace HomeScreen() with your actual home screen
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Change background color as needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              splashImage,
              width: 150.0, // Adjust width as needed
              height: 150.0, // Adjust height as needed
            ),
            SizedBox(height: 20.0),
            // CircularProgressIndicator(), // Loading indicator
          ],
        ),
      ),
    );
  }
}
