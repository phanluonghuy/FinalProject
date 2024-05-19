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
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              Text("Lession completed!", style: AppTextStyles.bold26.copyWith(color: AppTheme.primaryColor),),
              SizedBox(height: 18,),
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'images/cat_full.png',
                    height: 150,
                  )),
              SizedBox(height: 18,),
              Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.primaryColor, //                   <--- border color
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  height: 180,
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Expanded(child: SizedBox()),
                      Expanded(child: Center(child:
                        Text("👉 ${((_cardCorrect.length*10-_cardInCorrect.length*2) > 0 ? _cardCorrect.length*10-_cardInCorrect.length*5 : 0 ).toString()}",style: AppTextStyles.bold26),))
                    ],
                  )
                ),
                Container(
                  height: 90,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                  ),
                  child: Center(child: Text("Score",style: AppTextStyles.boldWhite26,),),
                ),
              ],),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Stack(children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green, //                   <--- border color
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: 180,
                          child: Column(
                            children: [
                              Expanded(child: SizedBox()),
                              Expanded(child: Center(child:
                              Text("✅ ${_cardCorrect.length}",style: AppTextStyles.bold26),))
                            ],
                          )
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(
                            color: Colors.green,
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        ),
                        child: Center(child: Text("Correct",style: AppTextStyles.boldWhite18,),),
                      ),
                    ],),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Stack(children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red, //                   <--- border color
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: 180,
                          child: Column(
                            children: [
                              Expanded(child: SizedBox()),
                              Expanded(child: Center(child:
                              Text("❌ ${_cardInCorrect.length}",style: AppTextStyles.bold26),))
                            ],
                          )
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(
                            color: Colors.red,
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        ),
                        child: Center(child: Text("Incorrect",style: AppTextStyles.boldWhite18,),),
                      ),

                    ],),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Stack(children: [
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.orange, //                   <--- border color
                                width: 3.0,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(20))
                          ),
                          height: 180,
                          child: Column(
                            children: [
                              Expanded(child: SizedBox()),
                              Expanded(child: Center(child:
                              Text("${_feedback}",style: AppTextStyles.bold16),))
                            ],
                          )
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          border: Border.all(
                            color: Colors.orange,
                            width: 5.0,
                          ),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                        ),
                        child: Center(child: Text("Feedback",style: AppTextStyles.boldWhite18,),),
                      ),

                    ],),
                  )
                ],
              )
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: AppTheme.primaryColor
              //   ),
              //   child: Padding(
              //       padding: EdgeInsets.all(16),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text('Score:', style: AppTextStyles.boldWhite20,),
              //           Text('Correct:', style: AppTextStyles.boldWhite20,),
              //           Text('Incorrect:', style: AppTextStyles.boldWhite20,),
              //           Text('Feedback:', style: AppTextStyles.boldWhite20,),
              //         ],
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text('${_cardCorrect.length * 10}', style: AppTextStyles.boldWhite20,),
              //           Text('${_cardCorrect.length}', style: AppTextStyles.boldWhite20,),
              //           Text('${_cardInCorrect.length}', style: AppTextStyles.boldWhite20,),
              //           Text('${_feedback}', style: AppTextStyles.boldWhite20,),
              //         ],
              //       ),
              //     ],
              //   ),),
              // ),
              // SizedBox(height: 16,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Text('Correct', style: AppTextStyles.boldPrimary20,),
              //     Text('Incorrect', style: AppTextStyles.boldPrimary20,),
              //   ],
              // ),
              // SizedBox(height: 12,),
              // Container(
              //   alignment: Alignment.topCenter,
              //   height: 390,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Expanded(
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           itemBuilder: (ctx, idx) => CardTypeWordResultPage(
              //             cardModel: _cardCorrect[idx],
              //             answer: _correctAnswer[idx],
              //           ),
              //           itemCount: _cardCorrect.length,
              //         ),
              //       ),
              //       Expanded(
              //         child: ListView.builder(
              //           shrinkWrap: true,
              //           itemBuilder: (ctx, idx) => CardTypeWordResultPage(
              //             cardModel: _cardInCorrect[idx],
              //             answer: _inCorrectAnswer[idx],
              //           ),
              //           itemCount: _cardInCorrect.length,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               shape: RoundedRectangleBorder(
              //                 side: BorderSide(color: AppTheme.primaryColor, width: 2),
              //                 borderRadius: BorderRadius.circular(20)
              //               )
              //             ).copyWith(
              //               backgroundColor: MaterialStatePropertyAll(Colors.white)
              //             ),
              //             onPressed: (){
              //               Navigator.pop(context, {'newIndex': 0});
              //         }, child: Text('Restart Test', style: AppTextStyles.bold16,)),
              //       ),
              //     ),
              //
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //                 shape: RoundedRectangleBorder(
              //                     side: BorderSide(color: AppTheme.primaryColor, width: 2),
              //                     borderRadius: BorderRadius.circular(20)
              //                 )
              //             ).copyWith(
              //                 backgroundColor: MaterialStatePropertyAll(Colors.white)
              //             ),
              //             onPressed: (){
              //               // Navigator.push(context,
              //               // MaterialPageRoute(builder: (ctx) => TopicDetailPage(topic: widget.topic)),);
              //               Navigator.pop(context, {'newIndex': -1});
              //             }, child: Text('New Test', style: AppTextStyles.bold16,)),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 16,right: 8,bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context, {'newIndex': 0});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Rounded corners
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Restart",
                          style: AppTextStyles.bold16.copyWith(color: AppTheme.primaryColor)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context, {'newIndex': -1});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Rounded corners
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("Confirm",
                          style: AppTextStyles.bold16.copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
