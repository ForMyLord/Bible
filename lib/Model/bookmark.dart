class BookMark {
  final String bible;
  final String setTime;
  final int chapter;
  final int verse;
  final int id;

  BookMark({required this.id,required this.bible, required this.chapter,required this.verse,required this.setTime});

  Map<String,dynamic> toMap() {
    return {
      'id' : id,
      'bible' : bible,
      'chapter' : chapter,
      'verse' : verse,
      'setTime' : setTime
    };
  }
}