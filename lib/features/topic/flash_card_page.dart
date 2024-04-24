import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/flash_card/bottom_sheet_options.dart';
import 'package:finalproject/common/widgets/flash_card/flash_card_item.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class FlashCardPage extends StatefulWidget {
  TopicModel topic;
  FlashCardPage({super.key, required this.topic});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}



class _FlashCardPageState extends State<FlashCardPage> {
  final _topicRepo = TopicRepo();
  int index = 0;

  bool isTerm = true;
  bool isAll = true;

  void updateTerm(bool value) {
    setState(() {
      isTerm = value;
    });
  }

  void updateAll(bool value) {
    setState(() {
      isAll = value;
    });
  }

  Widget _showModalBottomSheet(){
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
                        // setState(() {
                          updateTerm(true);
                        // });
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
                        // setState(() {
                        //   isTerm = false;
                        updateTerm(false);
                        // });
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
                        // setState(() {
                        //   isAll = true;
                        // });
                        updateAll(true);
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
                        // setState(() {
                        //   isAll = false;
                        // });
                        updateAll(false);

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
    return Scaffold(
      appBar: AppBar(
        title: Text("${index+1}/${_cards.length}", style: AppTextStyles.bold20,),
        actions: [
          IconButton(
              onPressed: (){
                showModalBottomSheet(context: context, isScrollControlled: true,
                    builder: (ctx){
                      return BottomSheetOptionsPage(
                        topic: widget.topic
                      );
                    });

              },
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 600,
                child: PageView.builder(

                  onPageChanged: (value) => setState(() {
                    index = value;
                  }),
                    itemBuilder: (ctx, idx) => FlashCardItemPage(
                      card: _cards[index],
                    ),
                    itemCount: _cards.length,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    setState(() {
                      if(index - 1 < 0){
                        index = 0;
                      }else{
                        index--;
                      }
                    });
                  }, icon: Icon(Icons.keyboard_return, size: 40,)),
                  IconButton(onPressed: (){
                    setState(() {
                      if(index + 1 >= _cards.length){
                        index = _cards.length - 1;
                      }else{
                        index++;
                      }
                    });
                  }, icon: Icon(Icons.arrow_right_alt, size: 50,))

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
