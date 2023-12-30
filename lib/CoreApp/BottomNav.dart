import 'package:flutter/material.dart';
import 'package:gradeasy_v1/CoreApp/Cafeterias.dart';
import 'package:gradeasy_v1/CoreApp/Home.dart';
import 'package:gradeasy_v1/CoreApp/Events.dart';
import 'package:gradeasy_v1/CoreApp/Societies.dart';
import 'package:gradeasy_v1/CoreApp/Profile.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isBottomNavVisible;
  final int userId;

  BottomNav({required this.currentIndex, required this.onTap, required this.isBottomNavVisible, required this.userId});

  @override
  Widget build(BuildContext context) {
    if (!isBottomNavVisible) {
      // If the navigation bar is not visible, return an empty Container
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF9C71E1), // Set background color to purple
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            // Only trigger the onTap callback and navigate if the tapped index is different from the current index
            onTap(index);

            // Navigate to the corresponding page based on the tapped index
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(userId: userId)),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EventsPage(userId: userId)),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CafeteriasPage(userId: userId)),
              );
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SocietiesPage(userId: userId)),
              );
            } else if (index == 4) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(userId: userId)),
              );
            }
          }
        },
        backgroundColor: Colors.transparent, // Make the background transparent
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        selectedFontSize: 16.0,
        unselectedFontSize: 16.0,
        selectedLabelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe),
            label: 'Cafeterias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Societies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
