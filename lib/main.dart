import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/Auth/Login.dart';
import 'package:social_media_app/Auth/Register.dart';
import 'package:social_media_app/Provider/UserProvider.dart';
import 'package:social_media_app/Screens/HomeScreen.dart';
import 'package:social_media_app/Screens/ProfileScreen.dart';
import 'package:social_media_app/firebase_options.dart';
import 'package:social_media_app/Screens/BaseScreen.dart';
import 'package:social_media_app/Screens/splashscreen.dart';
import 'package:social_media_app/hchasg.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
    await FirebaseAppCheck.instance.activate();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    return 
      // MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(create: (_) => userProvider(),),
      //   ],
      // child:
     MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'INSTAGRAM',
      theme: ThemeData.dark(),
   
      home:  SplashScreen(),
    //  ),
    );
  }
}