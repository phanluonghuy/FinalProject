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
  static void wrongOTP(BuildContext context) {
    return
      MotionToast(
        icon: Icons.verified,
        primaryColor: Colors.yellow,
        description: const Text("Invalid OTP",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 18),),
        width: 300,
        height: 70,
      ).show(context);
  }
  static void wrongFormatInt(BuildContext context) {
    return
      MotionToast(
        icon: Icons.verified,
        primaryColor: Colors.yellow,
        description: const Text("Invalid number OTP",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 18),),
        width: 300,
        height: 70,
      ).show(context);
  }
  static void emailExits(BuildContext context) {
    return
      MotionToast(
        icon: Icons.email,
        primaryColor: Colors.redAccent,
        description: const Text("Your email exits",style: TextStyle(color:Colors.black,fontWeight: FontWeight.w400,fontSize: 18),),
        width: 300,
        height: 70,
      ).show(context);
  }
}