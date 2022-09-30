import 'package:bible/Model/bible_list.dart';
import 'package:bible/Provider/BookMarkList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert';

import '../Database/bookmarkDB.dart';
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(mediaHeight*0.02), child: Container(),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("$bibleTitle ${bibleChapter+1} 장",style: const TextStyle(color:Color.fromRGBO(137, 136, 125, 1.0) , fontSize:25,fontWeight: FontWeight.w500),),
            IconButton(onPressed: (){
              showModalBottomSheet(context: context, builder: (BuildContext context){
                return SizedBox(
                    height: mediaHeight*0.7,
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
                            child: ShaderMask(
                              child: ListView.builder(itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    margin: const EdgeInsets.only(bottom:20,top: 3),
                                    child:GestureDetector(
                                      child:  Row(
                                        children: [
                                          Text(bibleTitle,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.w600,color:Color.fromRGBO(5, 35, 44, 1.0))),
                                          const SizedBox(width: 15,),
                                          Text("${index+1} 장", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w600,color:Color.fromRGBO(5, 35, 44, 1.0)))
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
                              ), shaderCallback: (Rect bounds) {
                              return LinearGradient( //아래 속성들을 조절하여 원하는 값을 얻을 수 있다.
                                begin: Alignment.center,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.03)
                                ],
                                stops: const [0.95, 1],
                                 tileMode: TileMode.mirror,
                              ).createShader(bounds);
                            },
                            )
                          )
                        ],
                      ),
                    )
                );
              });
            }, icon: const Icon(Icons.expand_more),iconSize: 25,color: const Color.fromRGBO(137, 136, 125, 1.0),),
          ],
        ),
        iconTheme: const IconThemeData(
          size: 20,
          color: Color.fromRGBO(137, 136, 125, 1.0)
        ),
        backgroundColor: const Color.fromRGBO(253, 250, 245, 1.0),
      ),
      body: SafeArea(
        child: Container(
          color: const Color.fromRGBO(253, 250, 245, 1.0),
          width: cWidth,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient( //아래 속성들을 조절하여 원하는 값을 얻을 수 있다.
                  begin: Alignment.center,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.01)
                  ],
                  stops: const [0.95, 1],
                  tileMode: TileMode.mirror,
                ).createShader(bounds);
              },
              child: ScrollablePositionedList.builder(itemCount: verseLength, itemBuilder: (context,index){

                int verse = jsonDecode(json.encode(data[index]))["verse"];
                String content = jsonDecode(json.encode(data[index]))["content"];
                return Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: const Color.fromRGBO(253, 250, 245, 1.0),
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
                              onLongPress: (){
                                showDialog(context: context, builder: (BuildContext context){
                                  return AlertDialog(
                                    content: const Text("북마크 추가하시겠습니까?",style: TextStyle(fontSize: 20,color: Color.fromRGBO(5, 35, 44, 1.0)),),
                                    actions: [
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                        BookMark bookMark = BookMark(bible: bibleTitle, chapter: bibleChapter, verse:index+1, setTime: DateTime.now().toString(),content: content);
                                        saveDB(bookMark,context);
                                      }, child: const Text("확인",style: TextStyle(fontSize: 15,color: Color.fromRGBO(5, 35, 44, 1.0)),)),
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: const Text("취소",style: TextStyle(fontSize: 15,color: Color.fromRGBO(5, 35, 44, 1.0)),))
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
              },initialScrollIndex:biblePassenger,itemScrollController: itemScrollController,),
            )
          ),
        ),
      );
  }

  Future<void> saveDB(BookMark bookMark, BuildContext context) async {
    DBHelper dh = DBHelper();

    bool checkSame = false;

    var data = BookMark(
      bible: bookMark.bible,
      chapter: bookMark.chapter,
      verse: bookMark.verse,
      setTime: bookMark.setTime,
      content: bookMark.content
    );

    // 북마크 중복저장 방지
    context.read<BookMarkList>().getData.forEach((element) {
      if(element['content'] == data.content){
        checkSame = true;
      }
    });

    if(!checkSame){
      await dh.insertBookMark(data);

      List<Map<String,dynamic>> results = await dh.queryAll();

      context.read<BookMarkList>().setData(results);
    }

  }
}
