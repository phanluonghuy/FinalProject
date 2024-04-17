import 'package:finalproject/data/models/card_model.dart';
import 'package:finalproject/data/models/topic_model.dart';
import 'package:finalproject/data/models/user_model.dart';
import 'package:finalproject/data/repositories/topic_repo.dart';
import 'package:finalproject/data/repositories/user_repo.dart';
import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:flutter/material.dart';

class TopicItem extends StatefulWidget {
  final TopicModel topic;
  const TopicItem({Key? key, required this.topic}) : super(key: key);

  @override
  _TopicItemState createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> {
  UserModel? _user;
  int? _numberOfCards;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _getNumberOfCards();
  }

  Future<void> _loadUser() async {
    String ownerID = widget.topic.ownerID ?? "";
    UserModel? user = await UserRepo().getUserByID(ownerID);
    setState(() {
      _user = user; // If user is null, assign null to _user
    });
  }

  Future<void> _getNumberOfCards() async {
    String topicID = widget.topic.id ?? '';
    List<CardModel> cards = await TopicRepo().getAllCardsForTopic(topicID);
    int numberOfCards = cards.length;

    setState(() {
      _numberOfCards = numberOfCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_user == null || _numberOfCards == null)
        ? Container()
        : Container(
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
                  Text(widget.topic.title ?? '',
                      style: AppTextStyles.bold16
                          .copyWith(color: AppTheme.primaryColor)),
                  SizedBox(height: 5),
                  Text(
                    '$_numberOfCards cards',
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
                                  _user!.avtUrl ?? '',
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
          );
  }
}
