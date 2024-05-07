import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/double_choice_dialog.dart';
import 'package:finalproject/common/widgets/single_choice_dialog.dart';
import 'package:finalproject/common/widgets/topic_item.dart';
import 'package:finalproject/features/main_menu/library_page.dart';
import 'package:finalproject/models/folder_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/models/user_model.dart';
import 'package:finalproject/repositories/folder_repo.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FolderDetailPage extends StatefulWidget {
  final FolderModel folder;
  const FolderDetailPage({super.key, required this.folder});

  @override
  State<FolderDetailPage> createState() => _FolderDetailPageState();
}

class _FolderDetailPageState extends State<FolderDetailPage> {
  final _folderRepo = FolderRepo();
  final _topicRepo = TopicRepo();
  final _userRepo = UserRepo();
  bool _isLoadingTopics = true;

  FolderModel? _currentFolder;
  List<TopicModel> _topics = [];

  @override
  void initState() {
    super.initState();
    _loadFolder();
  }

  Future<void> _loadFolder() async {
    String folderID = widget.folder.id ?? "";
    FolderModel? currentFolder = await _folderRepo.getFolderByID(folderID);
    setState(() {
      _currentFolder = currentFolder;
    });

    if (_currentFolder?.topicIDs == null) {
      // Handle the case when topicIDs is null
      return;
    }

    var topicIDsInFolder = _currentFolder!.topicIDs!.entries
        .where((entry) => entry.value == true)
        .toList();

    List<TopicModel> topicList = [];
    for (var entry in topicIDsInFolder) {
      try {
        // Load the topic using the topicRepo
        TopicModel? topic = await _topicRepo.getTopicByID(entry.key);
        if (topic != null) {
          topicList.add(topic);
        }
      } catch (e) {
        print('Error loading topic: $e');
      }
    }

    setState(() {
      _topics = topicList;
      _isLoadingTopics = false;
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Expanded(
            child: _isLoadingTopics
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: _topics
                        .map((topic) => Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.3,
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        print('1');
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return DoubleChoiceDialog(
                                                title:
                                                    'Removing topic from this folder',
                                                message:
                                                    'Do you want to remove this topic from the folder?',
                                                onConfirm: () async {
                                                  await _folderRepo
                                                      .updateTopicInFolder(
                                                          widget.folder.id ??
                                                              '',
                                                          topic.id ?? '',
                                                          false);
                                                  setState(() {
                                                    _loadFolder();
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      },
                                      icon: Icons.delete_outline,
                                      foregroundColor: Colors.red,
                                    ),
                                  ],
                                ),
                                child: TopicItem(
                                  topic: topic,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
          ),
        ));
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
                  leading: Icon(Icons.edit),
                  title: Text(
                    'Edit folder\'s title',
                    style: AppTextStyles.bold16,
                  ),
                  onTap: () {
                    // Handle onTap action
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text(
                    'Delete this folder',
                    style: AppTextStyles.bold16,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DoubleChoiceDialog(
                            title: 'Deleting folder!',
                            message:
                                'Do you want to permanently delete this folder?',
                            onConfirm: () {
                              _folderRepo.deleteFolderByID(widget.folder.id ?? '');
                              Navigator.popUntil(context, ModalRoute.withName('/'));

                            },
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
