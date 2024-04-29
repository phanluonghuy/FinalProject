import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:flutter/material.dart';

class BottomSheetOptionsPage extends StatefulWidget {
  TopicModel topic;
  bool isTermMain;
  bool isAllMain;
  BottomSheetOptionsPage({super.key, required this.topic, required this.isTermMain, required this.isAllMain});

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
    isTerm = widget.isTermMain;
    isAll = widget.isAllMain;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 16,),
              Text('Options', style: AppTextStyles.bold26),
              SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, {'isShuffle': true, 'isTerm': isTerm, 'isAll': isAll});
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cached, color: AppTheme.primaryColor),
                          SizedBox(width: 8),
                          Text('SHUFFLE', style: AppTextStyles.bold16.copyWith(color: AppTheme.primaryColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('CARD ORIENTATION', style: AppTextStyles.bold20 ),
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
                        side: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ).copyWith(
                        backgroundColor: isTerm? MaterialStatePropertyAll(AppTheme.primaryColor): MaterialStatePropertyAll(Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text('TERM', style: AppTextStyles.bold16.copyWith(color: isTerm? Colors.white: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ).copyWith(
                        backgroundColor: !isTerm? MaterialStatePropertyAll(AppTheme.primaryColor): MaterialStatePropertyAll(Colors.white)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text('DEFINITION', style: AppTextStyles.bold16.copyWith(color: !isTerm? Colors.white: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Study using', style: AppTextStyles.bold20)),
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ).copyWith(
                        backgroundColor: isAll? MaterialStatePropertyAll(AppTheme.primaryColor): MaterialStatePropertyAll(Colors.white)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text('ALL', style: AppTextStyles.bold16.copyWith(color: isAll? Colors.white: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(color: AppTheme.primaryColor, width: 2),
                      ).copyWith(
                        backgroundColor: !isAll? MaterialStatePropertyAll(AppTheme.primaryColor): MaterialStatePropertyAll(Colors.white)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text('STARRED', style: AppTextStyles.bold16.copyWith(color: !isAll? Colors.white: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {'isTerm': isTerm, 'isAll': isAll});
                  },
                  style: ElevatedButton.styleFrom(
                    // padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text('Restart Flashcards', style: AppTextStyles.bold20.copyWith(color: AppTheme.primaryColor)),
                  ),
                ),
              ),
              SizedBox(height: 16,)
            ],
          ),
        ),
      ),
    );
  }
}
