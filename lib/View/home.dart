import 'package:bible/Database/db.dart';
import 'package:bible/Provider/BookMarkList.dart';
import 'package:bible/Utils/getChapter.dart';
import 'package:bible/View/select_chapter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/bible_list.dart';
import 'memo.dart';

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

  List<String> searchList = [];


  List<Map<String,dynamic>> results = [];
  late DBHelper dh;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dh = DBHelper();
    getDatabase(context);
  }

  Future<void> getDatabase(BuildContext context) async{
    results = await dh.queryAll();
    context.read<BookMarkList>().setData(results);
  }

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bible',style: TextStyle(color: Color.fromRGBO(253, 250, 245, 1.0),fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(253, 250, 245, 1.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // 스크롤 막기
          child: Column(
            children: [
              Material(
                  elevation:2,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  color: const Color.fromRGBO(5, 35, 44, 1.0),
                  child: Column(
                    children: [
                      Column(
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
                                  if(searchList.isEmpty){
                                    setState((){
                                      showSearchPreview = false;
                                    });
                                  }
                                  return;
                                }

                                searchList = [];

                                bible_list.forEach((item) => {
                                  if(item.values.first.contains(value)){

                                    if(!searchList.contains(item.keys.first)){
                                      setState((){
                                          searchList.add(item.keys.first);
                                          showSearchPreview = true;

                                          if(searchList.length>10){
                                            showSearchHeight = deviceHeight*0.4;
                                          }else{
                                            showSearchHeight = 50.0*searchList.length;
                                          }
                                      })
                                    }

                                  }else if(searchList.isEmpty){ // 포함된 단어가 없는 경우
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
                                  fillColor: const Color.fromRGBO(253, 250, 245, 1.0),
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
                                child: ListView.builder(// 검색어 자동완성
                                    dragStartBehavior: DragStartBehavior.start, // 드래그 시작지점 알려주기
                                    itemCount: searchList.length,
                                    itemBuilder: (BuildContext context, int index){
                                      return GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                                            child: Text(searchList[index],style: const TextStyle(fontSize: 20,color: Color.fromRGBO(253, 250, 245, 1.0)),),
                                          ),
                                          onTap: (){
                                            setState((){
                                              bibleTitle = searchList[index];
                                            });

                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SelectBibleChapter(bibleTitle: bibleTitle,chapterLength: getChapter(bibleTitle),)));
                                            _textController.clear();
                                            setState((){
                                              searchList = [];
                                              showSearchPreview = false;
                                            });
                                          }
                                      );
                                    }),
                              ),
                          ),
                        ],
                      ),
                        ],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        width: 0.2,
                        color: Colors.black
                    ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text("북마크 말씀",style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)
                          ),),
                          IconButton(onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: const Text("북마크 취소하기"),
                                content: const Text("북마크를 취소하시겠습니까"),
                                actions: [
                                  TextButton(onPressed: () async{
                                    await getDatabase(context);
                                    int id = await results[currentPage]['id'];
                                    await dh.deleteBookMark(id);
                                    Navigator.pop(context);
                                    getDatabase(context);
                                    setState(() {
                                      currentPage = results.length-2;
                                    });
                                  },
                                    child: const Text("확인"),
                                  ),
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: const Text("취소"))
                                ],
                              );
                            });
                          }, icon: const Icon(IconData(0xe0f1, fontFamily: 'MaterialIcons'),color: Colors.amber,))
                        ],
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width,
                        child: context.watch<BookMarkList>().results.isNotEmpty ?
                        PageView.builder(itemBuilder: (context,index){
                          return Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 13,),
                                SizedBox(
                                  width: deviceWidth*0.9,
                                  child: Text("${context.watch<BookMarkList>().results[index]["content"]}",style: const TextStyle(fontSize: 18,color: Color.fromRGBO(5, 35, 44, 1.0)),),
                                ),
                                const SizedBox(height: 7,),
                                Text("${context.watch<BookMarkList>().results[index]['bible']} ${context.watch<BookMarkList>().results[index]['chapter']+1}:${context.watch<BookMarkList>().results[index]['verse']} KRV",style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)),)
                              ],
                            ),
                          );
                        },controller: _pageController,
                          itemCount: context.watch<BookMarkList>().results.length,onPageChanged: (page){
                            setState((){
                              currentPage = page;
                            });
                          },):
                        const Center(
                          child: Text("아직 북마크한 말씀이 없습니다"),
                        )
                    ),
                    context.watch<BookMarkList>().results.length > 1 ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(num i = 0; i<context.watch<BookMarkList>().results.length; i++)
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
                    ):Container(),
                    const SizedBox(height: 10,)
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 0.2,
                    color: Colors.black
                  )
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("설교 말씀 메모",style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)
                          )),
                          IconButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Memo()));
                          }, icon: const Icon(Icons.add))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}