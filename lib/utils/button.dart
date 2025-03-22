import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.height,
    this.width,
    required this.textcolor,
  });
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Color textcolor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height! / 2),
          color: widget.color,
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.textcolor,
              fontFamily: "Quicksand",
              fontSize: widget.height! / 3,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
