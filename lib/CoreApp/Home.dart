import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'BottomNav.dart';


class HomeScreen extends StatefulWidget {
  final int userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Index of the currently selected tab

  // Function to handle tab selection
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<List<Timesheet>> _fetchTimesheets() async {
    List<Timesheet> timesheets = [];

    for (int day = 1; day <= 7; day++) {
      try {
        final response = await http.get(
          Uri.parse('https://campusconnect.site/api/timesheets?user=${widget.userId}&day=$day'),
        );

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            Map<String, dynamic> firstPeriod = data.first;
            timesheets.add(Timesheet.fromJson(firstPeriod));
          }
        } else {
          throw Exception('Failed to load timesheets - ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching timesheets: $error');
      }
    }

    return timesheets;
  }

  Future<void> _postAttendance(int period, bool isPresent) async {
    try {
      final response = await http.post(
        Uri.parse('https://campusconnect.site/api/attendances/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user': widget.userId,
          'period': period,
          'is_present': isPresent,
        }),
      );

      if (response.statusCode == 201) {
        print('Attendance posted successfully');
      } else {
        throw Exception('Failed to post attendance - ${response.statusCode}');
      }
    } catch (error) {
      print('Error posting attendance: $error');
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Your Timesheet Widget
                Stack(
                  children: [
                    // Background Image
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('Images/background1.jpg'), // Replace with your image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Your Timesheet Widget
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8), // Semi-transparent white background
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Your Timesheet',
                              style: TextStyle(
                                color: Color(0xFF9C71E1), // Custom text color
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1.5, // Adjust the letter spacing for a stylish look
                              ),
                            ),
                          ),
                          // Display your timesheet data using a ListView
                          FutureBuilder<List<Timesheet>>(
                            future: _fetchTimesheets(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Loading state
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}'); // Error state
                              } else {
                                // Display your timesheet data using a ListView
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    Timesheet timesheet = snapshot.data![index];
                                    return ListTile(
                                      title: Text(
                                        'Day: ${timesheet.day}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Period: ${timesheet.period}',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            'From: ${timesheet.fromHour} - To: ${timesheet.toHour}',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          // Add a drop-down for attendance here
                                          DropdownButton<bool>(
                                            value: false, // Change this value based on attendance status
                                            onChanged: (value) {
                                              // Implement your logic here to post attendance
                                              _postAttendance(timesheet.id, value ?? false);
                                            },
                                            items: [
                                              DropdownMenuItem<bool>(
                                                value: true,
                                                child: Text(
                                                  'Present',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ),
                                              DropdownMenuItem<bool>(
                                                value: false,
                                                child: Text(
                                                  'Absent',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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

class Timesheet {
  final int id;
  final int user;
  final int day;
  final String period;
  final String fromHour;
  final String toHour;
  final bool isClosed;

  Timesheet({
    required this.id,
    required this.user,
    required this.day,
    required this.period,
    required this.fromHour,
    required this.toHour,
    required this.isClosed,
  });

  factory Timesheet.fromJson(Map<String, dynamic> json) {
    return Timesheet(
      id: json['id'],
      user: json['user'],
      day: json['day'],
      period: json['period'],
      fromHour: json['from_hour'],
      toHour: json['to_hour'],
      isClosed: json['is_closed'],
    );
  }
}
