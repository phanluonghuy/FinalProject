import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.grey5,
          border: Border.all(color: AppTheme.grey3),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Text(
          message,
          style: AppTextStyles.bold20,
        ),
      ),
    );
  }
}
