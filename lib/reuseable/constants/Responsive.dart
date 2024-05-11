import 'package:flutter/material.dart';
// import 'package:responsive_framework/responsive_framework.dart';
//
// class Responsive extends StatelessWidget {
//   const Responsive({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       builder: (context, child) => ResponsiveBreakpoints.builder(
//         child: child!,
//         breakpoints: [
//           const Breakpoint(start: 0, end: 450, name: MOBILE),
//           const Breakpoint(start: 451, end: 800, name: TABLET),
//           const Breakpoint(start: 801, end: 1920, name: DESKTOP),
//           const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
//         ],
//       ),
//       initialRoute: "/",
//     );
//   }
// }

class Responsive{
  bool isPC(context){
    final screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth >= 801)
      return true;
    return false;
  }

}
