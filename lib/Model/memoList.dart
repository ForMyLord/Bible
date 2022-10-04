class MemoList {
  final String title;
  final String content;
  final String setTime;
  final String id;

  MemoList({required this.title, required this.content, required this.setTime, required this.id});

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'title' : title,
      'content' : content,
      'setTime' : setTime
    };
  }
}