import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/flash_card/bottom_sheet_options.dart';
import 'package:finalproject/common/widgets/type_word/result_type_word_page.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:finalproject/reuseable/constants/ToastMessage.dart';
import 'package:flutter/material.dart';

class TypeWordPage extends StatefulWidget {
  TopicModel topic;
  TypeWordPage({super.key, required this.topic});

  @override
  State<TypeWordPage> createState() => _TypeWordPageState();
}

class _TypeWordPageState extends State<TypeWordPage> {
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
      cards = await _topicRepo.getCardsByStar(topicID);
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

  void handleSubmit() async {
    if(_textEditingController.text.isEmpty){
      ToastMessage().showToastFailed("Please enter definition !!");
    }
    else if(_textEditingController.text == _cards[index].definition && isTerm == true){
      if(index + 1 >= _cards.length){
        index = _cards.length - 1;
        _cardCorrect.add(_cards[index]);
        _correctAnswer.add(_textEditingController.text);
        _textEditingController.clear();
        ToastMessage().showToastSuccess("Correct answer !!");
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
          index = index + 1;
          question = _cards[index].definition ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${index + 1 >= _cards.length? _cards.length: index + 1} / ${_cards.length}", style: TextStyle(fontWeight: FontWeight.bold),),
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.bgTypeWordMode,
                  borderRadius: BorderRadius.circular(10)
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
                              Text('Question:', style: TextStyle(color: AppTheme.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                              SizedBox(width: 16,),
                              isTerm ? Text('${question}', style: AppTextStyles.bold16,):
                              Text('${question}', style: AppTextStyles.bold16,)
                            ],
                          ),
                        ),
                        Container(
                          child: IconButton(onPressed: (){
                              TextToSpeech().speakEng("${_cards[index].term}");
                          }, icon: Icon(Icons.keyboard_voice_outlined)),
                        ),
                      ],),
                      SizedBox(height: 24,),
                      Row(children: [
                        Text('Answer:', style: TextStyle(color: AppTheme.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),),
                        SizedBox(width: 16,),
                        // Text('Data', style: AppTextStyles.bold16,)
                      ],),
                      SizedBox(height: 16,),
                      Form(
                        key: _key,
                        child: TextFormField(
                          controller: _textEditingController,

                          decoration: InputDecoration(
                            // label: Text('Answer'),
                            hintText: ("Typing your answer"),
                            hintStyle: TextStyle(
                              color: AppTheme.primaryColor
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text("Note: You need to enter the correct number of words and order of the definitions you have learned!!",
                      style: TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24,),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: AppTheme.primaryColor, width: 1, style: BorderStyle.solid)
                      ),

                    ).copyWith(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        handleSubmit();
                      });
                  }, child: Text("Next", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor, fontSize: 20),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
