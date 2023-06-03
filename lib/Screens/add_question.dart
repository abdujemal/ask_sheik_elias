import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddQuestion extends StatefulWidget {

  const AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  var _key = GlobalKey<FormState>();

  var _fullNameController = TextEditingController();

  var _questionTitleController = TextEditingController();

  var _questionDescriptionController = TextEditingController();

  var _tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.keyboard_backspace),),
                Container(
                    child: Center(

                      child: Padding(
                        padding: const EdgeInsets.only(top: 50,bottom: 50),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.help_outline_rounded),
                            SizedBox(width: 15,),
                            // SvgPicture.asset("assets/icons/question-circle-solid.svg"),
                            Text(AppLocalizations.of(context)!.asksheikelias, style: TextStyle(fontSize: 30),),
                          ],
                        ),
                      ),
                    ),
                  ),
                Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.fullname,
                        style: TextStyle(
                            fontSize: 15,),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        controller: _fullNameController,
                        validator: (s) {
                          if (s!.isEmpty) {
                            return AppLocalizations.of(context)!.please_Enter_your_Full_Name;
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.mohamedabdlah,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.withOpacity(.1)))),
                      ),
                      SizedBox(height: 16,),
                      Text(
                        AppLocalizations.of(context)!.question_title,
                        style: TextStyle(
                            fontSize: 15,),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _questionTitleController,
                        validator: (s) {
                          if (s!.isEmpty) {
                            return AppLocalizations.of(context)!.please_Enter_your_question_title;
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.question_title,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.withOpacity(.1)))),
                      ),
                      SizedBox(height: 16,),
                      Text(
                        AppLocalizations.of(context)!.question_desc,
                        style: TextStyle(
                            fontSize: 15, ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _questionDescriptionController,
                        validator: (s) {
                          if (s!.isEmpty) {
                            return AppLocalizations.of(context)!.please_Enter_your_question_description;
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.describeyourquestionhere,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.withOpacity(.1)))),
                      ),
                      SizedBox(height: 16,),
                      Text(
                        AppLocalizations.of(context)!.tags,
                        style: TextStyle(
                            fontSize: 15, ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _tagsController,
                        validator: (s) {
                          if (s!.isEmpty) {
                            return AppLocalizations.of(context)!.please_Enter_your_question_tags;
                          }
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.writewhattopicareyouaskingabout,
                            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue.withOpacity(.1)))),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(AppLocalizations.of(context)!.sendquestion),
                            ),
                            onPressed: (){
                              if(_key.currentState!.validate()){
                                sendDataToServer(context);
                              }
                            },
                        ),
                      )
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

  void sendDataToServer(context) {
    DatabaseReference questionRef = FirebaseDatabase.instance.reference().child("Questions").push();
    final questionMap = <String, dynamic>{
      "answer_id": "",
      "answered": false,
      "asker_name": _fullNameController.text.replaceAll(" ", "\n"),
      "question": _questionTitleController.text,
      "question_description": _questionDescriptionController.text,
      "question_id": questionRef.key,
      "tag": _tagsController.text
    };
    questionRef.update(questionMap).then((value) {
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.you_have_successfully_sent_your_question_soon_it_will_be_answered, backgroundColor: Colors.green);

      Navigator.pop(context);
    }).catchError((error){
      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.error_Please_Try_again, backgroundColor: Colors.red);

    });

  }
}
