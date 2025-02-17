import 'package:flutter/material.dart';

class ModalTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color? backgroundColor;
  final bool isLoading;
  final double borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final double loadingSize;

  const ModalTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.foregroundColor,
    this.backgroundColor,
    this.isLoading = false,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.fontSize = 14,
    this.loadingSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: loadingSize,
              height: loadingSize,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
              ),
            )
          : Text(
              text,
              style: TextStyle(fontSize: fontSize),
            ),
    );
  }
}
