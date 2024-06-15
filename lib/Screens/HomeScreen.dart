import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
    late User currentUser;
  List<DocumentSnapshot> userPosts = [];
    String? profileImageUrl;


  @override
  void initState() {
    super.initState();

 currentUser = FirebaseAuth.instance.currentUser!;
    // Retrieve user data from Firestore
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {

        });
      }
    });


        final storageRef = FirebaseStorage.instance.ref().child('user_images/${currentUser.uid}.jpg');
    storageRef.getDownloadURL().then((url) {
      setState(() {
        profileImageUrl = url;
      });
    });


    _fetchRandomUserPosts();
  }

  void _fetchRandomUserPosts() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('posts').get();
      setState(() {
        userPosts = snapshot.docs;
      });
    } catch (e) {
      print('Error fetching user posts: $e');
    }
  }

  DocumentSnapshot? _getRandomUserPost() {
    if (userPosts.isEmpty) return null; // Fix the typo here
    final Random random = Random();
    final int randomIndex = random.nextInt(userPosts.length);
    return userPosts[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
         
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        // Handle post tap, e.g., navigate to a detailed view.
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(8),
                            leading:   CircleAvatar(
                      radius: 20,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : Image.asset('assets/images/blackscreen.png').image,
                    ),
                           
                            subtitle: FutureBuilder(
                              future: FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState == ConnectionState.waiting) {
                                  return Text('');
                                }
                                if (userSnapshot.hasError || !userSnapshot.hasData) {
                                  return Text('');
                                }
                                final userData = userSnapshot.data;
                                final username = userData?['username'] ?? '';
                                return Text(username);
                             
                              },
                            ),
                          ),
                          Image.network(post['image_url']),
                          const SizedBox(height: 20),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.heart, color: Color.fromARGB(255, 255, 255, 255), size: 20), // Heart icon for like
                                  SizedBox(width: 4),
                                  Text('Like', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.solidComment, size: 20), // Comment icon
                                  SizedBox(width: 4),
                                  Text('Comment', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(FontAwesomeIcons.shareSquare, size: 20), // Share icon
                                  SizedBox(width: 4),
                                  Text('Share', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                                                     SizedBox(height: 20),

                           Text(
                              post['description'] ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          const SizedBox(height: 8),
                          const Divider(
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}