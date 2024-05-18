import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/record_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankingItemPage extends StatefulWidget {
  TopicModel topic;
  RecordModel record;
  int index;
  RankingItemPage({super.key, required this.topic, required this.record, required this.index});

  @override
  State<RankingItemPage> createState() => _RankingItemPageState();
}

class _RankingItemPageState extends State<RankingItemPage> {
  final _userRepo = UserRepo();
  UserModel? _user;
  int index = 0;

  int timeRemaining = 0;

  Future<void> _loadUser() async {
    String ownerID = widget.record.userID ?? "";
    UserModel? user = await _userRepo.getUserByID(ownerID);
    setState(() {
      _user = user; // If user is null, assign null to _user
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    _loadUser();
    index = widget.index;
    timeRemaining = widget.record.time!.toInt();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.grey3,
            width: 1
          ),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                if(index == 0)
                Image.asset(
                  'images/medal1.png',
                  height: 40,
                ),
                if(index == 1)
                  Image.asset(
                    'images/medal2.png',
                    height: 40,
                  ),
                if(index == 2)
                  Image.asset(
                    'images/medal3.png',
                    height: 40,
                  ),
                if(index > 2)
                  SizedBox(width: 40, child: Text('${index+1}', style: AppTextStyles.bold26,))
              ],
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          '${_user?.avatarUrl!}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text('${_user?.name!}', style: AppTextStyles.bold16,)
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Text('Score: ', style: AppTextStyles.boldPrimary16,),
                    Text('${widget.record.score}', style: AppTextStyles.bold16,),
                    SizedBox(width: 16,),
                    Text('Time: ', style: AppTextStyles.boldPrimary16,),
                    Text('${timeRemaining.toString()}s', style: AppTextStyles.bold16,)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
