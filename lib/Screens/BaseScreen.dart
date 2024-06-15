
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Screens/HomeScreen.dart';
import 'package:social_media_app/Screens/PostScreen.dart';
import 'package:social_media_app/Screens/ProfileScreen.dart';
import 'package:social_media_app/hchasg.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key, required this.title});

  final String title;

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
    late User currentUser;
    String? username;
  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    // Retrieve user data from Firestore
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          username = documentSnapshot['username'];
        });
      }
    });
  }
  int _selectedIndex = 0;
 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
   static  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ProfileScreen(),
    AddPostScreen(),   
    ProfileScreen(),
    ProfileScreen(),

  ];
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
                   backgroundColor: Colors.black,
        title:  Text(
                   ' ${username ??""} ', // Check for null
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        // Container(
        //           width: 140.0,
        //           child: Image.asset('assets/images/instagramwhite.jpg'),
        //         ),
      ),
   
      body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),

        
      ),
         bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color.fromARGB(255, 255, 255, 255),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
          items: [
          BottomNavigationBarItem( 
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
            
          ),
        ],
        currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }
       ),
    );
  }
}
