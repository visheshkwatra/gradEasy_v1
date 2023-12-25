import 'package:flutter/material.dart';

class globalLogo extends StatelessWidget {
  const globalLogo({
    Key? key,
    this.size = 80.0,
    this.isWhite = true, // Add a property to control the logo color
  }) : super(key: key);

  final double size;
  final bool isWhite; // A property to control the logo color

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Image(
        image: isWhite
            ? AssetImage('Images/logo_white.png')
            : AssetImage('Images/logo_black.png'),
        height: size,
        width: size,
        alignment: FractionalOffset.center,
      ),
    );
  }
}
