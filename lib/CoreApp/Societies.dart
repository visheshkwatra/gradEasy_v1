import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'BottomNav.dart';

class SocietiesPage extends StatefulWidget {
  final int userId;

  SocietiesPage({required this.userId});

  @override
  _SocietiesPageState createState() => _SocietiesPageState();
}

class _SocietiesPageState extends State<SocietiesPage> {
  int _currentIndex = 3; // Index of the currently selected tab
  List<Society> societies = [];

  // Function to handle tab selection
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the function to fetch societies when the widget is created
    _fetchSocieties();
  }

  // Function to fetch societies from the API
  Future<void> _fetchSocieties() async {
    final response = await http.get(Uri.parse('https://campusconnect.site/api/societies'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> data = json.decode(response.body);
      setState(() {
        societies = data.map((item) => Society.fromJson(item)).toList();
      });
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load societies');
    }
  }

  // Function to launch the mobile dialer with the specified contact number
  void _launchDialer(String contactNumber) async {
    bool? result = await FlutterPhoneDirectCaller.callNumber(contactNumber);
    if (result != null && result) {
      // The call was initiated successfully
      print('Call initiated successfully');
    } else {
      throw 'Could not launch the dialer for $contactNumber';
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Societies',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 1.5,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: societies.length,
                    itemBuilder: (context, index) {
                      Society society = societies[index];
                      return Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: ExpansionTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              society.thumbnailUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                society.name,
                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                society.title,
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                'Audition Date: ${society.auditionDate}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Description:',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Text(
                                          society.details,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Contact Us:',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFF9C71E1), // Purple color
                                            textStyle: TextStyle(fontSize: 16),
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                          onPressed: () {
                                            // Launch the dialer when the "Contact Us" button is pressed
                                            _launchDialer(society.contactNumber);
                                          },
                                          child: Text(
                                            'Contact Us',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isBottomNavVisible: true,
        userId: widget.userId,
      ),
    );
  }
}

class Society {
  final String name;
  final String title;
  final String thumbnailUrl;
  final String details;
  final String contactNumber;
  final String auditionDate;

  Society({
    required this.name,
    required this.title,
    required this.thumbnailUrl,
    required this.details,
    required this.contactNumber,
    required this.auditionDate,
  });

  // Factory method to create a Society object from JSON data
  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      name: json['title'],
      title: json['name'],
      thumbnailUrl: json['society_image'],
      details: json['description'],
      contactNumber: json['contact_number'],
      auditionDate: json['audition_date'],
    );
  }
}
