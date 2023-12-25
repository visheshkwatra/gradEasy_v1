import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController batchController = TextEditingController();

  String password = '';

  Future<void> registerUser(
      String firstname,
      String lastname,
      String email,
      String phone,
      String password,
      String role,
      int batch,
      BuildContext context,
      ) async {
    final url = Uri.parse('https://campusconnect.site/api/register/');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "email": email,
          "first_name": firstname,
          "last_name": lastname,
          "phone_number": phone,
          "password": password,
          "role": role,
          "batch": batch,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context);
        print('Registration successful');
      } else {
        Fluttertoast.showToast(
          msg: 'Registration failed: ${response.body} ---$email',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
        );
        print('Registration failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}---$email');
      }
    } catch (e) {
      print('Error registering user: $e');
    }
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Add an image at the top
                  Image.asset(
                    'Images/Campus_Connect-removebg.png', // Replace with your image path
                    height: 100,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: roleController,
                    decoration: InputDecoration(labelText: 'Role'),
                  ),
                  TextField(
                    controller: batchController,
                    decoration: InputDecoration(labelText: 'Batch'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF9C71E1), // Purple color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      final firstname = firstnameController.text;
                      final lastname = lastnameController.text;
                      final email = emailController.text;
                      final phone = phoneController.text;
                      final role = roleController.text;
                      final batch = int.tryParse(batchController.text) ?? 0;

                      registerUser(firstname, lastname, email, phone, password, role, batch, context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 75.0,
            left: 16.0,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

}
