import 'package:ask_sheik_elias/Drawer/main_drawer.dart';
import 'package:ask_sheik_elias/Model/questions.dart';
import 'package:ask_sheik_elias/Providers/theme_provider.dart';
import 'package:ask_sheik_elias/Screens/add_question.dart';
import 'package:ask_sheik_elias/Widget/questionItem.dart';
import 'package:ask_sheik_elias/Widget/search_delegate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionsPage extends StatefulWidget {
  final ThemeModel? model;
  const QuestionsPage({this.model});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  DatabaseReference questionsRef = FirebaseDatabase.instance.reference();

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  int numOfQuestion = 6;

  List<Question> searchQuestions = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _lastIntegerSelected;
  
  DatabaseReference searchRef = FirebaseDatabase.instance.reference().child("Questions");


  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if(mounted)
      setState(() {
        numOfQuestion += 5;
        print(numOfQuestion);

      });
    _refreshController.loadComplete();
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setTheme();

    searchRef.once().then((snapshot) {
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for(var key in keys) {
        Question question =
        Question(
            values[key]["answer_id"],
            values[key]["answered"],
            values[key]["asker_name"],
            values[key]["question"],
            values[key]["question_id"],
            values[key]["tag"],
            values[key]["question_description"]);
        searchQuestions.add(question);
      }

    });
    
  }
  void setTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeCode = (prefs.getInt('theme') ?? 0);
    await prefs.setInt('theme', themeCode);
    String lang = (prefs.getString("lang")??"en");

    if(themeCode == 0){
      widget.model!.toLightMode();
    }else{
      widget.model!.toDarkMode();
    }

    if(lang == "en"){
      widget.model!.toEN();
    }else if(lang == "am"){
      widget.model!.toAM();
    }else{
      widget.model!.toAR();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: MainDrawer(model:widget.model),),
      key: _scaffoldKey,
      appBar: AppBar(title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.help_outline_rounded),
          SizedBox(width: 15,),
          // SvgPicture.asset("assets/icons/question-circle-solid.svg"),
          Text(AppLocalizations.of(context)!.asksheikelias),
        ],
      ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {

                if(!searchQuestions.isEmpty){

                  final int? selected = await showSearch<int?>(
                    context: context,
                    delegate: QuestionsSearchDelegate(searchQuestions),
                  );
                  if (selected != null && selected != _lastIntegerSelected) {
                    setState(() {
                      _lastIntegerSelected = selected;
                    });

                    }
                  }
                },
              icon: Icon(Icons.search))
        ],
        leading: IconButton(
          onPressed: (){
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu_outlined),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddQuestion()));
        },
        child: Icon(Icons.add),
        tooltip: "Press to ask questions",
      ),

      body: StreamBuilder(
                stream: questionsRef.child("Questions").limitToFirst(numOfQuestion).onValue,
                builder: (context, snapshot) {
                  final List<Question> questionList = [];
                  if (snapshot.hasData) {
                    final questionMap = Map<String, dynamic>.from(
                        (snapshot.data! as Event).snapshot.value);
                    questionMap.forEach((key, value) {
                      final questionItem = Map<String, dynamic>.from(value);
                      final questionModel = Question.fromRTDB(questionItem);
                      if(questionItem["answered"]==true){
                        questionList.add(questionModel);
                      }
                    });
                  }
                  return SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    footer: CustomFooter(
                      height: 80,
                      builder: (context,mode){
                        Widget body ;
                        if(mode==LoadStatus.idle){
                          body =  SizedBox();
                        }
                        else if(mode==LoadStatus.loading){
                          body =  CupertinoActivityIndicator();
                        }
                        else if(mode == LoadStatus.failed){
                          body = Text("Load Failed!Click retry!");
                        }
                        else if(mode == LoadStatus.canLoading){
                          body = Text("release to load more");
                        }
                        else{
                          body = Text("No more Data");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child:body),
                        );
                      }
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      // controller: ScrollController(initialScrollOffset: 5),
                        itemCount: questionList.length,
                        itemBuilder: (context, index) =>
                            QuestionItem(questionList[index],questionList.length,index),

                    ),
                  );
                }
              ),
    );

  }


}
