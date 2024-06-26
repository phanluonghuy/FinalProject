import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardEditing extends StatelessWidget {
  final CardModel card;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const CardEditing({Key? key, required this.card, this.onEdit, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) {
              onEdit!();
            },
            icon: Icons.edit_outlined,
            foregroundColor: AppTheme.primaryColor,
          ),
          SlidableAction(
            onPressed: (BuildContext context) {
              onDelete!();
            },
            icon: Icons.delete_outline,
            foregroundColor: Colors.red,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.grey4, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text('TERM', style: AppTextStyles.bold12),
              SizedBox(height: 2),
              Text(
                card.term ?? '',
                style: AppTextStyles.bold16,
              ),
              SizedBox(height: 15),
              Text('DEFINITION', style: AppTextStyles.bold12),
              SizedBox(height: 2),
              Text(
                card.definition ?? '',
                style: AppTextStyles.bold16,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
