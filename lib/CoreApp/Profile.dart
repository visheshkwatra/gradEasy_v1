import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'BottomNav.dart';
import 'package:gradeasy_v1/Onboarding/login.dart';
import 'package:gradeasy_v1/Onboarding/AuthProvider.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String webViewUrl;
  int _currentIndex = 4;

  @override
  void initState() {
    super.initState();
    webViewUrl = 'https://campusconnect.site/myAccount?id=${widget.userId}';
    //webViewUrl = 'https://campusconnect.site/myAccount?id=2';
    print('WebView URL: $webViewUrl'); // Print the URL
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _showPasswordDialog(BuildContext context) async {
    String password = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call the logout method with the entered password
                await Provider.of<AuthProvider>(context, listen: false)
                    .logout(password);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF9C71E1),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Show a password dialog when the logout button is pressed
              await _showPasswordDialog(context);
            },
          ),
        ],
      ),
      body: WebView(
        initialUrl: webViewUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isBottomNavVisible: true,
        userId: widget.userId, // Use widget.userId here
      ),
    );
  }
}
