import 'package:finalproject/data/models/topic_model.dart';
import 'package:finalproject/data/models/user_model.dart';
import 'package:finalproject/data/repositories/topic_repo.dart';
import 'package:finalproject/data/repositories/user_repo.dart';
import 'package:finalproject/features/topic/create_topic_page.dart';
import 'package:finalproject/reuseable/constants/strings.dart';
import 'package:finalproject/reuseable/constants/text_styles.dart';
import 'package:finalproject/reuseable/constants/theme.dart';
import 'package:finalproject/reuseable/widgets/topic_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/data/repositories/achievement_repo.dart';
import 'package:finalproject/data/models/achievement_model.dart';
import 'package:flutter/widgets.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  List<TopicModel> _topics = [];
  bool _isLoadingTopics = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    List<TopicModel> topics =
        await TopicRepo().getAllTopicsByOwnerID(_currentUser.uid);
    setState(() {
      _topics = topics;
      _isLoadingTopics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              child: Image.asset('images/cat_face.png'),
              height: 60,
            ),
            Text('Your Library', // Title
                style: AppTextStyles.bold20),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_box_outlined,
              size: 30,
            ), // Action icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateTopicPage()),
              );
            },
            color: Colors.black,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Topics',
                              style: AppTextStyles.bold16
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Add spacing between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(
                              color: AppTheme.primaryColor,
                              width: 2), // Set border color
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_outlined,
                              size: 25,
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Folders',
                              style: AppTextStyles.bold16
                                  .copyWith(color: AppTheme.primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                // Wrap the Column with Expanded
                child: _isLoadingTopics
                    ? Center(
                        child: CircularProgressIndicator(),
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
            ],
          ),
        ),
      ),
    );
  }
}
