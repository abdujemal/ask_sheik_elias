import 'package:ask_sheik_elias/Model/questions.dart';
import 'package:ask_sheik_elias/Screens/answer_page.dart';
import 'package:flutter/material.dart';

class QuestionsSearchDelegate extends SearchDelegate<int?> {
  final List<Question> _data;
  final List<Question> _history = [];
  QuestionsSearchDelegate(this._data);


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {


    List<String> suggestions = [];
    List<Question> questions = [];
    if(!query.isEmpty){
      for(var question in _data){
        if(question.question.contains(query)){
          suggestions.add(question.question);
          questions.add(question);
        }
      }
    }else{
      suggestions = [];
    }





    return _SuggestionList(
      questions: questions,
      query: query,
      suggestions: suggestions.map<String>((String i) => i).toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox();
    // final int? searched = int.tryParse(query);
    // if (searched == null || !_data.contains(searched)) {
    //   return Center(
    //     child: Text(
    //       '"$query"\n is not a valid integer between 0 and 100,000.\nTry again.',
    //       textAlign: TextAlign.center,
    //     ),
    //   );
    // }
    //
    // return ListView(
    //   children: <Widget>[
    //     _ResultCard(
    //       title: 'This integer',
    //       integer: searched,
    //       searchDelegate: this,
    //     ),
    //     _ResultCard(
    //       title: 'Next integer',
    //       integer: searched + 1,
    //       searchDelegate: this,
    //     ),
    //     _ResultCard(
    //       title: 'Previous integer',
    //       integer: searched - 1,
    //       searchDelegate: this,
    //     ),
    //   ],
    // );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isEmpty)
        SizedBox()
        // IconButton(
        //   tooltip: 'Voice Search',
        //   icon: const Icon(Icons.mic),
        //   onPressed: () {
        //     query = 'Implement voice input';
        //   },
        // )
      else
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
  //
  // @override
  // PreferredSizeWidget buildBottom(BuildContext context) =>
  //     const PreferredSize(
  //       preferredSize: Size.fromHeight(56.0),
  //       child: Text('Numbers'),
  //     );

}

class _ResultCard extends StatelessWidget {
  const _ResultCard({this.integer, this.title, this.searchDelegate});

  final int? integer;
  final String? title;
  final SearchDelegate<int?>? searchDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        searchDelegate!.close(context, integer);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title!),
              Text(
                '$integer',
                style: theme.textTheme.headline5!.copyWith(fontSize: 72.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {

  const _SuggestionList({this.questions, this.suggestions, this.query, this.onSelected});

  final List<String>? suggestions;
  final String? query;
  final ValueChanged<String>? onSelected;
  final List<Question>? questions;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions!.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions![i];
        return ListTile(
          leading: query!.isEmpty ? const Icon(Icons.history) : const Icon(
              null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query!.length),
              style: theme.textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query!.length),
                  style: theme.textTheme.subtitle1,
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AnswerPage(questions![i])));
          },
        );
      },
    );
  }
}
