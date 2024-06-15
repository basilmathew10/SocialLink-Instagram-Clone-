import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/auth/login.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  String? username;
  String? bio;
  String? profileImageUrl;
  int followersCount = 0; // Add your logic to get followers count
  int followingCount = 0; // Add your logic to get following count
  List<String> userPosts = []; // List to store post image URLs

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    // Retrieve user data from Firestore
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          username = documentSnapshot['username'];
          bio = documentSnapshot['bio'];
        });
      }
    });

    // Retrieve the user's profile image from Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('user_images/${currentUser.uid}.jpg');
    storageRef.getDownloadURL().then((url) {
      setState(() {
        profileImageUrl = url;
      });
    });

    // Fetch user's posts
    _fetchUserPosts();
  }

  void _fetchUserPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .where('user_id', isEqualTo: currentUser.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        List<String> postUrls = [];
        querySnapshot.docs.forEach((doc) {
          postUrls.add(doc['image_url']);
        });
        setState(() {
          userPosts = postUrls;
        });
      }
    });
  }

  void _editProfile() {
    // Implement your "Edit Profile" logic here
    // You can navigate to the edit profile screen or show a dialog for editing.
    // Replace EditProfileScreen with your own screen.
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => EditProfileScreen(),
    // ));
  }
  void _signout() {
    // Implement your "Edit Profile" logic here
    // You can navigate to the edit profile screen or show a dialog for editing.
    // Replace EditProfileScreen with your own screen.
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : Image.asset('assets/images/blackscreen.png').image,
                    ),
                    Column(
                      children: [
                        Text(
                          userPosts.length.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Posts',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          followersCount.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          followingCount.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Following',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
            Container(
  margin: const EdgeInsets.only(right: 280),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        username ?? '', // Check for null
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        bio ?? '', // Check for null
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    ],
  ),
),
                        SizedBox(height: 15),

                Row(
                  children: [
                        SizedBox(width: 50),

                    ElevatedButton(
                      onPressed: _editProfile, // Call the _editProfile function
                      child: Text('Edit Profile'),
                    ),
               SizedBox(width: 85),

                ElevatedButton(
                  onPressed: _signout, // Call the _editProfile function
                  child: Text('   SignOut  '),
                ),
                ],
               ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // User's Posts
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
              ),
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                return Image.network(
                  userPosts[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
