import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:flutter/material.dart';

class CardItemPage extends StatefulWidget {
  Function(dynamic) onReturnData;
  CardModel card;
  String topicId;
  List<CardModel> cardStar;
  CardItemPage({super.key, required this.onReturnData, required this.card, required this.topicId, required this.cardStar});

  @override
  State<CardItemPage> createState() => _CardItemPageState();
}

class _CardItemPageState extends State<CardItemPage> {
  TopicRepo topicRepo = TopicRepo();
  bool isStar = false;
  String cardId = "";
  String topicId = "";
  CardModel? _card;
  bool? isTerm;

  bool _checkStarIsContain(){
    if(widget.cardStar.contains(widget.card)){
      return true;
    }
    return false;
  }

  void dataReturn(dynamic data){
    widget.onReturnData(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    isStar = widget.card.star!;
    cardId = widget.card.id!;
    topicId = widget.topicId;
    _card = widget.card;
    isTerm = _checkStarIsContain();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            // color: AppTheme.grey5,
            border: Border.all(color: AppTheme.grey3, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Term: ${widget.card.term}', style: AppTextStyles.bold16,),
                      Text('Definition: ${widget.card.definition}', style: AppTextStyles.bold16),
                      // Text('Description: ${widget.card.imgUrl}'),
                      // Text('Term: ${widget.card.term}'),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: ()async{
                            await TextToSpeech().speakEng("${widget.card.term}");
                            await Future.delayed(Duration(milliseconds: 800));
                            await TextToSpeech().speakVie("${widget.card.definition}");
                          }, icon: Icon(Icons.keyboard_voice_outlined,)),

                      IconButton(
                          onPressed: (){
                            // isStar = !isStar;
                            // topicRepo.updateCardStar(topicId, cardId, isStar);
                            setState(() {
                              // print("hi lo");
                              // _getCardStar();

                              if(!_checkStarIsContain()){
                                // add
                                dataReturn({'card': widget.card, 'state': 0});
                              } else{
                                // remove
                                dataReturn({'card': widget.card, 'state': -1});
                              }
                              isTerm = _checkStarIsContain();

                            });
                          }, icon: isTerm == true ? Icon(Icons.star, color: Colors.yellow[800],): Icon(Icons.star_border)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
