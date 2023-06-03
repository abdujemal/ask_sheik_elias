import 'package:ask_sheik_elias/Model/questions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AnswerPage extends StatefulWidget {
  Question question;
  
  AnswerPage(this.question);

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  var answer = {};
  final tagsWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference answerRef = FirebaseDatabase.instance.reference().child("Answers").child(widget.question.answer_id);
    answerRef.once().then((snapshot) {
      setState(() {
        answer = snapshot.value;
      });
    });

    final tagsList = widget.question.tag.split(",");

    for(var tag in tagsList){
      tagsWidgets.add(
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Chip(label: Text(tag, style: TextStyle(color: Colors.white),),backgroundColor: Colors.orange,),
          )
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Answer Page"),),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

             Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Text(
                                widget.question.question,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                widget.question.question_description,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Spacer(),
                                  ...tagsWidgets
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          child: Text(widget.question.asker_name.substring(0, 1)),
                        ),
                        Text(widget.question.asker_name)
                      ],
                    )
                  ],
                ),
              SizedBox(height: 16,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Text("S"),
                      ),
                      SizedBox(height: 10,),
                      Text("Sheik Elias\nAhmed")
                    ],
                  ),
                  SizedBox(width: 20,),
                  Expanded(
                    child: Card(

                      elevation: 6,
                      child: Container(
                        height: 200,
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text(answer.length != 0 ?
                              answer["answer"] : "",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                 ],
               ),
            ],
          ),
        ),
      ),
    );
  }
}
