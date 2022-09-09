import 'package:bible/Model/bible_list.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert';

import '../Database/db.dart';
import '../Model/bookmark.dart';

class Bible extends StatefulWidget {

  final int bibleChapter;
  final int biblePassenger;
  final String bibleTitle;

  const Bible({super.key, required this.bibleChapter, required this.biblePassenger, required this.bibleTitle});

  @override
  State<Bible> createState() => _BibleState();
}

class _BibleState extends State<Bible> {

  final ItemScrollController itemScrollController = ItemScrollController();

  Map<String, dynamic>? bible;
  late int bibleChapter;
  late String bibleTitle;
  late int biblePassenger;

  late List<Object> data;
  late int verseLength;
  late int chapterLength;

  @override
  void initState() {
    super.initState();
    bible = bibleEnglishName[widget.bibleTitle];

    bibleChapter = widget.bibleChapter;
    bibleTitle = widget.bibleTitle;
    biblePassenger = widget.biblePassenger;

    data = bible!["${bibleChapter+1}장"];
    verseLength = bible!["${bibleChapter+1}장"].length;
    chapterLength = data.length;
  }

  @override
  Widget build(BuildContext context) {

    double cWidth = MediaQuery.of(context).size.width*0.95;
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("$bibleTitle ${bibleChapter+1} 장",style: const TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet(context: context, builder: (BuildContext context){
                return SizedBox(
                    height: mediaHeight*0.6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("장을 선택해주세요",style: TextStyle(fontSize: 20,color: Colors.grey),),
                              IconButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close,size: 30 ,color: Colors.grey,),
                              )
                            ],
                          ),
                          SizedBox(
                            height: mediaHeight * 0.4 + 70,
                            child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  margin: const EdgeInsets.only(bottom:20),
                                  child:GestureDetector(
                                    child:  Row(
                                      children: [
                                        Text(bibleTitle,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w600)),
                                        const SizedBox(width: 20,),
                                        Text("${index+1} 장", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600))
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.pop(context);
                                      setState((){
                                        bibleChapter = index;
                                        data = bible!["${index+1}장"];
                                        verseLength = bible!["${bibleChapter+1}장"].length;
                                      });
                                      itemScrollController.jumpTo(index: 0);
                                    },
                                  )
                              );
                            }, itemCount: bible!.length,
                            ),
                          )
                        ],
                      ),
                    )
                );
            });
          }, icon: const Icon(Icons.expand_more),iconSize: 40,)
        ],
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
      ),
      body: SafeArea(
        child: SizedBox(
          width: cWidth,
            child: ScrollablePositionedList.builder(itemCount: verseLength, itemBuilder: (context,index){

              int verse = jsonDecode(json.encode(data[index]))["verse"];
              String content = jsonDecode(json.encode(data[index]))["content"];

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("$verse.",style: const TextStyle(fontSize: 20,color: Color.fromRGBO(5, 35, 44, 1.0)),),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: mediaWidth * 0.75,
                                  child: Text(content,style: const TextStyle(fontSize: 20,color: Color.fromRGBO(5, 35, 44, 1.0)),),
                                )
                              ],
                            ),
                            onLongPressUp: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AlertDialog(
                                  title: const Text("북마크 추가하기"),
                                  content: const Text("북마크 추가하시겠습니까?"),
                                  actions: [
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                      BookMark bookMark = BookMark(id: 1 , bible: bibleTitle, chapter: bibleChapter, verse:biblePassenger, setTime: DateTime.now().toString());
                                      saveDB(bookMark);
                                    }, child: const Text("확인")),
                                    TextButton(onPressed: (){
                                      Navigator.pop(context);
                                      print("취소");
                                    }, child: const Text("취소"))
                                  ],
                                );
                              });
                            },
                          ),
                          const SizedBox(
                            height:10
                          )
                        ],
                      )
                    ),
                  ],
                ),
              );
            },initialScrollIndex:biblePassenger,itemScrollController: itemScrollController,)
          ),
        ),
      );
  }

  Future<void> saveDB(BookMark bookMark) async {
    DBHelper dh = DBHelper();

    var data = BookMark(
      id: bookMark.id,
      bible: bookMark.bible,
      chapter: bookMark.chapter,
      verse: bookMark.verse,
      setTime: bookMark.setTime
    );

    await dh.insertBookMark(data);

    dynamic result = await dh.getBookMark();

    result.forEach((value) => {

    })

  }
}
