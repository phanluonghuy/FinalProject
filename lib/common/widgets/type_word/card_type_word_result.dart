import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:flutter/material.dart';

class CardTypeWordResultPage extends StatefulWidget {
  CardModel cardModel;
  String answer;
  CardTypeWordResultPage({super.key, required this.cardModel, required this.answer});

  @override
  State<CardTypeWordResultPage> createState() => _CardTypeWordResultPageState();
}

class _CardTypeWordResultPageState extends State<CardTypeWordResultPage> {

  CardModel? card;
  String? answer;

  @override
  void initState() {
    // TODO: implement initState
    card = widget.cardModel;
    answer = widget.answer;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.primaryColor
        ),
        child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text('${card?.term}', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),),
                  SizedBox(height: 2,),
                  Text('${card?.definition}', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                  SizedBox(height: 12,),
                  Text('Your answer', style: TextStyle(color: Color.fromARGB(255, 240, 244, 147), fontWeight: FontWeight.bold),),
                  Text('${answer}', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
        ),
      ),
    );
  }
}
