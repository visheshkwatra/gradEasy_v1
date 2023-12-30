import 'package:flutter/material.dart';

class BackButtonHandler {
  static Future<bool?> onWillPop(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Close the App?'),
        content: Text('Are you sure you want to close the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
