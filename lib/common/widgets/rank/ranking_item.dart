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


  int timeRemanaing = 0;

  Future<void> _loadUser() async {
    String ownerID = widget.topic.ownerID ?? "";
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
    timeRemanaing = widget.record.time!.toInt();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int minutes = timeRemanaing ~/ 60;
    int seconds = timeRemanaing % 60;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        
        border: Border.all(
          color: AppTheme.grey3,
          width: 1
        ),
        borderRadius: BorderRadius.circular(20)
      ),
      // height: 100,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("hiii"),
          Column(

            children: [
              if(index == 0)
              Image.asset(
                'images/rank_1st.png',
                height: 70,
                width: 140,
              ),
              if(index == 1)
                Image.asset(
                  'images/rank_2nd.png',
                  height: 70,
                  width: 140,
                ),
              if(index == 2)
                Image.asset(
                  'images/rank_3rd.png',
                  height: 70,
                  width: 140,
                ),
              if(index > 2)
                Image.asset(
                  'images/rank_4th.png',
                  height: 70,
                  width: 140,
                ),
              Text(
                'Rank ${index + 1}',
                style: AppTextStyles.bold16,
              ),
            ],
          ),


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

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
              SizedBox(height: 8,),
              Row(
                children: [
                  Text('Score: ', style: AppTextStyles.boldPrimary16,),
                  SizedBox(width: 12,),
                  Text('${widget.record.score}', style: AppTextStyles.bold16,)
                ],
              ),
              Row(
                children: [
                  Text('Time: ', style: AppTextStyles.boldPrimary16,),
                  SizedBox(width: 16,),
                  Text('$minutes:${seconds.toString().padLeft(2, '0')}s', style: AppTextStyles.bold16,)
                ],
              )

            ],
          )

        ],
      ),
    );
  }
}
