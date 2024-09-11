import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey,
        ),
        child: Image.asset(
          "assets/images/pngegg.png",
          width: 25,
          height: 25,
        ),
      ),
    );
  }
}
