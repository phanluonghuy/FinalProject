// import 'package:finalproject/common/constants/theme.dart';
// import 'package:finalproject/models/card_model.dart';
// import 'package:finalproject/models/user_model.dart';
// import 'package:flutter/cupertino.dart';
//
// class UserItem extends StatefulWidget {
//   final UserModel user;
//   const UserItem({Key? key, required this.user}) : super(key: key);
//
//   @override
//   _UserItemState createState() => _UserItemState();
// }
//
// class _UserItemState extends State<UserItem> {
//
//
//   UserModel? _user;
//   List<CardModel> _cards = [];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return (_user == null || _cards.isEmpty)
//         ? Container()
//         : GestureDetector(
//       // Wrap the container with GestureDetector
//       onTap: () {
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) =>
//         //         TopicDetailPage(user: widget.user), // Replace TopicDetailPage() with your actual widget instance
//         //   ),
//         // );
//       }, // Call onClick when tapped
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppTheme.grey4, width: 2),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Text(widget.user.title ?? '',
//                       style: AppTextStyles.bold16
//                           .copyWith(color: AppTheme.primaryColor)),
//                   SizedBox(width: 6,),
//                   if (!widget.user.isPublic!)
//                     Icon(Icons.lock_outline, size: 18,),
//                 ],
//               ),
//               SizedBox(height: 5),
//               Text(
//                 '${_cards.length} cards',
//                 style: AppTextStyles.bold12.copyWith(color: Colors.black),
//               ),
//               SizedBox(height: 30),
//               Row(
//                 children: [
//                   Container(
//                     height: 25, // Specify the desired height
//                     width: 25,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(100),
//                       child: _user != null
//                           ? CachedNetworkImage(
//                         imageUrl:
//                         _user!.avatarUrl ?? '',
//                         fit: BoxFit.cover,
//                       )
//                           : SizedBox.shrink(),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                       _user?.name ??
//                           '', // Use null-aware operator to handle null case
//                       style: AppTextStyles.bold12),
//                 ],
//               ),
//               SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }