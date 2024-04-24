import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final String imageLocation;
  final String title;
  const ImageItem({super.key, required this.imageLocation, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.grey4, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Image.asset(
              imageLocation,
              width: 80,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              // Use Expanded to occupy the remaining space
              child: Text(title, style: AppTextStyles.bold20),
            ),
            Icon(
              Icons.navigate_next,
              size: 30,
            )
          ],
        ),
      ),
    );
  }
}
