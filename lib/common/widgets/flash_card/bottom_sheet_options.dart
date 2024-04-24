import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:flutter/material.dart';

class BottomSheetOptionsPage extends StatefulWidget {
  TopicModel topic;
  BottomSheetOptionsPage({super.key, required this.topic});

  @override
  State<BottomSheetOptionsPage> createState() => _BottomSheetOptionsPageState();
}

class _BottomSheetOptionsPageState extends State<BottomSheetOptionsPage> {
  final _topicRepo = TopicRepo();

  bool isTerm = true;
  bool isAll = true;

  List<CardModel> _cards = [];

  Future<void> _getCards() async {
    String topicID = widget.topic.id ?? '';
    List<CardModel> cards = await _topicRepo.getAllCardsForTopic(topicID);

    setState(() {
      _cards = cards;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16,),
              Text('Options', style: TextStyle(color: AppTheme.flashCardColor, fontSize: 30, fontWeight: FontWeight.bold),),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: AppTheme.flashCardColor, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cached, color: AppTheme.flashCardColor),
                          SizedBox(width: 8),
                          Text('SHUFFLE', style: TextStyle(color: AppTheme.flashCardColor, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('CARD ORIENTATION', style: TextStyle(color: AppTheme.flashCardColor, fontSize: 20, fontWeight: FontWeight.bold) ),
              ),
              SizedBox(height: 8,),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Front', style: AppTextStyles.bold20,)),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isTerm = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.flashCardColor, width: 2),
                      ).copyWith(
                        backgroundColor: isTerm? MaterialStatePropertyAll(Colors.blue): null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text('TERM', style: TextStyle(color: isTerm? Colors.white: AppTheme.flashCardColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  SizedBox(width: 16,),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isTerm = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.flashCardColor, width: 2),
                      ).copyWith(
                        backgroundColor: !isTerm? MaterialStatePropertyAll(Colors.blue): null
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text('DEFINITION', style: TextStyle(color: !isTerm? Colors.white: AppTheme.flashCardColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text('STUDY USING', style: TextStyle(color: AppTheme.flashCardColor, fontSize: 18, fontWeight: FontWeight.bold),)),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAll = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.flashCardColor, width: 2),
                      ).copyWith(
                        backgroundColor: isAll? MaterialStatePropertyAll(Colors.blue): null
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text('ALL', style: TextStyle(color: isAll? Colors.white: AppTheme.flashCardColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  SizedBox(width: 16,),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isAll = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.flashCardColor, width: 2),
                      ).copyWith(
                        backgroundColor: !isAll? MaterialStatePropertyAll(Colors.blue): null
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text('STARRED', style: TextStyle(color: !isAll? Colors.white: AppTheme.flashCardColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: AppTheme.flashCardColor, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Text('Restart Flashcards', style: TextStyle(color: AppTheme.flashCardColor, fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
