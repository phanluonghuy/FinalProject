import 'package:audioplayers/audioplayers.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/flash_card/bottom_sheet_options.dart';
import 'package:finalproject/common/widgets/type_word/result_type_word_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/reuseable/constants/Responsive.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:finalproject/reuseable/constants/ToastMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TypeWordPage extends StatefulWidget {
  TopicModel topic;
  List<CardModel> cardsStar;
  TypeWordPage({super.key, required this.topic, required this.cardsStar});

  @override
  State<TypeWordPage> createState() => _TypeWordPageState();
}

class _TypeWordPageState extends State<TypeWordPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  TopicRepo _topicRepo = TopicRepo();

  int index = 0;
  bool isTerm = true;
  bool isAll = true;
  bool isShuffle = false;
  List<CardModel> _cards = [];
  List<CardModel> _cardCorrect = [];
  List<CardModel> _cardInCorrect = [];
  List<String> _correctAnswer = [];
  List<String> _inCorrectAnswer = [];
  TextEditingController _textEditingController = TextEditingController();
  String question = "";
  var _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = 0;
    _getCards();
  }

  Future<void> _getCards() async {
    String topicID = widget.topic.id ?? '';
    List<CardModel> cards = await _topicRepo.getAllCardsForTopic(topicID);

    if(isAll == false){
      // cards = await _topicRepo.getCardsByStar(topicID);
      cards = widget.cardsStar;
    }
    if(isShuffle == true){
      cards.shuffle();
    }

    setState(() {
      // print(cards[0].term);
      // print(cards[1].term);
      // print(cards[2].term);
      // print(cards[3].term);
      _cards = cards;
      question = _cards[index].term ?? "";
      if(isTerm == false){
        question = _cards[index].definition ?? "";
      }
    });
  }

  Future<void> _playSound(bool isCorrect) async {
    String audioPath = 'audio/correct.wav';
    isCorrect ? audioPath = 'audio/correct.wav' : audioPath = 'audio/wrong.mp3';
    await _audioPlayer.play(AssetSource(audioPath));
  }

  void handleSubmit() async {
    if(_textEditingController.text.isEmpty){
      ToastMessage().showToastFailed("Please enter definition !!");
      TextToSpeech().speakEng("Please enter definition");
    }
    else if(_textEditingController.text == _cards[index].definition && isTerm == true){
      if(index + 1 >= _cards.length){
        index = _cards.length - 1;
        _cardCorrect.add(_cards[index]);
        _correctAnswer.add(_textEditingController.text);
        _textEditingController.clear();
        ToastMessage().showToastSuccess("Correct answer !!");
        _playSound(true);
        var newIndex = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)   =>
                ResultTypeWordPage(
                  topic: widget.topic,
                  cardCorrect: _cardCorrect,
                  cardInCorrect: _cardInCorrect,
                  correctAnswer: _correctAnswer,
                  inCorrectAnswer: _inCorrectAnswer,
                ),
          ),
        );
        setState(() {
          if(newIndex['newIndex'] == 0){
            index = newIndex['newIndex'];
            print("index: $index" );
            _cardCorrect.clear();
            _cardInCorrect.clear();
            _correctAnswer.clear();
            _inCorrectAnswer.clear();
            _textEditingController.clear();
          }else{
            Navigator.pop(context);
          }

        });

      }else{
        setState(() {
          _cardCorrect.add(_cards[index]);
          _correctAnswer.add(_textEditingController.text);
          _textEditingController.clear();
          ToastMessage().showToastSuccess("Correct answer !!");
          _playSound(true);
          index = index + 1;
          question = _cards[index].term ?? "";
          // _getCards();
        });
      }
    }
    else if(_textEditingController.text == _cards[index].term && isTerm == false){
      if(index + 1 >= _cards.length){
        index = _cards.length - 1;
        _cardCorrect.add(_cards[index]);
        _correctAnswer.add(_textEditingController.text);
        _textEditingController.clear();
        ToastMessage().showToastSuccess("Correct answer !!");
        _playSound(true);
        var newIndex = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)   =>
                ResultTypeWordPage(
                  topic: widget.topic,
                  cardCorrect: _cardCorrect,
                  cardInCorrect: _cardInCorrect,
                  correctAnswer: _correctAnswer,
                  inCorrectAnswer: _inCorrectAnswer,
                ),
          ),
        );
        setState(() {
          if(newIndex['newIndex'] == 0){
            index = newIndex['newIndex'];
            print("index: $index" );
            _cardCorrect.clear();
            _cardInCorrect.clear();
            _correctAnswer.clear();
            _inCorrectAnswer.clear();
            _textEditingController.clear();
          }else{
            Navigator.pop(context);
          }

        });

      }else{
        setState(() {
          _cardCorrect.add(_cards[index]);
          _correctAnswer.add(_textEditingController.text);
          _textEditingController.clear();
          ToastMessage().showToastSuccess("Correct answer !!");
          _playSound(true);
          index = index + 1;
          question = _cards[index].definition ?? "";
          // _getCards();
        });
      }
    }
    else if(_textEditingController.text != _cards[index].definition && isTerm == true){
      if(index + 1 >= _cards.length){
        index = _cards.length - 1;
        _cardInCorrect.add(_cards[index]);
        _inCorrectAnswer.add(_textEditingController.text);
        _textEditingController.clear();
        ToastMessage().showToastFailed("Incorrect answer !!");
        _playSound(false);
        var newIndex = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)  =>
                ResultTypeWordPage(
                  topic: widget.topic,
                  cardCorrect: _cardCorrect,
                  cardInCorrect: _cardInCorrect,
                  correctAnswer: _correctAnswer,
                  inCorrectAnswer: _inCorrectAnswer,
                ),
          ),
        );
        setState(() {
          if(newIndex['newIndex'] == 0){
            index = newIndex['newIndex'];
            _cardCorrect.clear();
            _cardInCorrect.clear();
            _correctAnswer.clear();
            _inCorrectAnswer.clear();
            _textEditingController.clear();
          }else{
            Navigator.pop(context);
          }

        });
      }else{
        setState(() {
          _cardInCorrect.add(_cards[index]);
          _inCorrectAnswer.add(_textEditingController.text);
          _textEditingController.clear();
          ToastMessage().showToastFailed("Incorrect answer !!");
          _playSound(false);
          index = index + 1;
          question = _cards[index].term ?? "";
          // _getCards();
        });
      }
    }
    else{
      if(index + 1 >= _cards.length){
        index = _cards.length - 1;
        _cardInCorrect.add(_cards[index]);
        _inCorrectAnswer.add(_textEditingController.text);
        _textEditingController.clear();
        ToastMessage().showToastFailed("Incorrect answer !!");
        _playSound(false);
        var newIndex = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)  =>
                ResultTypeWordPage(
                  topic: widget.topic,
                  cardCorrect: _cardCorrect,
                  cardInCorrect: _cardInCorrect,
                  correctAnswer: _correctAnswer,
                  inCorrectAnswer: _inCorrectAnswer,
                ),
          ),
        );
        setState(() {
          if(newIndex['newIndex'] == 0){
            index = newIndex['newIndex'];
            _cardCorrect.clear();
            _cardInCorrect.clear();
            _correctAnswer.clear();
            _inCorrectAnswer.clear();
            _textEditingController.clear();
          }else{
            Navigator.pop(context);
          }

        });
      }else{
        setState(() {
          _cardInCorrect.add(_cards[index]);
          _inCorrectAnswer.add(_textEditingController.text);
          _textEditingController.clear();
          ToastMessage().showToastFailed("Incorrect answer !!");
          _playSound(false);
          index = index + 1;
          question = _cards[index].definition ?? "";
        });
      }
    }
  }

  Widget _stepProgress(_currentStep) {
    return StepProgressIndicator(
      totalSteps: (_cards.length-1 > 0) ? _cards.length-1  : 1 ,
      currentStep: _currentStep,
      size: 10,
      padding: 0,
      selectedColor: AppTheme.primaryColor,
      unselectedColor: AppTheme.primaryColor2,
      roundedEdges: Radius.circular(20),
      selectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppTheme.primaryColor.withOpacity(0.5), AppTheme.primaryColor],
      ),
      unselectedGradientColor: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.grey.shade200],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // backgroundColor: AppTheme.primaryColor,
        // title: Text("${index + 1 >= _cards.length? _cards.length: index + 1} / ${_cards.length}", style: AppTextStyles.boldWhite20,),
        title: _stepProgress(index),
        actions: [
          IconButton(
              onPressed: () {
                 showModalBottomSheet(context: context,
                    builder: (ctx) => BottomSheetOptionsPage(
                        topic: widget.topic,
                        isTermMain: isTerm,
                        isAllMain: isAll)
                ).then((value){
                   if(value['isShuffle'] != null){
                     setState(() {
                       isShuffle = value['isShuffle'];
                       isTerm = value['isTerm'];
                       isAll = value['isAll'];
                       _getCards();
                     });
                   } else{
                     setState(() {
                       isShuffle = false;
                       isTerm = value['isTerm'];
                       isAll = value['isAll'];
                       _getCards();
                     });
                   }
                 });
              }, icon: Icon(Icons.more_vert))
        ],
      ),
      body: _cards.length == 0?

      CircularProgressIndicator():

      Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            width: Responsive().isPC(context) ? 500: null,
            child: IntrinsicHeight(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      // color: AppTheme.primaryColor,
                      border: Border.all(color: AppTheme.primaryColor, width: 3),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                children: [
                                  Text('Question:', style: AppTextStyles.bold20,),

                                ],
                              ),
                            ),

                          ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text('${index + 1}. What is "${question}" mean:', style: AppTextStyles.bold16,),
                            Container(
                              child: IconButton(onPressed: (){
                                TextToSpeech().speakEng("What is ${question} mean");
                              }, icon: Icon(CupertinoIcons.speaker_2, color: Colors.black,)),
                            ),

                              // SizedBox(width: 16,),
                            // Text('Data', style: AppTextStyles.bold16,)
                          ],),
                          SizedBox(height: 8,),
                          Form(
                            key: _key,
                            child: TextFormField(
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                // label: Text('Answer'),

                                suffixIcon: Icon(Icons.question_answer_outlined),
                                hintText: ("Typing your answer"),
                                hintStyle: TextStyle(
                                  // color: AppTheme.primaryColor
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Text("Note: You need to enter the correct number of words and order of the definitions you have learned!!",
                          style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold, fontFamily: 'Lato'),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () => {
                                setState(() {
                                  handleSubmit();
                                })
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(40), // Rounded corners
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text("Next",
                            style: AppTextStyles.bold16
                                .copyWith(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
