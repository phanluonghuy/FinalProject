import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:flutter/material.dart';

class CardItemPage extends StatefulWidget {
  CardModel card;
  CardItemPage({super.key, required this.card});

  @override
  State<CardItemPage> createState() => _CardItemPageState();
}

class _CardItemPageState extends State<CardItemPage> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            // color: AppTheme.grey5,
            border: Border.all(color: AppTheme.grey3, width: 1, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Term: ${widget.card.term}', style: AppTextStyles.bold16,),
                    Text('Definition: ${widget.card.definition}', style: AppTextStyles.bold16),
                    // Text('Description: ${widget.card.imgUrl}'),
                    // Text('Term: ${widget.card.term}'),
                  ],
                ),

                IconButton(
                    onPressed: (){

                    }, icon: Icon(Icons.star_border))
              ],
            ),
          ),
        ),
    );
  }
}
