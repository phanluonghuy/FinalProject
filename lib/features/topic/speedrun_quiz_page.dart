import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/flash_card/bottom_sheet_options.dart';
import 'package:finalproject/common/widgets/speedrun_quiz/speedrun_item.dart';
import 'package:finalproject/common/widgets/type_word/result_type_word_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:flutter/material.dart';


class SpeedrunQuizPage extends StatefulWidget {
  TopicModel topic;
  SpeedrunQuizPage({super.key, required this.topic});

  @override
  State<SpeedrunQuizPage> createState() => _SpeedrunQuizPageState();
}

class _SpeedrunQuizPageState extends State<SpeedrunQuizPage> {
  TopicRepo _topicRepo = TopicRepo();
  List<CardModel> _cards = [];
  List<CardModel> _cardsStar = [];
  List<String> _answers = [];

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


  @override
  void initState() {
    // TODO: implement initState
    index = 0;
    _getCards(index);
    // term = _cards[index].term!;

    // _getWrongAnswers(index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${index + 1} / ${_cards.length}', style: AppTextStyles.bold20,),
          actions: [
            IconButton(onPressed: (){
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
                      _getCards(index);
                    });
                  } else{
                    setState(() {
                      isShuffle = false;
                      isTerm = value['isTerm'];
                      isAll = value['isAll'];
                      _getCards(index);
                    });
                  }
                });
            }, icon: Icon(Icons.more_vert)),
          ],
        ),
      body: IntrinsicHeight(
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.bgTypeWordMode,
                borderRadius: BorderRadius.circular(20)
              ),
            child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Question:', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                        SizedBox(width: 16,),
                        Text('${_term}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 16,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Answers', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 20),),
                        IconButton(onPressed: (){
                          TextToSpeech().speakEng('${_term}');
                        }, icon: Icon(Icons.keyboard_voice_outlined))
                      ],
                    ),
                    SizedBox(height: 16,),
                    Container(
                      height: 250,
                      child: ListView.builder(
                          itemBuilder: (ctx, idx)  => SpeedrunItemPage(
                            returnData: (data) async {
                              if(data['index'] > _cards.length - 1){
                                var newIndex = await Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) => ResultTypeWordPage(
                                      topic: widget.topic,
                                      cardCorrect: _cardCorrect,
                                      cardInCorrect: _cardInCorrect,
                                      correctAnswer: _correctAnswer,
                                      inCorrectAnswer: _inCorrectAnswer))
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
                              inCorrectAnswer: _inCorrectAnswer
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
    );
  }
}
