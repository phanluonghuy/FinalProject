import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:finalproject/reuseable/constants/ToastMessage.dart';
import 'package:flutter/material.dart';

class SpeedrunItemPage extends StatefulWidget {
  final Function(dynamic) returnData;
  String answers;
  int index;
  String definition;
  CardModel card;
  List<CardModel> cardCorrect;
  List<CardModel> cardInCorrect;
  List<String> correctAnswer;
  List<String> inCorrectAnswer;
  int timeRemainning;
  SpeedrunItemPage({super.key, required this.returnData, required this.answers,
    required this.index, required this.definition, required this.card,
    required this.cardCorrect, required this.cardInCorrect, required this.correctAnswer,
    required this.inCorrectAnswer, required this.timeRemainning
  });

  @override
  State<SpeedrunItemPage> createState() => _SpeedrunItemPageState();
}

class _SpeedrunItemPageState extends State<SpeedrunItemPage> {
  List<CardModel> cardCorrect = [];
  List<CardModel> cardInCorrect = [];
  List<String> correctAnswer = [];
  List<String> inCorrectAnswer = [];
  bool isChoice = false;

  @override
  void initState() {
    // TODO: implement initState
    cardCorrect = widget.cardCorrect;
    cardInCorrect = widget.cardInCorrect;
    correctAnswer = widget.correctAnswer;
    inCorrectAnswer = widget.inCorrectAnswer;
    super.initState();
  }

  void onDataReturned(dynamic data){
    widget.returnData({'index': widget.index + 1});
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: (){
          setState(() {
            isChoice = true;
          });

          int count = 0;

          // Future.delayed(Duration(seconds: 1), (){
            if(widget.answers == widget.definition){
              TextToSpeech().speakEng("Excellent job");
              ToastMessage().showToastSuccess("Correct answer !!");
              count = 1;
              cardCorrect.add(widget.card);
              correctAnswer.add(widget.definition);
            }else{
              TextToSpeech().speakEng("Don't worry, try again");
              ToastMessage().showToastFailed("Incorrect answer !!");
              count = 2;
              cardInCorrect.add(widget.card);
              inCorrectAnswer.add(widget.answers);
            }
          // });

          onDataReturned(count);

        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isChoice? AppTheme.grey3: Colors.white,
            borderRadius: BorderRadius.circular(20),
            // border: Border.all(
            //   color: Colors.white,
            //   style: BorderStyle.solid,
            //   width: 2
            // )
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('${widget.answers}', style: AppTextStyles.boldPrimary16,),
          ),
        ),
      ),
    );
  }
}