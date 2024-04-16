import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:flutter/material.dart';

class TopicItem extends StatelessWidget {
  const TopicItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    style: AppTextStyles.bold16,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(bottom: 10),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.grey1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('TERM', style: AppTextStyles.bold12),
                  SizedBox(height: 15),
                  TextFormField(
                    style: AppTextStyles.bold16,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.only(bottom: 10),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.grey1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.primaryColor)),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text('DEFINITION', style: AppTextStyles.bold12),
                  SizedBox(height: 20),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      );
  }
}