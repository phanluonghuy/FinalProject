import 'package:audioplayers/audioplayers.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:finalproject/reuseable/constants/ToastMessage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

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
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<CardModel> cardCorrect = [];
  List<CardModel> cardInCorrect = [];
  List<String> correctAnswer = [];
  List<String> inCorrectAnswer = [];
  bool isChoice = false;
  bool isCorrect = false;

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

  Future<void> _playSound(bool isCorrect) async {
    String audioPath = 'audio/correct.wav';
    isCorrect ? audioPath = 'audio/correct.wav' : audioPath = 'audio/wrong.mp3';
    await _audioPlayer.play(AssetSource(audioPath));
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  GestureDetector(
          onTap: () {
            setState(() {
              isChoice = true;
              if(widget.answers == widget.definition) {
                isCorrect = true;
              }
            });

            int count = 0;
            // Future.delayed(Duration(seconds: 1), (){
              if(isCorrect){
                _playSound(true);
                ToastService.showSuccessToast(
                  context,
                  length: ToastLength.short,
                  expandedHeight: 100,
                  message: "Correct answer ✔ !",
                );
                count = 1;
                cardCorrect.add(widget.card);
                correctAnswer.add(widget.definition);
              }else{
                _playSound(false);
                // ToastMessage().showToastFailed("Incorrect answer !!");
                ToastService.showErrorToast(
                  context,
                  length: ToastLength.short,
                  expandedHeight: 100,
                  message: "Incorrect answer !",
                );
                count = 2;
                cardInCorrect.add(widget.card);
                inCorrectAnswer.add(widget.answers);
              }
            // });
            Future.delayed(Duration(milliseconds: 500), () {
              onDataReturned(count);
            });


          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 100),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: (isCorrect) ? Colors.greenAccent : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (!isChoice) ? Colors.grey : (isCorrect ? Colors.green : Colors.redAccent),
                style: BorderStyle.solid,
                width:  isCorrect ? 3 : 1
              )
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text('${widget.answers}', style: AppTextStyles.bold18),
            ),
          ),
        ),
    );
  }
}
