import 'package:finalproject/common/constants/strings.dart';
import 'package:finalproject/common/constants/text_styles.dart';
import 'package:finalproject/common/constants/theme.dart';
import 'package:finalproject/common/widgets/flash_card/bottom_sheet_options.dart';
import 'package:finalproject/common/widgets/flash_card/flash_card_item.dart';
import 'package:finalproject/models/card_model.dart';
import 'package:finalproject/models/topic_model.dart';
import 'package:finalproject/repositories/topic_repo.dart';
import 'package:finalproject/repositories/user_repo.dart';
import 'package:finalproject/reuseable/constants/Responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';



class FlashCardPage extends StatefulWidget {
  TopicModel topic;
  List<CardModel> cardsStar;
  FlashCardPage({super.key, required this.topic, required this.cardsStar});

  @override
  State<FlashCardPage> createState() => _FlashCardPageState();
}



class _FlashCardPageState extends State<FlashCardPage> {
  final _topicRepo = TopicRepo();
  late PageController _pageController;
  int index = 0;

  bool isTerm = true;
  bool isAll = true;
  bool isShuffle = false;
  
  List<CardModel> _cards = [];
  
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
      _cards = cards;
    });
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
  void initState() {
    // TODO: implement initState
    _getCards();
    _pageController = PageController(initialPage: index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Đặt màu của mũi tên thành màu trắng
        ),
        // backgroundColor: AppTheme.primaryColor,
        // title: Text("${index+1}/${_cards.length}", style: AppTextStyles.bold20,),
        title: _stepProgress(index),
        actions: [
          IconButton(
              onPressed: (){
                showModalBottomSheet(context: context, isScrollControlled: true,
                    builder: (ctx) {
                      return BottomSheetOptionsPage(
                        topic: widget.topic,
                        isTermMain: isTerm,
                        isAllMain: isAll,
                      );
                    }).then((value){
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

              },
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 700,
                  height: Responsive().isPC(context)? 600: 600,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() {
                      index = value;
                    }),
                      itemBuilder: (ctx, idx) => FlashCardItemPage(
                        card: _cards[index],
                        isShuffle: isShuffle,
                        isTerm: isTerm,
                        isAll: isAll,
                      ),
                      itemCount: _cards.length,
                  ),
                ),

                Container(
                  width: 700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          if(index - 1 < 0){
                            index = 0;
                          }else{
                            index--;
                          }
                        });
                      }, icon: Icon(Icons.arrow_back, size: 50,)),
                      IconButton(onPressed: (){
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          if(index + 1 >= _cards.length){
                            index = _cards.length - 1;
                          }else{
                            index++;
                          }
                        });
                      }, icon: Icon(Icons.arrow_forward, size: 50,))

                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
