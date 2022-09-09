import 'package:bible/Model/bible_list.dart';

int getChapter(String bibleTitle){

  int answer = 0;

  bibleEnglishName.keys.forEach((key) {
    if(bibleTitle == key){
      answer = bibleEnglishName[key]!.length;
    }
  });

  return answer;
}

int getVerse(String bibleTitle, int chapter){
  int answer = 0;

  bibleEnglishName.keys.forEach((key) {
    if(bibleTitle == key){
      Map<String,dynamic> bible = bibleEnglishName[key]!;

      answer = bible["${chapter}장"].length;
    }
  });

  return answer;
}

Map<String,dynamic> getBible(String bibleTitle){

  Map<String,dynamic>? result;

  bibleEnglishName.keys.forEach((key) {
    result = bibleEnglishName[key]!;
  });

  return result!;
}