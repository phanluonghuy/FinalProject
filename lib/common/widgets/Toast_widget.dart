import 'package:finalproject/common/constants/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class Toast {
  static void uploadAvatarSuccess(BuildContext context) {
    return
    MotionToast(
      icon: Icons.add_task,
      primaryColor: Colors.green,
      title: const Text("SUCCESS", style: AppTextStyles.bold16),
      description: const Text("Your avatar was changed"),
      width: 300,
      height: 70,
    ).show(context);
  }
  static void uploadAvatarFailed(BuildContext context) {
    return
      MotionToast(
        icon: Icons.add_task,
        primaryColor: Colors.red,
        title: const Text("FAIL", style: AppTextStyles.bold16),
        description: const Text("Your avatar failed to change."),
        width: 300,
        height: 70,
      ).show(context);
  }
}