import 'package:finalproject/common/widgets/folder_dialog.dart';
import 'package:finalproject/common/widgets/folder_item.dart';
import 'package:finalproject/models/folder_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/folder_repo.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/features/topic/create_topic_page.dart';
import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/topic_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/repositories/achievement_repo.dart';
import 'package:finalproject/models/achievement_model.dart';
import 'package:flutter/widgets.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final _topicRepo = TopicRepo();
  final _folderRepo = FolderRepo();
  final _currentUser = FirebaseAuth.instance.currentUser!;

  List<TopicModel> _topics = [];
  bool _isLoadingTopics = true;

  List<FolderModel> _folders = [];
  bool _isLoadingFolders = true;

  bool _showTopics = true;

  final _creatingFolderTitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTopics();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    setState(() {
      _isLoadingFolders = true;
    });
    List<FolderModel> folders =
        await _folderRepo.getAllFoldersOfOwnerID(_currentUser.uid);
    setState(() {
      _folders = folders;
      _isLoadingFolders = false;
    });
  }

  Future<void> _loadTopics() async {
    setState(() {
      _isLoadingTopics = true;
    });
    List<TopicModel> topics =
        await _topicRepo.getAllTopicsByOwnerID(_currentUser.uid);
    setState(() {
      _topics = topics;
      _isLoadingTopics = false;
    });
  }

  void _addButtonClicked() {
    if (_showTopics) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateTopicPage()),
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return FolderDialog(
              titleController: _creatingFolderTitle,
              onConfirm: () {
                if (_creatingFolderTitle.text == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Edit card failed: Folder\'s cannot be empty!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                FolderModel newFolder = FolderModel(
                    ownerID: _currentUser.uid,
                    title: _creatingFolderTitle.text,
                    date: DateTime.now());
                _folderRepo.createFolder(newFolder);
                setState(() {
                  _loadFolders();
                });
              },
            );
          });
    }
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
              _addButtonClicked();
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
                        setState(() {
                          _showTopics = true;
                          _loadTopics();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _showTopics ? AppTheme.primaryColor : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(
                            color: AppTheme.primaryColor,
                            width: _showTopics ? 0 : 2,
                          ), // Set border color
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
                              color: _showTopics ? Colors.white : null,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Topics',
                              style: AppTextStyles.bold16.copyWith(
                                color: _showTopics ? Colors.white : null,
                              ),
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
                        setState(() {
                          _showTopics = false;
                          _loadFolders();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_showTopics ? AppTheme.primaryColor : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: BorderSide(
                            color: AppTheme.primaryColor,
                            width: !_showTopics ? 0 : 2,
                          ), // Set border color
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
                              color: !_showTopics ? Colors.white : null,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Folders',
                                style: AppTextStyles.bold16.copyWith(
                                  color: !_showTopics ? Colors.white : null,
                                )),
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
              _showTopics ? _topicList(context) : _folderList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topicList(BuildContext context) {
    return Expanded(
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
    );
  }

  Widget _folderList(BuildContext context) {
    return Expanded(
      // Wrap the Column with Expanded
      child: _isLoadingFolders
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              // Wrap ListView with Expanded
              children: _folders
                  .map((folder) => Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: FolderItem(
                          folder: folder,
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
