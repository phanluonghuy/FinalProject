import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';

class FolderDialog extends StatelessWidget {
  final TextEditingController titleController;
  final VoidCallback onConfirm;

  const FolderDialog({
    Key? key,
    required this.titleController,
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
                  SizedBox(height: 10),
                  Center(
                    child: Text('CREATE NEW  FOLDER', style: AppTextStyles.bold16),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: titleController,
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
                  Text('FOLDER TITLE', style: AppTextStyles.bold12),
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
