import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/common/widgets/topic/card_item.dart';
import 'package:finalproject/features/profile/view_profile_page.dart';
import 'package:finalproject/features/topic/create_topic_page.dart';
import 'package:finalproject/features/topic/edit_topic_page.dart';
import 'package:finalproject/features/topic/flash_card_page.dart';
import 'package:finalproject/features/topic/ranking_page.dart';
import 'package:finalproject/features/topic/speedrun_quiz_page.dart';
import 'package:finalproject/features/topic/type_word_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/folder_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/folder_repo.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/image_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final _folderRepo = FolderRepo();
  final _currentUser = FirebaseAuth.instance.currentUser!;

  UserModel? _user;
  List<CardModel> _cards = [];
  List<FolderModel> _foldersOfCurrentUser = [];
  List<CardModel> cardsStar = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _getCards();
    _getFoldersOfCurrentUser();
  }

  Future<void> _getFoldersOfCurrentUser() async {
    List<FolderModel> folders =
        await _folderRepo.getAllFoldersOfOwnerID(_currentUser.uid);
    setState(() {
      _foldersOfCurrentUser = folders; // If user is null, assign null to _user
    });
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
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => RankingPage(topic: widget.topic)));
                },
                icon: Icon(
                  FontAwesomeIcons.trophy,
                  color: Colors.amber,
                  size: 23,
                )),
          ),
          IconButton(
            icon: Icon(
              MdiIcons.fromString('dots-horizontal-circle-outline'),
              size: 30,
            ), // Action icon
            onPressed: () {
              _showBottomDialog(context);
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
                        GestureDetector(
                          onTap: () {
                            // Navigate to ViewProfilePage when the text is tapped
                            if (_user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewProfilePage(
                                      userID: _user?.id ??
                                          ''), // Pass the user object to ViewProfilePage
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 25,
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
                              SizedBox(width: 10),
                              Text(
                                _user?.name ?? '',
                                style: AppTextStyles.bold16
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          ),
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
                imgUrl: 'images/topics.png',
                modeName: 'Flashcard',
                topic: widget.topic,
                cardStar: cardsStar,
              ),
              SizedBox(
                height: 10,
              ),
              LearningModeItem(
                imgUrl: 'images/topics.png',
                modeName: 'Type Words',
                topic: widget.topic,
                cardStar: cardsStar,
              ),
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
                imgUrl: 'images/achievement.png',
                modeName: 'Speedrun Quiz',
                topic: widget.topic,
                cardStar: cardsStar,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Word list', style: AppTextStyles.bold20),
                  Text('${_cards.length} words', style: AppTextStyles.bold16)
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                children: _cards.map((card) {
                  return CardItemPage(
                    onReturnData: (value) {
                      setState(() {
                        if (value['state'] == 0) {
                          cardsStar.add(value['card']);
                        } else if (value['state'] == -1) {
                          cardsStar.remove(value['card']);
                        }
                      });
                    },
                    card: card,
                    topicId: widget.topic.id!,
                    cardStar: cardsStar,
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: Container(
            color: Colors.white,
            // Your bottom dialog content goes here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.folder_copy_outlined),
                  title: Text(
                    'Add to your folder',
                    style: AppTextStyles.bold16,
                  ),
                  onTap: () {
                    _showFolderPickerDialog(context, _foldersOfCurrentUser);
                  },
                ),
                Visibility(
                  visible: widget.topic.ownerID == _currentUser.uid,
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(
                      'Edit this topic',
                      style: AppTextStyles.bold16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditTopicPage(topic: widget.topic),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFolderPickerDialog(
      BuildContext context, List<FolderModel> folders) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Choose a folder',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                SingleChildScrollView(
                  child: ListBody(
                    children: folders.map((folder) {
                      return ListTile(
                        title: Text(folder.title ?? ''),
                        onTap: () {
                          _folderRepo.updateTopicInFolder(
                              folder.id ?? '', widget.topic.id ?? '', true);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LearningModeItem extends StatelessWidget {
  String imgUrl;
  String modeName;
  TopicModel topic;
  List<CardModel> cardStar;
  LearningModeItem(
      {super.key,
      required this.imgUrl,
      required this.modeName,
      required this.topic,
      required this.cardStar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (modeName == 'Flashcard') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FlashCardPage(topic: topic, cardsStar: cardStar),
              // Replace TopicDetailPage() with your actual widget instance
            ),
          );
        } else if (modeName == 'Type Words') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TypeWordPage(topic: topic, cardsStar: cardStar),
            ),
          );
        } else if (modeName == 'Speedrun Quiz') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpeedrunQuizPage(topic: topic),
            ),
          );
        }
      }, //
      child: Container(
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
      ),
    );
  }
}
