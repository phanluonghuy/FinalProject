import 'dart:math';

import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/reuseable/constants/TextToSpeech.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FlashCardItemPage extends StatefulWidget {
  CardModel card;
  bool isShuffle;
  bool isTerm;
  bool isAll;
  FlashCardItemPage({super.key, required this.card, required this.isShuffle, required this.isTerm, required this.isAll});

  @override
  State<FlashCardItemPage> createState() => _FlashCardItemPageState();
}

class _FlashCardItemPageState extends State<FlashCardItemPage> with TickerProviderStateMixin {

  late FlipCardController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  Widget _cardItem(String text){
    return GestureDetector(
      onTap: (){
        // setState(() {
        _controller.toggleCard();
        // });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
            child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: EdgeInsets.all(16),
                child: Stack(
                  children: [
                    FlipCard(
                      controller: _controller,
                      front: Stack(
                        children:[ GestureDetector(
                          onTap: (){
                            setState(() {
                              isFront = true;
                            });
                          },
                          child: widget.isTerm? _cardItem('${widget.card.term}'): _cardItem('${widget.card.definition}'),
                        ),
                          Positioned(
                            left: -120,
                            top: 50,
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -120,
                            top: 300,
                            child: Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),]
                      ),


                      back: GestureDetector(
                        onTap: (){
                          setState(() {
                            print("helo");
                            isFront = false;
                          });
                        },
                        child: widget.isTerm? _cardItem('${widget.card.definition}'): _cardItem('${widget.card.term}'),

                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: IconButton(
                        icon: Icon(CupertinoIcons.speaker_2, color: Colors.white, size: 40,),
                        onPressed: () {
                          print(isFront);
                          if(isFront == true){
                            TextToSpeech().speakEng("${widget.card.term}");
                          }else{
                            TextToSpeech().speakVie("${widget.card.definition}");
                          }
                        },
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("Tap to Flip",style: AppTextStyles.boldWhite20,)
                      ),
                    ),

                  ],
                ),
        )
    );
  }
}
