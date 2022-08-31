import 'package:bible/View/bible.dart';
import 'package:flutter/material.dart';
import '../Model/bible_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String bibleTitle = "창세기"; // 성경 키워드

  String searchText = ""; // 검색 텍스트
  final TextEditingController _textController = TextEditingController(); // TextController 만들기

  bool showSearchPreview = false; // 연관 검색어 보여주는데 필요한 bool 값
  double showSearchHeight = 0;

  int bibleLength = 50; // 장 길이
  int passageLength = 20;
  int sendBibleChapter = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white24,
        child: Column(
          children: [
            Material(
                elevation:2,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                              child: TextField(
                                style: const TextStyle(
                                    fontSize: 20
                                ),
                                controller: _textController,
                                onChanged: (value){

                                  if(value.contains(" ")){
                                      _textController.text = value.replaceAll(" ", ""); // 띄어쓰기 발견시 제거하기
                                      _textController.selection = TextSelection.fromPosition(TextPosition(offset: _textController.text.length)); // textfield 값 변경후, 단어 맨 뒤로 포커싱 해주기
                                  }

                                  if(!showSearchPreview){
                                    setState((){
                                      showSearchPreview = true;
                                      showSearchHeight = 50.0*bible_list.length;
                                    });
                                  }

                                  // 검색창이 띄어쓰기, 비어있는 경우 아무런 조치 취해주지 않기
                                  if(_textController.text.isEmpty||_textController.text.codeUnits.contains(32)){
                                    setState((){
                                      showSearchPreview = false;
                                    });
                                  }
                                },
                                autofocus: false,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.black12,
                                    contentPadding: const EdgeInsets.all(0),
                                    prefixIcon: const Icon(Icons.search,color: Colors.black,),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState((){
                                          _textController.clear();
                                          showSearchPreview = false;
                                        });
                                      },
                                      icon: const Icon(Icons.close,color: Colors.black,),
                                    ),
                                    hintText: '찾기',
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(color: Colors.black12)
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(Radius.circular(30.0))
                                    )
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: showSearchPreview?showSearchHeight:0,
                              child: Scrollbar(
                                  child: ListView.builder(
                                      itemCount: bible_list.length,
                                      itemBuilder: (BuildContext context, int index){
                                        return GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                              child: Text(bible_list[index],style: const TextStyle(fontSize: 20),),
                                            ),
                                            onTap: (){
                                              bibleTitle = bible_list[index];
                                              showDialog(context: context, builder: (BuildContext context){
                                                return Dialog(// 장을 선택할 수 있는 Dialog
                                                  child:GridView.extent(
                                                    maxCrossAxisExtent: 80,
                                                    children: [
                                                      for(int i = 0; i < bibleLength; i++)  GestureDetector(
                                                        child: Card(
                                                          elevation: 3.0,
                                                          child: Center(
                                                              child: Text('${i+1}장',style: const TextStyle(
                                                                  fontSize: 20
                                                              ),)
                                                          ),
                                                        ),
                                                        onTap: (){
                                                          showDialog(context: context, builder: (BuildContext context){
                                                            return Dialog(
                                                              elevation: 1.0,// 절을 선택할 수 있는 Dialog
                                                              child: GridView.extent(maxCrossAxisExtent: 80,
                                                                children: [
                                                                  for(int j = 0; j < bibleLength; j++)  GestureDetector(
                                                                    child: Card(
                                                                      elevation: 3.0,
                                                                      child: Center(
                                                                          child: Text('${j+1}절', style: const TextStyle(
                                                                              fontSize: 20
                                                                          ),)
                                                                      ),
                                                                    ),
                                                                    onTap: (){
                                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Bible(bibleChapter: i, biblePassenger: j,bibleTitle: bibleTitle,)));
                                                                    },
                                                                  )
                                                                ],),
                                                            );
                                                          },barrierColor: Colors.black12.withOpacity(0.0));
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },barrierColor: Colors.black12.withOpacity(0.5));
                                            }
                                        );
                                      }),
                                ),
                            ),
                          ],
                        ),
                      ),
                        ],
                  )
                ),
              ),
            Container(
              height: MediaQuery.of(context).size.height*0.5,
              margin: const EdgeInsets.fromLTRB(10,15,10,0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 15,
                    offset: const Offset(0,10)
                  )
                ],
                borderRadius: BorderRadius.circular(30),
                color: Colors.white
              ),
              child: const Center(
                child: Text("북마크"),
              )
              )
          ],
        ),
      ),
    );
  }
}