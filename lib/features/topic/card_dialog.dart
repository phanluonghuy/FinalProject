import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';

class CardDialog extends StatelessWidget {
  final TextEditingController termController;
  final TextEditingController definitionController;
  final VoidCallback onConfirm;

  const CardDialog({
    Key? key,
    required this.termController,
    required this.definitionController,
    required this.onConfirm
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
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
                    controller: termController,
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
                    controller: definitionController,
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40), // Rounded corners
                      ),
                    ),
                    child: Center(
                      child: Text('Confirm',
                          style: AppTextStyles.bold12
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
