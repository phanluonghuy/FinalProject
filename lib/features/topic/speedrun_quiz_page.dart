import 'dart:async';

import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/flash_card/bottom_sheet_options.dart';
import 'package:finalproject/common/widgets/speedrun_quiz/speedrun_item.dart';
import 'package:finalproject/common/widgets/type_word/result_type_word_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/record_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/reuseable/constants/Responsive.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SpeedrunQuizPage extends StatefulWidget {
  TopicModel topic;
  SpeedrunQuizPage({super.key, required this.topic});

  @override
  State<SpeedrunQuizPage> createState() => _SpeedrunQuizPageState();
}

class _SpeedrunQuizPageState extends State<SpeedrunQuizPage> {
  TopicRepo _topicRepo = TopicRepo();
  UserRepo _userRepo = UserRepo();

  List<CardModel> _cards = [];
  List<CardModel> _cardsStar = [];
  List<String> _answers = [];
  final _currentUser = FirebaseAuth.instance.currentUser!;

  List<CardModel> _cardCorrect = [];
  List<CardModel> _cardInCorrect = [];
  List<String> _correctAnswer = [];
  List<String> _inCorrectAnswer = [];
  int index = 0;
  bool isShuffle = false;
  bool isTerm = true;
  bool isAll = true;
  String _term = '';
  String _definition = '';

  int _initialSeconds = 0;
  int _timeRemaining = 0;
  Timer? _timer;


  Future<void> _getCards(index) async {
    _answers.clear();
    String topicID = widget.topic.id ?? '';
    List<CardModel> cards = await _topicRepo.getAllCardsForTopic(topicID);
    _cardsStar = cards;
    if(isAll == false){
      cards = await _topicRepo.getCardsByStar(topicID);
    }
    if(isShuffle == true){
      cards.shuffle();
    }

    setState(() {
      _cards = cards;
      _term = _cards[index].term!;
      _definition = _cards[index].definition!;

      if(isTerm == false){
        _term = _cards[index].definition!;
        _definition = _cards[index].term!;
        _answers.add(_cards[index].term!);
      } else{
        _answers.add(_cards[index].definition!);
      }
    });
    Future.delayed(Duration(milliseconds: 1500), (){
      TextToSpeech().speakEng("What is ${_term} mean");

    });

    int count = 0;
    if(isAll == true){
      for(int i = 0; i < _cards.length; i++){
        if(count == 3){
          break;
        }
        if(_cards[index].term == _cards[i].term){
          continue;
        }else{
          if(isTerm == true){
            _answers.add(_cards[i].definition!);
          } else{
            _answers.add(_cards[i].term!);
          }
          count++;
        }
      }
    } else{
      for(int i = 0; i < _cardsStar.length; i++){
        if(count == 3){
          break;
        }
        if(_cards[index].term == _cardsStar[i].term){
          continue;
        }else{
          if(isTerm == true){
            _answers.add(_cardsStar[i].definition!);
          } else{
            _answers.add(_cardsStar[i].term!);
          }
          count++;
        }
      }
    }

    _answers.shuffle();

  }

  void addRecord(){
    String ownerId = widget.topic.ownerID!;
    String topicId = widget.topic.id!;
    int score = _cardCorrect.length * 10;
    double _percentageCorrect = (_cardCorrect.length * 100 / (_cardCorrect.length + _cardInCorrect.length));

    int expGained = _cardCorrect.length;
    _userRepo.addExpForUser(_currentUser.uid, expGained);
    _topicRepo.addRecord(new RecordModel(userID: _currentUser.uid, score: score, time: _timeRemaining, percent: _percentageCorrect.toInt()), topicId);
  }

  @override
  void initState() {
    // TODO: implement initState
    index = 0;
    _getCards(index);
    _timeRemaining = _initialSeconds;
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _timeRemaining++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: AppTheme.primaryColor,
          title: Text('${index + 1} / ${_cards.length}', style: AppTextStyles.boldWhite20,),
          actions: [
            Container(

                margin: EdgeInsets.only(right: 24),
                child: Text('${_timeRemaining.toString().padLeft(2, '0')}', style: AppTextStyles.boldWhite16,))
            // IconButton(onPressed: (){
            //     showModalBottomSheet(context: context,
            //         builder: (ctx) => BottomSheetOptionsPage(
            //             topic: widget.topic,
            //             isTermMain: isTerm,
            //             isAllMain: isAll)
            //     ).then((value){
            //       if(value['isShuffle'] != null){
            //         setState(() {
            //           isShuffle = value['isShuffle'];
            //           isTerm = value['isTerm'];
            //           isAll = value['isAll'];
            //           _getCards(index);
            //         });
            //       } else{
            //         setState(() {
            //           isShuffle = false;
            //           isTerm = value['isTerm'];
            //           isAll = value['isAll'];
            //           _getCards(index);
            //         });
            //       }
            //     });
            // }, icon: Icon(Icons.more_vert)),
          ],
        ),
      body: Container(
        alignment: Alignment.center,
        child: IntrinsicHeight(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: Responsive().isPC(context)? 500: null,
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(20)
                ),
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Question:', style:AppTextStyles.boldWhite20),
                          // SizedBox(width: 16,),

                          // Text('${_term}', style: AppTextStyles.boldWhite18,),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${index + 1}. ${_term}', style: AppTextStyles.boldWhite16,),
                          IconButton(onPressed: (){
                            TextToSpeech().speakEng('What is ${_term}');
                          }, icon: Icon(Icons.keyboard_voice_outlined, color: Colors.white,))
                        ],
                      ),
                      SizedBox(height: 16,),
                      Container(
                        height: 230,
                        child: ListView.builder(
                            itemBuilder: (ctx, idx)  => SpeedrunItemPage(
                              returnData: (data) async {
                                if(data['index'] > _cards.length - 1){
                                  addRecord();
                                  var newIndex = await Navigator.push(context,
                                    MaterialPageRoute(builder: (ctx) => ResultTypeWordPage(
                                        topic: widget.topic,
                                        cardCorrect: _cardCorrect,
                                        cardInCorrect: _cardInCorrect,
                                        correctAnswer: _correctAnswer,
                                        inCorrectAnswer: _inCorrectAnswer,))
                                  );
                                  if(newIndex['newIndex'] == 0){
                                    setState(() {
                                      index = newIndex['newIndex'];
                                      _cardCorrect.clear();
                                      _cardInCorrect.clear();
                                      _correctAnswer.clear();
                                      _inCorrectAnswer.clear();
                                      _answers.clear();
                                      _getCards(index);
                                    });
                                  }else{
                                    Navigator.pop(context);
                                  }

                                }else{
                                  setState(() {
                                    index = data['index'];
                                    _answers.clear();
                                    _getCards(index);
                                  });
                                }
                              },
                              answers: _answers[idx],
                              index: index,
                              definition: _definition,
                              card: _cards[index],
                                cardCorrect: _cardCorrect,
                                cardInCorrect: _cardInCorrect,
                                correctAnswer: _correctAnswer,
                                inCorrectAnswer: _inCorrectAnswer,
                                timeRemainning: _timeRemaining,
                            ),
                            itemCount: _answers.length,
                        ),
                      ),
                    ],
                  ),
              ),
          ),
          ),
        ),
      ),
    );
  }
}
