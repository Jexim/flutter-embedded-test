import 'package:flutter/material.dart';

class MainStream extends StatelessWidget {
  const MainStream({super.key});

  @override
  Widget build(BuildContext context) {
    // return Image(image: AssetImage('assets/images/nature-full-hd.jpg'), fit: BoxFit.fitHeight);
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/nature-full-hd.jpg'), fit: BoxFit.fitHeight)),
    );
  }
}
