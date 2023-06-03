class Question {
  final String answer_id,  asker_name, question, question_id, tag,question_description;
  final bool answered;
  Question(this.answer_id, this.answered, this.asker_name, this.question,
      this.question_id, this.tag,this.question_description);
  factory Question.fromRTDB(Map<String, dynamic> questionItem){
    return Question(
        questionItem["answer_id"],
        questionItem["answered"],
        questionItem['asker_name'],
        questionItem['question'],
        questionItem['question_id'],
        questionItem["tag"],
        questionItem["question_description"]);
  }
}
