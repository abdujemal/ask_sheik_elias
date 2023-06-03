import 'package:ask_sheik_elias/Model/questions.dart';
import 'package:ask_sheik_elias/Screens/answer_page.dart';
import 'package:flutter/material.dart';

class QuestionItem extends StatelessWidget {
  Question question;
  int itemCount,index;
  QuestionItem(this.question,this.itemCount,this.index);

  @override
  Widget build(BuildContext context) {
    final tagsList = question.tag.split(",");
    final tagsWidgets = [];
    for(var tag in tagsList){
      tagsWidgets.add(
        Padding(
          padding: EdgeInsets.only(right: 5),
          child: Chip(label: Text(tag, style: TextStyle(color: Colors.white),),backgroundColor: Colors.orange,),
        )
      );
    }
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AnswerPage(question)));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      child: Text(question.asker_name.substring(0,1)),
                    ),
                    SizedBox(height: 3,),
                    Text(question.asker_name,style: TextStyle(fontSize: 12),)
                  ],
                ),
                SizedBox(width: 15,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(question.question,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                        SizedBox(height: 8,),
                        Text(question.question_description.substring(0,50)+"...",style: TextStyle(fontSize: 16, ),),
                        SizedBox(height: 8,),
                        Row(
                            children:[Spacer(),...tagsWidgets],
                          ),
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
