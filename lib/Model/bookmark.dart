class BookMark {
  final String bible;
  final String setTime;
  final int chapter;
  final int verse;
  final String content;

  BookMark({required this.bible, required this.chapter,required this.verse,required this.setTime, required this.content});

  Map<String,dynamic> toMap() {
    return {
      'bible' : bible,
      'chapter' : chapter,
      'verse' : verse,
      'setTime' : setTime,
      'content' : content
    };
  }
}