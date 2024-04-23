import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SingleChoiceDialog extends StatelessWidget {
  final String title;
  final String message;

  const SingleChoiceDialog({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyles.bold20),
            SizedBox(height: 10),
            Text(message, style: AppTextStyles.normal16),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align children to the end of the row
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: AppTextStyles.bold16.copyWith(color: AppTheme.primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
