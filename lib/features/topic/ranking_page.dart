import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/record_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:flutter/material.dart';

import 'package:finalproject/common/widgets/rank/ranking_item.dart';

class RankingPage extends StatefulWidget {
  TopicModel topic;
  RankingPage({super.key, required this.topic});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  TopicRepo _topicRepo = TopicRepo();
  List<RecordModel> _records = [];
  List<CardModel> _cards = [];

  Future<void> _getRecords() async {
    String topicID = widget.topic.id ?? '';
    List<RecordModel> record = await _topicRepo.getAllRecord(topicID);

    setState(() {
      _records = record;
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    _getRecords();
    // print(_records);
    super.initState();
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
            Text('Leaderboard', // Title
                style: AppTextStyles.bold20),
          ],
        ),
        actions: [
        ],
      ),
      body: _records.length == 0 ? Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (ctx, idx) => RankingItemPage(
          topic: widget.topic,
          record: _records[idx],
            index: idx
        ), itemCount: _records.length,),
        ),
      ),
    );
  }
}
