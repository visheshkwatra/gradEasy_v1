import 'package:flutter/material.dart';
import 'package:gradeasy_v1/CoreApp/BottomNav.dart';
import 'package:gradeasy_v1/CoreApp/Cafeterias.dart';
import 'package:gradeasy_v1/CoreApp/Home.dart';
import 'package:provider/provider.dart';
import 'package:gradeasy_v1/Onboarding/AuthProvider.dart';
import 'package:gradeasy_v1/Onboarding/Signup.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Images/background_white.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Add Image above the email and password fields
                    Image.asset(
                      'Images/Campus_Connect-removebg.png', // Replace with your image path
                      height: 100,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email), // Icon for email
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // You can add more email validation logic if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock), // Icon for password
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        // You can add more password validation logic if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF9C71E1), // Purple color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final email = emailController.text;
                          final password = passwordController.text;
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);

                          await authProvider.login(email, password);

                          if (authProvider.isLoggedIn) {
                            int? userId = authProvider.getUserId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CafeteriasPage(userId: userId!),
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Authorization failed, try again or Register',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Color(0xFF9C71E1), // Purple color
                        side: BorderSide(color: Color(0xFF9C71E1)), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Register as a new user',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
