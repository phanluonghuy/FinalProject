import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SingleChoiceDialog extends StatelessWidget {
  final String title;
  final String message;

  const SingleChoiceDialog(
      {Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.bold20
      ),
      content: Text(
        message,
        style: AppTextStyles.normal16
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'OK',
            style: AppTextStyles.bold16.copyWith(color: AppTheme.primaryColor)
          ),
        ),
      ],
    );
  }
}
