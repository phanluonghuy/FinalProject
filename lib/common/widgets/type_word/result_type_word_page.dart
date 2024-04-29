import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/type_word/card_type_word_result.dart';
import 'package:finalproject/features/topic/topic_detail_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultTypeWordPage extends StatefulWidget {
  TopicModel topic;
  List<CardModel> cardCorrect;
  List<CardModel> cardInCorrect;
  List<String> correctAnswer;
  List<String> inCorrectAnswer;
  ResultTypeWordPage({super.key, required this.topic, required this.cardCorrect, required this.cardInCorrect, required this.correctAnswer, required this.inCorrectAnswer});

  @override
  State<ResultTypeWordPage> createState() => _ResultTypeWordPageState();
}

class _ResultTypeWordPageState extends State<ResultTypeWordPage> {
  List<CardModel> _cardCorrect = [];
  List<CardModel> _cardInCorrect = [];
  List<String> _correctAnswer = [];
  List<String> _inCorrectAnswer = [];
  double _percentageCorrect = 0.0;
  String _feedback = '';

  @override
  void initState() {
    // TODO: implement initState
    _cardCorrect = widget.cardCorrect;
    _cardInCorrect = widget.cardInCorrect;
    _correctAnswer = widget.correctAnswer;
    _inCorrectAnswer = widget.inCorrectAnswer;
    _percentageCorrect = (_cardCorrect.length * 100 / (_cardCorrect.length + _cardInCorrect.length));
    print(_percentageCorrect);
    if(_percentageCorrect >= 80){
      _feedback = 'Excellent job !';
    }else if(_percentageCorrect >= 50 && _percentageCorrect < 80){
      _feedback = 'Not bad !';
    } else{
      _feedback = 'Try again !';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Result", style: TextStyle(color: AppTheme.flashCardColor, fontWeight: FontWeight.bold, fontSize: 35),),
            SizedBox(height: 18,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.primaryColor
              ),
              child: Padding(
                  padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Score:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('Correct:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('Incorrect:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('Feedback:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_cardCorrect.length * 10}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('${_cardCorrect.length}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('${_cardInCorrect.length}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('${_feedback}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                    ],
                  ),
                ],
              ),),
            ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Correct', style: TextStyle(color: AppTheme.flashCardColor, fontSize: 22, fontWeight: FontWeight.bold),),
                Text('Incorrect', style: TextStyle(color: AppTheme.flashCardColor, fontSize: 22, fontWeight: FontWeight.bold),),
              ],
            ),
            SizedBox(height: 12,),
            Container(
              alignment: Alignment.topCenter,
              height: 380,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, idx) => CardTypeWordResultPage(
                        cardModel: _cardCorrect[idx],
                        answer: _correctAnswer[idx],
                      ),
                      itemCount: _cardCorrect.length,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (ctx, idx) => CardTypeWordResultPage(
                        cardModel: _cardInCorrect[idx],
                        answer: _inCorrectAnswer[idx],
                      ),
                      itemCount: _cardInCorrect.length,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: AppTheme.primaryColor),
                            borderRadius: BorderRadius.circular(20)
                          )
                        ).copyWith(
                          backgroundColor: MaterialStatePropertyAll(Colors.white)
                        ),
                        onPressed: (){
                          Navigator.pop(context, {'newIndex': 0});
                    }, child: Text('Restart Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: AppTheme.primaryColor),
                                borderRadius: BorderRadius.circular(20)
                            )
                        ).copyWith(
                            backgroundColor: MaterialStatePropertyAll(Colors.white)
                        ),
                        onPressed: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => TopicDetailPage(topic: widget.topic)),);
                        }, child: Text('New Test', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                  ),
                ),
              ],
            ),
          ],
        ),),
      ),
    );
  }
}
