import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'BottomNav.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  final int userId;

  HomeScreen({required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0; // Index of the currently selected tab

  // Function to handle tab selection
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<List<Timesheet>> _fetchTimesheets() async {
    List<Timesheet> timesheets = [];

    // Get the current day of the week (1 for Monday, 2 for Tuesday, etc.)
    int currentDay = DateTime.now().weekday;

    for (int day = 1; day <= 7; day++) {
      try {
        final response = await http.get(
          Uri.parse('https://campusconnect.site/api/timesheets?user=${widget.userId}&day=${(currentDay + day - 1) % 7 + 1}'),
        );

        if (response.statusCode == 200) {
          List<dynamic> data = json.decode(response.body);
          if (data.isNotEmpty) {
            timesheets.addAll(data.map((json) => Timesheet.fromJson(json)).toList());
          }
        } else if (response.statusCode == 400) {
          // Show a toast for a specific condition
          Fluttertoast.showToast(
            msg: 'Attendance recorded or period inactive.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        } else {
          throw Exception('Failed to load timesheets - ${response.statusCode}');
        }
      } catch (error) {
        print('Error fetching timesheets: $error');
      }
    }

    return timesheets;
  }

  Future<void> _postAttendance(int periodId, bool isPresent) async {
    try {
      final response = await http.post(
        Uri.parse('https://campusconnect.site/api/attendances/'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'user': widget.userId,
          'period': periodId,
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
    super.build(context); // To maintain state when switching tabs

    return Scaffold(
      body: FutureBuilder<List<Timesheet>>(
        future: _fetchTimesheets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          } else {
            return _buildTimesheet(snapshot.data!);
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        isBottomNavVisible: true,
        userId: widget.userId,
      ),
    );
  }

  Widget _buildTimesheet(List<Timesheet> timesheets) {
    // Get the current day of the week (1 for Monday, 2 for Tuesday, etc.)
    int currentDay = DateTime.now().weekday;

    // Filter timesheets based on the current day
    List<Timesheet> filteredTimesheets = timesheets
        .where((timesheet) => timesheet.day == currentDay)
        .toList();

    if (filteredTimesheets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy, // You can replace this with a custom icon of your choice
              color: Colors.black,
              size: 48.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'No Lectures to attend today yet.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Please check again later.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );

    }

    return Stack(
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
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 68.0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Heading "Timesheet"
                Center(
                  child: Text(
                    'Your Timesheet',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0), // Adjust spacing as needed
                // Your Timesheet Widget

                // Display your timesheet data using a ListView
                Wrap(
                  spacing: 16.0, // Adjust the spacing between tiles
                  runSpacing: 16.0, // Adjust the run spacing between rows
                  children: filteredTimesheets.map((timesheet) {
                    return _buildTimesheetTile(timesheet);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimesheetTile(Timesheet timesheet) {
    double cardWidth = MediaQuery.of(context).size.width / 2 - 24;

    return Container(
      width: cardWidth,
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipPath(
          clipper: CustomClipperShape(),
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xB7B7BDFF),
                        width: 3.0,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        timesheet.image.isNotEmpty
                            ? timesheet.image
                            : 'https://campusconnect.site/static/img/teacher.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Day: ${timesheet.day}',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Period: ${timesheet.period}',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'From: ${timesheet.fromHour} - To: ${timesheet.toHour}',
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  // Conditionally show either the status or the dropdown
                  if (timesheet.isPresent != null) // Show status if Present or Absent is explicitly set
                    Text(
                      timesheet.isPresent ? 'Status: Present' : 'Status: Absent',
                      style: TextStyle(
                        color: timesheet.isPresent ? Colors.green : Colors.red,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else // Show dropdown for marking attendance if is_present is empty
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<String>(
                        value: timesheet.status.isEmpty ? null : timesheet.status,
                        onChanged: (value) {
                          _postAttendance(timesheet.id, value == 'Present');
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Present',
                            child: Text(
                              'Present',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Absent',
                            child: Text(
                              'Absent',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
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

class CustomClipperShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0); // Move to top-right corner
    path.quadraticBezierTo(size.width, 0.0, size.width - 20.0, 20.0); // Add curve
    path.lineTo(size.width - 20.0, 20.0); // Move to the new point after the curve
    path.lineTo(size.width - 20.0, size.height); // Move to the bottom-right corner
    path.lineTo(0.0, size.height); // Move to the bottom-left corner
    path.close(); // Close the path
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // This clipper doesn't depend on any external variables
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
  final String image;
  final String status;
  final bool isPresent; // New property

  Timesheet({
    required this.id,
    required this.user,
    required this.day,
    required this.period,
    required this.fromHour,
    required this.toHour,
    required this.isClosed,
    required this.image,
    required this.status,
    required this.isPresent, // Initialize the new property
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
      image: json['image'] ?? '',
      status: json['status'] ?? '',
      isPresent: json['is_present'] ?? false, // Initialize with false if 'is_present' is null
    );
  }
}
