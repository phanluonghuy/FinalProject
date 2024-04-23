import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:finalproject/reuseable/widgets/image_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TopicDetailPage extends StatefulWidget {
  final TopicModel topic;
  const TopicDetailPage({super.key, required this.topic});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final _topicRepo = TopicRepo();
  final _userRepo = UserRepo();

  UserModel? _user;
  List<CardModel> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _getCards();
  }

  Future<void> _loadUser() async {
    String ownerID = widget.topic.ownerID ?? "";
    UserModel? user = await _userRepo.getUserByID(ownerID);
    setState(() {
      _user = user; // If user is null, assign null to _user
    });
  }

  Future<void> _getCards() async {
    String topicID = widget.topic.id ?? '';
    List<CardModel> cards = await _topicRepo.getAllCardsForTopic(topicID);

    setState(() {
      _cards = cards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        // title: Text(
        //   widget.topic.title ?? '',
        //   style: AppTextStyles.bold20,
        // ),
        actions: [
          IconButton(
            icon: Icon(
              MdiIcons.fromString('dots-horizontal-circle-outline'),
              size: 30,
            ), // Action icon
            onPressed: () {
              // Action when search icon is tapped
            },
            color: Colors.black,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  border: Border.all(color: AppTheme.primaryColor, width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.topic.title ?? '',
                      style: AppTextStyles.bold20.copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _user != null
                                ? Image.network(
                                    _user!.avtUrl ?? '',
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox.shrink(),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          _user?.name ?? '',
                          style: AppTextStyles.bold16
                              .copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 1,
                          color: AppTheme.grey4,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${_cards.length} cards',
                          style: AppTextStyles.bold16
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.topic.description ?? '',
                      style: AppTextStyles.bold16.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Study Mode',
                style: AppTextStyles.bold20,
              ),
              SizedBox(
                height: 10,
              ),
              LearningModeItem(
                  imgUrl: 'images/topics.png', modeName: 'Flashcard'),
              SizedBox(
                height: 10,
              ),
              LearningModeItem(
                  imgUrl: 'images/topics.png', modeName: 'Type Words'),
              SizedBox(
                height: 15,
              ),
              Text(
                'Competitive mode',
                style: AppTextStyles.bold20,
              ),
              SizedBox(
                height: 10,
              ),
              LearningModeItem(
                  imgUrl: 'images/achievement.png', modeName: 'Speedrun Quiz'),
            ],
          ),
        ),
      ),
    );
  }
}

class LearningModeItem extends StatelessWidget {
  String imgUrl;
  String modeName;
  LearningModeItem({super.key, required this.imgUrl, required this.modeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.grey4, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Image.asset(
              imgUrl,
              height: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              // Use Expanded to occupy the remaining space
              child: Text(modeName, style: AppTextStyles.bold16),
            ),
          ],
        ),
      ),
    );
  }
}
