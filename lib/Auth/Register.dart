
  import 'dart:io';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:social_media_app/auth/login.dart';

  class RegistrationScreen extends StatefulWidget {
    @override
    _RegistrationScreenState createState() => _RegistrationScreenState();
  }

  class _RegistrationScreenState extends State<RegistrationScreen> {
    File? selectedImage;
    TextEditingController _usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController bioController = TextEditingController();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Future<void> _registerUser() async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          // User registered successfully, store additional user data in Firestore
          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'username': _usernameController.text,
            'email': emailController.text,
            'bio': bioController.text,
          });

              if (selectedImage!= null) {
                // Upload the image to Firebase Storage
                String imagePath = 'user_images/${userCredential.user!.uid}.jpg';
                UploadTask uploadTask = FirebaseStorage.instance.ref().child(imagePath).putFile(selectedImage!);

                await uploadTask.whenComplete(() => null);
              }

          // Redirect to login or home screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else {
          // Handle registration failure
          // You can display an error message here
        }
      } catch (e) {
        print('Error: $e');
        // Handle registration error
        // You can display an error message here
      }
    }

    Future<void> _getImage() async {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image!= null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        
        body: SingleChildScrollView(
          child: Center(
            child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Container(
                    height: 150.0,
                    width: 80.0,
                    child: Image.asset('assets/images/instagram_logo.jpg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: _getImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.blue, width: 2.0),
                            ),
                            child: selectedImage != null
                                ? CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(selectedImage!),
                                  )
                                : Icon(
                                    Icons.camera_alt,
                                    size: 60,
                                    color: Colors.blue,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your Name',
                  filled: true,
                  isDense: true,
                ),
                controller: _usernameController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
  validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Enter your Name';
                              }
                              return null;
                            },  
              ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:  TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your Email',
                  filled: true,
                  isDense: true,
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                        validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Enter your email';
                              }
                              return null;
                            },  
              ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  filled: true,
                  isDense: true,
                ),
                obscureText: true,
                controller: passwordController,
                validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Enter your Password';
                              }
                              return null;
                            },          
                              ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your Bio',
                  filled: true,
                  isDense: true,
                ),
                controller: bioController,
                validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please Enter your Bio';
                              }
                              return null;
                            },          
                              ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Perform registration logic with the entered data
                          _registerUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 120),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 190),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          ' Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      );
    }
  }













































  // class Register extends StatefulWidget {
  //   const Register({super.key});

  //   @override
  //   State<Register> createState() => _RegisterState();
  // }

  // class _RegisterState extends State<Register> {
  //     final GlobalKey<FormState> _key = GlobalKey<FormState>();
  //    late bool _obscurePassword;
  //   late bool _autovalidate;
  //    TextEditingController nameController= TextEditingController();
  //    TextEditingController phoneController= TextEditingController();
  //    TextEditingController emailController= TextEditingController();
  //    TextEditingController passwordController= TextEditingController();

  //    bool name_validate=false;
  //    bool phone_validate=false;
  //    bool email_validate=false;
  //    bool password_validate=false;

  //    @override
  //  void dispose() {
  //   super.initState();
  //     _obscurePassword = true;
  //     _autovalidate = false;
  //     nameController.dispose();
  //     phoneController.dispose();
  //     emailController.dispose();
  //     passwordController.dispose();

  //     super.dispose();
  //  }
  //   @override
  //  Widget build(BuildContext context) {
  //        child: SafeArea(minimum: EdgeInsets.all(16),
  //      child: Text(''),
  //  );
  //     return Scaffold(
      
  //       backgroundColor: Colors.white,
  //       body: 
  //       ListView(
  //         padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
  //         children: [
  //           SizedBox(height: MediaQuery.of(context).size.height / 5),
  //           Container(
  //             height: 150.0,
  //             width: 80.0,
  //             child:
  //             //  Image.network(
  //             //   'https://developerkpkaushal.netlify.app/4j6Ya2k.jpg',
  //             // ),
  //             Image.asset(
  //               'social_media_app/assets/images/instagram_logo.png'
  //               ),
  //           ),
  //           SizedBox(height: 40.0),
  //           Center(
  //             child: _buildRegForm(), 
  //           ),
  //           SizedBox(height: 10.0),
              
  //           TextButton(
  //                 onPressed: () async{
                    
  //                     setState(() {
  //                       nameController.text.isEmpty ? name_validate = true : name_validate = false;
  //                       phoneController.text.isEmpty ? phone_validate = true : phone_validate = false;
  //                       emailController.text.isEmpty ? email_validate = true : email_validate = false;
  //                       passwordController.text.isEmpty ? password_validate = true : password_validate = false;

  //                     });
  //                      final bool isvalid= _key.currentState!.validate();
  //                   if(isvalid){
  //                     print('form is valid');
  //                     _key.currentState!.save();
  //                    String name=nameController.text; 
  //                    String phone=phoneController.text; 
  //                    String email=emailController.text; 
  //                    String password=passwordController.text;   

  //                     print("name ="+name);
  //                     print("phone ="+phone);
  //                    print("email ="+email);
  //                    print("password ="+password);
  // // registration(name, phone, email, password);
  //                      }
  //                 },
            

  //                 //  Navigator.push(
  //                 //         context,
  //                 //         MaterialPageRoute (builder: (context) =>
  //                 //                 LoginPage(title: 'Login Page',)));
  //                 //           },
  //                 child: const Text('Sign up'),
  //     style: TextButton.styleFrom(
  //       primary: Colors.white,
  //       backgroundColor: Color.fromARGB(255, 1, 4, 36),
  //       textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
  //     ),
  //               ),

  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text('Already have an account?'),
  //               SizedBox(width: 5.0),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context).push(
  //                     CupertinoPageRoute(
  //                       builder: (_) => Login(),
  //                     ),
  //                   );
  //                 },
  //                 child: Text(
  //                   'Login',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Theme.of(context).colorScheme.secondary,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //  Widget _buildRegForm() {

  //   return Form(
        
  //        child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //            children: <Widget>[

  //              TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Enter your Name',
  //                 filled: true,
  //                 isDense: true,
  //               ),
  //               controller: nameController,
  //               keyboardType: TextInputType.emailAddress,
  //               autocorrect: false,
  //                validator: (val) => _validateRequired(val!, 'Name'),

  //             ),

  //               TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Enter your Email',
  //                 filled: true,
  //                 isDense: true,
  //               ),
  //               controller: emailController,
  //               keyboardType: TextInputType.emailAddress,
  //               autocorrect: false,
  //                validator: (val) => _validateRequired(val!, 'Email'),

  //             ),
  //               TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Enter your Phone No',
  //                 filled: true,
  //                 isDense: true,
  //               ),
  //               controller: phoneController,
  //               keyboardType: TextInputType.emailAddress,
  //               autocorrect: false,
  //                validator: (val) => _validateRequired(val!, 'Phone no'),

  //             ),
              
  //              TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Enter your Password',
  //                 filled: true,
  //                 isDense: true,
  //               ),
  //               obscureText: _obscurePassword,
  //               controller: passwordController,
  //               validator: (val) => _validateRequired(val!, 'Password'),
  //             ),
  //             SizedBox(
  //               height: 16,
  //             ),
  //            ]
  //        ),
  // );
  //    }

  // String? _validateRequired(String val, fieldName) {
  //     if (val == null ||  val == '') {
  //       return '$fieldName is required';
  //     }
      
  //     return null;
  //   }
  //    String? _validateEmail(String value) {
  //     if (value == null || value == '') {
  //       return 'Email is required';
  //     }
    

  //     var regex;
  //     if (!regex.hasMatch(value)) {
  //       return 'Enter valid username';
  //     }
  //     return null;
  //   }
  //   void _validateFormAndLogin() {
  //     // Get form state from the global key
  //     var formState = _key.currentState;

  //     // check if form is valid
  //     if (formState!.validate()) {
  //       print('Form is valid');
  //     } else {
  //       // show validation errors
  //       // setState forces our [State] to rebuild
  //       setState(() {
  //         _autovalidate = true;
  //       });
  //     }
  //   }
  // }