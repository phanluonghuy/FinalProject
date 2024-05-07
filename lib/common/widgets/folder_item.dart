import 'package:finalproject/features/topic/folder_detail_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/folder_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/features/topic/topic_detail_page.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';

class FolderItem extends StatefulWidget {
  final FolderModel folder;
  const FolderItem({Key? key, required this.folder}) : super(key: key);

  @override
  _FolderItemState createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  final _userRepo = UserRepo();

  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    String ownerID = widget.folder.ownerID ?? "";
    UserModel? user = await _userRepo.getUserByID(ownerID);
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_user == null)
        ? Container()
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderDetailPage(folder: widget.folder,),
                ),
              );
            }, // Call onClick when tapped
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.grey4, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(widget.folder.title ?? '',
                        style: AppTextStyles.bold16
                            .copyWith(color: AppTheme.primaryColor)),
                    SizedBox(height: 5),
                    Text(
                      'Folder',
                      style: AppTextStyles.bold12.copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          height: 25, // Specify the desired height
                          width: 25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _user != null
                                ? Image.network(
                                    _user!.avatarUrl ?? '',
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            _user?.name ??
                                '', // Use null-aware operator to handle null case
                            style: AppTextStyles.bold12),
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
  }
}
