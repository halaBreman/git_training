import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  CustomMaterialButton({super.key, this.onPressed, required this.text,  this.isLoading =false});
  final void Function()? onPressed;
  final String text;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(

      onPressed: onPressed,
      color: isLoading ? Colors.red.shade300 : Colors.red.shade900,
      textColor: Colors.white,
      height: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: isLoading ? const CircularProgressIndicator(strokeWidth: 2.0 ,color: Colors.white,) : Text(text),
    );
  }
}
