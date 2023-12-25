import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Sample user profile data (replace with actual data)
  String profilePictureUrl = 'https://example.com/profile.jpg';
  String fullName = 'John Doe';
  String username = 'johndoe';
  String email = 'johndoe@example.com';
  String phoneNumber = '123-456-7890';
  String role = 'Student';
  String batch = 'Batch 2023';

  // Controllers for editing user information
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController batchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Edit Profile Picture (you can use ImagePicker to implement image selection)
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(profilePictureUrl),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement image selection logic here
              },
              child: Text('Edit Profile Picture'),
            ),
            SizedBox(height: 20),

            // Edit User Information
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: roleController,
              decoration: InputDecoration(labelText: 'Role'),
            ),
            TextField(
              controller: batchController,
              decoration: InputDecoration(labelText: 'Batch'),
            ),
            SizedBox(height: 20),

            // Save Changes Button
            ElevatedButton(
              onPressed: () {
                // Implement logic to save changes and update the user's profile
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
