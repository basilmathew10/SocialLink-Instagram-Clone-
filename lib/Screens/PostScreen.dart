import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddPostScreen extends StatefulWidget {


  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _image;
  String? _description;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _errorText; 
   final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;

   Future<String> uploadPost() async {
        // if (_formKey.currentState?.validate()?? false) {
      setState(() {
        isLoading = true;
        _errorText = null;
      });
      final user = _auth.currentUser;
      if (user != null && _image != null) {
        try {
          final imageRef = _storage.ref().child('images/${user.uid}/${DateTime.now().toString()}.jpg');
          await imageRef.putFile(_image!);
          final imageUrl = await imageRef.getDownloadURL();
          await _firestore.collection('posts').add({
            'user_id': user.uid,
            'description': _description,
            'image_url': imageUrl,
            'timestamp': FieldValue.serverTimestamp(),
          });
          setState(() {
            isLoading = false;
            _image = null;
            _description = null;
          });
        } catch (e) {
          setState(() {
            isLoading = false;
            _errorText = 'Error uploading post: $e';
          });
        }
      }
    // }
    return "Success";
  }

  Future<void> getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> getImageFromCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _selectImage(BuildContext parentContext) async {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                await getImageFromCamera();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from Gallery'),
              onPressed: () async {
                await getImageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> postImage() async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await uploadPost();
      if (res == "success") {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Posted!'),
          ),
        );

        clearImage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
          ),
        );
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
        ),
      );
    }
  }

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _descriptionController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _selectImage(context);
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromARGB(54, 255, 255, 255),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select post"),
                        SizedBox(width: 10),
                        Icon(Icons.upload),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: Text('Post to'),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: postImage,
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
                    child: Column(
              children: <Widget>[
                isLoading
                    ? LinearProgressIndicator()
                    : SizedBox(height: 0.0),
                Divider(),
                Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        
                        SizedBox(
                          height: 420.0,
                          width: 415.0,
                          child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                  image: FileImage(_image!),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: "Write a caption...",
                              border: InputBorder.none,
                            ),
                            maxLines: 8,
                          ),
                        ),
                      ],
                    ),
                Divider(),
              ],
            ),
         ),
      );
  }
}













// class AddPostScreen extends StatefulWidget {
  

//   @override
//   _AddPostScreenState createState() => _AddPostScreenState();
// }

// class _AddPostScreenState extends State<AddPostScreen> {
//  File? _image;
//   String? _description;
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   bool _isLoading = false;
//   String? _errorText;  
//   final TextEditingController _descriptionController = TextEditingController();
//   bool isLoading = false;


//   Future<String> _uploadPost() async {
//     if (_formKey.currentState?.validate()?? false)  {
//       setState(() {
//         _isLoading = true;
//         _errorText = null;
//       });
//       final user = _auth.currentUser;
//       if (user != null && _image != null) {
//         try {
//           final imageRef = _storage.ref().child('images/${user.uid}/${DateTime.now().toString()}.jpg');
//           await imageRef.putFile(_image!);
//           final imageUrl = await imageRef.getDownloadURL();
//           await _firestore.collection('posts').add({
//             'user_id': user.uid,
//             'description': _description,
//             'image_url': imageUrl,
//             'timestamp': FieldValue.serverTimestamp(),
//           });
//           setState(() {
//             _isLoading = false;
//             _image = null;
//             _description = null;
//           });
//         } catch (e) {
//           setState(() {
//             _isLoading = false;
//             _errorText = 'Error uploading post: $e';
//           });
//         }
//       }
//     }
//   throw "Validation failed"; // Throw error if validation fails
//   }



//   Future<void> getImageFromGallery() async {
//     var image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//       });
//     }
//   }

//   Future<void> getImageFromCamera() async {
//     var image = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//       });
//     }
//   }

//   void _selectImage(BuildContext parentContext) async {
//     showDialog(
//       context: parentContext,
//       builder: (BuildContext context) {
//         return SimpleDialog(
//           title: const Text('Create a Post'),
//           children: <Widget>[
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Take a photo'),
//               onPressed: () async {
//                 await getImageFromCamera();
//                 Navigator.pop(context);
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text('Choose from Gallery'),
//               onPressed: () async {
//                 await getImageFromGallery();
//                 Navigator.of(context).pop();
//               },
//             ),
//             SimpleDialogOption(
//               padding: const EdgeInsets.all(20),
//               child: const Text("Cancel"),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//  Future<void> postImage() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       String res = await _uploadPost();
//       if (res == "success") {
//         setState(() {
//           isLoading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Posted!'),
//           ),
//         );

//         clearImage();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(res),
//           ),
//         );
//       }
//     } catch (err) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(err.toString()),
//         ),
//       );
//     }
//   }



//   void clearImage() {
//     setState(() {
//       _image = null;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _descriptionController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _image == null
//         ? Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: InkWell(
//                 onTap: () {
//                   _selectImage(context);
//                 },
//                 child: Container(
//                   width: 200,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     color: Color.fromARGB(54, 255, 255, 255),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Select post"),
//                         SizedBox(width: 10),
//                         Icon(Icons.upload),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.black,
//               leading: IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: clearImage,
//               ),
//               title: Text('Post to'),
//               centerTitle: false,
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: postImage,
//                   child: Text(
//                     "Post",
//                     style: TextStyle(
//                       color: Colors.blueAccent,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16.0,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             body: SingleChildScrollView(
//                     child: Column(
//               children: <Widget>[
//                 isLoading
//                     ? LinearProgressIndicator()
//                     : SizedBox(height: 0.0),
//                 Divider(),
//                 Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
                        
//                         SizedBox(
//                           height: 420.0,
//                           width: 415.0,
//                           child: AspectRatio(
//                             aspectRatio: 487 / 451,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   fit: BoxFit.fill,
//                                   alignment: FractionalOffset.topCenter,
//                                   image: FileImage(_image!),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20,),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.3,
//                           child: TextField(
//                             controller: _descriptionController,
//                             decoration: InputDecoration(
//                               hintText: "Write a caption...",
//                               border: InputBorder.none,
//                             ),
//                             maxLines: 8,
//                           ),
//                         ),
//                       ],
//                     ),
//                 Divider(),
//               ],
//             ),
//          ),
//       );
//   }
// }

