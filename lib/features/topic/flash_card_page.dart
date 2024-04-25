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
