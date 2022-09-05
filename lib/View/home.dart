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

  final TextEditingController _textController = TextEditingController(); // TextController 만들기
  final PageController _pageController = PageController(initialPage: 0);

  int currentPage = 0;

  bool showSearchPreview = false; // 연관 검색어 보여주는데 필요한 bool 값
  double showSearchHeight = 0;

  Map<String,dynamic> bible = genesis; // 입력값에 따라 다른 클래스 지정

  int bibleLength = genesis.length; // 장 길이

  List<String> search_list = [];

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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

                                  // 검색창이 띄어쓰기, 비어있는 경우 아무런 조치 취해주지 않기
                                  if(value.isEmpty){
                                    setState((){
                                      showSearchPreview = false;
                                    });
                                  }

                                  if(value.codeUnits.contains(32)){
                                    if(search_list.isEmpty){
                                      setState((){
                                        showSearchPreview = false;
                                      });
                                    }
                                    return;
                                  }

                                  search_list = [];

                                  bible_list.forEach((item) => {
                                    if(item.values.first.contains(value)){

                                      if(!search_list.contains(item.keys.first)){
                                        setState((){
                                            search_list.add(item.keys.first);
                                            showSearchPreview = true;

                                            if(search_list.length>10){
                                              showSearchHeight = deviceHeight*0.5;
                                            }else{
                                              showSearchHeight = 50.0*search_list.length;
                                            }
                                        })
                                      }

                                    }else if(search_list.isEmpty){ // 포함된 단어가 없는 경우
                                      setState((){
                                        showSearchPreview = false;
                                      })
                                    }
                                  });

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
                                    hintText: '초성입력',
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                        borderSide: BorderSide(color: Colors.black12)
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black12),
                                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      borderSide: BorderSide(color: Colors.black12),
                                    ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: showSearchPreview?showSearchHeight:0,
                              child: Scrollbar(
                                  child: ListView.builder( // 검색어 자동완성
                                      itemCount: search_list.length,
                                      itemBuilder: (BuildContext context, int index){
                                        return GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                              child: Text(search_list[index],style: const TextStyle(fontSize: 20),),
                                            ),
                                            onTap: (){
                                              setState((){
                                                bibleTitle = search_list[index];
                                              });

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
                                                          int verseLength = bible["${i+1}장"].length;
                                                          showDialog(context: context, builder: (BuildContext context){
                                                            return Dialog(
                                                              elevation: 1.0,// 절을 선택할 수 있는 Dialog
                                                              child: GridView.extent(maxCrossAxisExtent: 80,
                                                                children: [
                                                                  for(int j = 0; j < verseLength ; j++)  GestureDetector(
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
              margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text("북마크 말씀",style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold
                  ),),
                ],
              ),
            ),
            SizedBox(
                    height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width,
                    child:PageView.builder(itemBuilder: (context,index){
                        return Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 13,),
                              Container(
                                width: deviceWidth*0.8,
                                child: const Text("너는 기도할 때에 네 골방에 들어가 문을닫고 은밀한 중에 계신 네 아버지께 기도하라 은밀한 중에 보시는 네 아버지께서 갚으시리라",style: TextStyle(fontSize: 20),),
                              ),
                              const SizedBox(height: 7,),
                              const Text("마태복음 6:6 KRV",style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        );
                      },controller: _pageController,
                      itemCount: 5,onPageChanged: (page){
                        setState((){
                          currentPage = page;
                        });
                      },)
                    ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(num i = 0; i<5; i++)
                  Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == currentPage? Colors.black : Colors.black.withOpacity(0.2),
                    )
                  )
              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 0.2 ,
            )
          ],
        ),
      ),
    );
  }
}