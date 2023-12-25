import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gradeasy_v1/Onboarding/Splash.dart';
import 'package:flutter/material.dart';
import 'package:gradeasy_v1/CoreApp/Home.dart'; // Import the HomeScreen
import 'package:gradeasy_v1/CoreApp/Events.dart'; // Import the EventsPage
import 'Onboarding/AuthProvider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Onboarding/login.dart';

void main() async {

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          // Add other providers if needed
        ],
        child: MyApp(),
      ),
    );
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(), // Set the Splash screen as the initial screen.
    );
  }
}
