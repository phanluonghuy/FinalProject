import 'dart:math';

import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class FlashCardItemPage extends StatefulWidget {
  CardModel card;
  FlashCardItemPage({super.key, required this.card});

  @override
  State<FlashCardItemPage> createState() => _FlashCardItemPageState();
}

class _FlashCardItemPageState extends State<FlashCardItemPage> with TickerProviderStateMixin {

  bool isTerm = true;
  late FlipCardController _controller;

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
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
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
                child: FlipCard(
                  controller: _controller,
                  front: _cardItem('${widget.card.term}'),

                  back: _cardItem('${widget.card.definition}')
                ),
        )
    );
  }
}
