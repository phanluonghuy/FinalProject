import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/features/topic/topic_detail_page.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';

class TopicItem extends StatefulWidget {
  final TopicModel topic;
  const TopicItem({Key? key, required this.topic}) : super(key: key);

  @override
  _TopicItemState createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> {
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
    return (_user == null || _cards.isEmpty)
        ? Container()
        : GestureDetector(
            // Wrap the container with GestureDetector
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TopicDetailPage(topic: widget.topic), // Replace TopicDetailPage() with your actual widget instance
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
                    Row(
                      children: [
                        Text(widget.topic.title ?? '',
                            style: AppTextStyles.bold16
                                .copyWith(color: AppTheme.primaryColor)),
                        SizedBox(width: 6,),
                        if (!widget.topic.isPublic!)
                          Icon(Icons.lock_outline, size: 18,),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      '${_cards.length} cards',
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
                                ? CachedNetworkImage(
                                    imageUrl:
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
