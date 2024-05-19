import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/topic_item.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TopicRepo _topicRepo = TopicRepo();
  final UserRepo _userRepo = UserRepo();

  List<TopicModel> _topics = [];
  List<TopicModel> _filteredTopics = [];
  bool _isLoadingTopics = true;

  final TextEditingController _searchKey = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllTopics();
  }

  Future<void> _refresh() async {
    _loadAllTopics();
    _searchKey.text = '';
  }

  Future<void> _loadAllTopics() async {
    setState(() {
      _isLoadingTopics = true;
    });
    List<TopicModel> topics = await _topicRepo.getAllPublicTopics();
    topics.sort((a, b) => b.date!.compareTo(a.date!));
    setState(() {
      _topics = topics;
      _filteredTopics = topics; // Initialize with all topics
      _isLoadingTopics = false;
    });
  }

  void searchTopics(String searchKey) async {
    setState(() {
      _isLoadingTopics = true;
    });
    searchKey = searchKey.toLowerCase(); // Ensure case-insensitive search
    List<TopicModel> searchedTopics = [];
    for (var topic in _topics) {
      var owner = await _userRepo.getUserByID(topic.ownerID ?? '');
      if (topic.title!.toLowerCase().contains(searchKey) ||
          topic.description!.toLowerCase().contains(searchKey) ||
          owner!.name!.toLowerCase().contains(searchKey)) {
        searchedTopics.add(topic);
      }
    }
    setState(() {
      _filteredTopics = searchedTopics;
      _isLoadingTopics = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              child: Image.asset('images/cat_face.png'),
              height: 60,
            ),
            Text('Discovery', // Title
                style: AppTextStyles.bold20),
          ],
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                onChanged: (searchKey) {
                  searchTopics(searchKey);
                },
                cursorColor: AppTheme.grey2,
                cursorWidth: 1,
                controller: _searchKey,
                style: AppTextStyles.normal16.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: AppTheme.grey2,
                  hintStyle:
                      AppTextStyles.normal16.copyWith(color: AppTheme.grey2),
                  hintText: 'Search for topics, users,...',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  filled: true,
                  fillColor: AppTheme.grey5,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none, // No border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide.none, // No border color
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _isLoadingTopics
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : (_filteredTopics.length == 0)
                        ? Center(
                            child: Text(
                              'Nothing matched your search',
                              style: AppTextStyles.bold12
                                  .copyWith(color: AppTheme.grey2),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              _refresh();
                            },
                            displacement: 5,
                            child: NotificationListener<
                                OverscrollIndicatorNotification>(
                              onNotification: (overscroll) {
                                overscroll
                                    .disallowIndicator(); // Prevent Overscroll Indication
                                return true;
                              },
                              child: ListView(
                                // Wrap ListView with Expanded
                                children: _filteredTopics
                                    .map((topic) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: TopicItem(
                                            topic: topic,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
