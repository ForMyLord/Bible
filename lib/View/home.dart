import 'package:bible/View/bible.dart';
import 'package:flutter/material.dart';
import '../Model/bible_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String bibleTitle = "창세기";

  String searchText = ""; // 검색 텍스트
  final TextEditingController _textController = TextEditingController(); // TextController 만들기

  bool showSearchPreview = false; // 연관 검색어 보여주는데 필요한 bool 값

  int chapterLength = 50; // 말씀 장 길이

  List<int> bibleChapter = []; // Card로 찍어내기 위한 배열 선언
  List<int> biblePassage = [];

  int bibleLength = 50; // 장 길이
  int passageLength = 20;

  int sendBibleChapter = 0;

  bool setVerse = false; // 다이얼로그 장에서 절로 넘어가는지 확인

  getChapter(){
    for(int i = 1; i <= chapterLength ; i++){
      bibleChapter.add(i);
    }
  }

  @override
  void initState() {
    getChapter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.08,
            child: const Center(
              child: Text("광고"),
            )
          ),

          Expanded(
            flex: 4,
            child:SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  const Text('말씀 검색'),
                  const SizedBox(height: 10,),
                  TextField(
                    controller: _textController,
                    onChanged: (value){
                      if(!showSearchPreview){
                        setState((){
                          showSearchPreview = true;
                        });
                      }

                      // 검색창이 띄어쓰기, 비어있는 경우 아무런 조치 취해주지 않기
                      if(_textController.text.isEmpty||_textController.text.codeUnits.contains(32)){
                        setState((){
                          showSearchPreview = false;
                        });
                      }
                      },
                                autofocus: true,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: const InputDecoration(
                                    hintText: '찾기',
                                    border: OutlineInputBorder(
                                      //borderRadius: BorderRadius.all(Radius.circular(30.0))
                                    )
                                ),
                              ),
                  Container(
                    height: 100,
                    child: showSearchPreview?
                    Scrollbar(
                      child: ListView.builder(
                          itemCount: bible_list.length,
                          itemBuilder: (BuildContext context, int index){
                        return Center(
                          child: GestureDetector(
                              child: Text('${bible_list[index]}'),
                              onTap: (){
                                bibleTitle = bible_list[index];
                                showDialog(context: context, builder: (BuildContext context){
                                  return Dialog( // 장을 선택할 수 있는 Dialog
                                    child:GridView.extent(
                                      maxCrossAxisExtent: 60,
                                      children: [
                                        for(int i = 0; i < bibleLength; i++)  GestureDetector(
                                          child: Card(
                                            elevation: 2.0,
                                            child: Center(
                                                child: Text('${bibleChapter[i]}장')
                                            ),
                                          ),
                                          onTap: (){
                                            setState((){
                                              setVerse = true;
                                            });
                                            showDialog(context: context, builder: (BuildContext context){
                                              return Dialog( // 절을 선택할 수 있는 Dialog
                                                child: GridView.extent(maxCrossAxisExtent: 60,
                                                  children: [
                                                    for(int j = 0; j < bibleLength; j++)  GestureDetector(
                                                      child: Card(
                                                        elevation: 2.0,
                                                        child: Center(
                                                            child: Text('${bibleChapter[j]}절')
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Bible(bibleChapter: i, biblePassenger: j,bibleTitle: bibleTitle,)));
                                                      },
                                                    )
                                                  ],),
                                              );
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                              }
                          ),
                        );
                      }),
                    ):const Text("아무것도 없어요")
                  )
                    ],
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: const Text('북마크 말씀'),
            ),
          )
        ],
      ),
    );
  }
}

