import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/topic_item.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:flutter/material.dart';

class UserTopicsPage extends StatefulWidget {
  String userID;
  UserTopicsPage({required this.userID, super.key});

  @override
  State<UserTopicsPage> createState() => _UserTopicsPageState();
}

class _UserTopicsPageState extends State<UserTopicsPage> {
  var _topicRepo = TopicRepo();

  List<TopicModel> _topics = [];
  bool _isLoadingTopics = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoadingTopics = true;
    });
    List<TopicModel> topics =
        await _topicRepo.getAllTopicsByOwnerID(widget.userID);

    // Filter out private topics
    List<TopicModel> publicTopics = topics.where((topic) => topic.isPublic == true).toList();

    setState(() {
      _topics = publicTopics;
      _isLoadingTopics = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text('All topics', // Title
              style: AppTextStyles.bold20),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Center(
            child: Expanded(
              child: _isLoadingTopics
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : (_topics.length == 0)
                      ? Center(
                          child: Text(
                            'This user hasn\'t created any topics',
                            style: AppTextStyles.bold12
                                .copyWith(color: AppTheme.grey2),
                          ),
                        )
                      : ListView(
                          // Wrap ListView with Expanded
                          children: _topics
                              .map((topic) => Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: TopicItem(
                                      topic: topic,
                                    ),
                                  ))
                              .toList(),
                        ),
            ),
          ),
        ));
  }
}
