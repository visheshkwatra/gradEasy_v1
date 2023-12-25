import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'BottomNav.dart';


class EventsPage extends StatefulWidget {
  final int userId;

  EventsPage({required this.userId});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _currentIndex = 3; // Index of the currently selected tab
  List<Event> events = [];

  // Function to handle tab selection
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the function to fetch events when the widget is created
    _fetchEvents();
  }

  // Function to fetch events from the API
  Future<void> _fetchEvents() async {
    final response = await http.get(Uri.parse('https://campusconnect.site/api/events'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      List<dynamic> data = json.decode(response.body);
      setState(() {
        events = data.map((item) => Event.fromJson(item)).toList();
      });
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load events');
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
                SizedBox(height: 40),
                Text(
                  'Events',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      Event event = events[index];
                      return Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: ExpansionTile(
                          leading: Image.network(event.eventImageUrl),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                              Text(
                                'Event Date: ${event.eventDate}',
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
                                          event.description,
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
                                            backgroundColor: Color(0xFF9C71E1), // Purple color
                                            textStyle: TextStyle(fontSize: 18),
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                          onPressed: () {
                                            // Launch the dialer when the "Contact Us" button is pressed
                                            _launchDialer(event.contactNumber);
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

class Event {
  final String title;
  final String eventDate;
  final String eventImageUrl;
  final String description;
  final String contactNumber;

  Event({
    required this.title,
    required this.eventDate,
    required this.eventImageUrl,
    required this.description,
    required this.contactNumber,
  });

  // Factory method to create an Event object from JSON data
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      eventDate: json['event_date'],
      eventImageUrl: json['event_image'],
      description: json['description'],
      contactNumber: json['contact_number'],
    );
  }
}
