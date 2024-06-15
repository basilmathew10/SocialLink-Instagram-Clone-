import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media_app/Screens/ProfileScreen.dart';
import 'package:social_media_app/auth/register.dart';
import 'package:social_media_app/Screens/BaseScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
void initState() {
  super.initState();
  // Check if the user is already signed in after the current frame has finished building
  WidgetsBinding.instance.addPostFrameCallback((_) {
    checkCurrentUser();
  });
}


  Future<void> checkCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is already signed in, navigate to the home screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BaseScreen(title: ''),
        ),
      );
    }
  }

  Future<void> handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text;
      String password = passwordController.text;

      try {
        // Sign in with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, // Using the email field for authentication
          password: password,
        );

        if (userCredential.user != null) {
          // Successfully logged in
          // You can navigate to the home screen or perform any other actions here
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BaseScreen(title: ''),
            ),
          );
        } 
        else {
          // Handle login failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Please check your credentials.'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        // Handle login error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred during login.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Form(
              key: _formKey, // Assign the key to the Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    height: 150.0,
                    width: 80.0,
                    child: Image.asset('assets/images/instagram_logo.jpg'),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      filled: true,
                      isDense: true,
                    ),
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please Enter your Username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleLogin, // Call your login function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                    ),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 350),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
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
