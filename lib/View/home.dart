import 'package:bible/Database/bookmarkDB.dart';
import 'package:bible/Database/memoDB.dart';
import 'package:bible/Database/userSettingDB.dart';
import 'package:bible/Model/colorData.dart';
import 'package:bible/Provider/BookMarkList.dart';
import 'package:bible/Provider/memoItems.dart';
import 'package:bible/Provider/userSetting.dart';
import 'package:bible/Utils/getChapter.dart';
import 'package:bible/View/editMemo.dart';
import 'package:bible/View/select_chapter.dart';
import 'package:bible/View/setting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/bible_list.dart';
import '../Model/memoList.dart';
import 'memo.dart';
import 'select_bible.dart';

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

  List<String> searchList = []; // 검색 리스트

  List<MemoList> memoList = []; // 메모 리스트
  List<Map<String,dynamic>> results = []; // 북마크 리스트
  List<Map<String,dynamic>> fontStyles = [];

  bool showSplash = true;

  late DBHelper dh;
  late DBHelperMemo dhMemo;
  late DBHelperSetting dhSetting;

  int naviIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dh = DBHelper();
    dhMemo = DBHelperMemo();
    dhSetting = DBHelperSetting();

    getDatabase(context);
    getFont(context);

    Future.delayed(const Duration(milliseconds: 1500),(){
      setState((){
        showSplash = false;
      });
    });
  }

  Future<void> getDatabase(BuildContext context) async{
    results = await dh.queryAll();

    memoList = await dhMemo.getMemoList();

    print(memoList);

    context.read<BookMarkList>().setData(results);
    context.read<MemoItems>().setData(memoList);
  }

  Future<void> getFont(BuildContext context) async {
     fontStyles = await dhSetting.queryAll();

     if(fontStyles.isEmpty){
       dhSetting.initSettingValue();
     }else{
       String fontStyle = fontStyles[0]['fontStyle'];
       int fontSize = int.parse(fontStyles[0]['fontSize']);

       context.read<setFontStyle>().setFontStyles(fontStyle);
       context.read<setFontSize>().setFontSizes(fontSize.toDouble());

     }
  }

  void _onTap(int index){
    setState((){
      naviIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return showSplash?Scaffold(
      backgroundColor:  const Color.fromRGBO(5, 35, 44, 1.0),
      body: Center(child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Bible',
              style: TextStyle(color: Color.fromRGBO(253, 250, 245, 1.0),
                  fontWeight: FontWeight.bold,fontSize: 35,fontFamily: ''),),
            Text('R.',
              style: TextStyle(color: Colors.amber,
                  fontWeight: FontWeight.bold,fontSize: 35,fontFamily: ''),)
          ]
      ),),
    ):Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('Bible',
                style: TextStyle(color: Color.fromRGBO(253, 250, 245, 1.0),
                    fontWeight: FontWeight.bold,fontSize: 20,fontFamily: ''),),
              Text('R.',
                style: TextStyle(color: Colors.amber,
                    fontWeight: FontWeight.bold,fontSize: 20,fontFamily: ''),)
            ]
        ),
        backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: showWidget()
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(253, 250, 245, 1.0),
        iconSize: 30,
    items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
    label: '홈',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.book_outlined),
    label: '성경',
    ),
    ],

    currentIndex: naviIndex,
    selectedItemColor: Colors.orange,
    onTap: _onTap,
    ),
    );
  }

  String getDate(String date){
    String newDate = '';

    for(int i = 0; i < 11; i ++){
      newDate+= date[i];
    }

    return newDate;
  }

  Widget showWidget(){

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    if(naviIndex == 0){
      return Container(
        color: const Color.fromRGBO(244, 244, 244, 0.3),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // 스크롤 막기
          child: Column(
            children: [
              SingleChildScrollView(
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
                                              showSearchHeight = 45.0*searchList.length;
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
                                  autofocus: true,
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
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 0.4,
                            color: Colors.grey
                        ),
                        color : const Color.fromRGBO(253, 250, 245, 1.0),
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
                                context.watch<BookMarkList>().results.isNotEmpty?IconButton(onPressed: (){
                                  showDialog(context: context, builder: (BuildContext context){
                                    return AlertDialog(
                                      title: const Text("북마크 취소하기"),
                                      actions: [
                                        TextButton(onPressed: () async{
                                          await getDatabase(context);
                                          int id = await results[currentPage]['id'];
                                          await dh.deleteBookMark(id);
                                          Navigator.pop(context);
                                          getDatabase(context);
                                          setState((){

                                            if((_pageController.page)!.toInt() == results.length-1){
                                              if(currentPage == 0){
                                                currentPage = 0;
                                              }else{
                                                currentPage = (_pageController.page)!.toInt() - 1; // 마지막 페이지에서 북마크 제거시 currentPage - 1해줘야 맞음
                                              }

                                            }else{
                                              currentPage = (_pageController.page)!.toInt(); // 첫번째나 중간페이지 제가한 경우에는 -1 하지 않아야 currentPage를 맞춤
                                            }

                                          });
                                        },
                                          child: const Text("확인",style: TextStyle(color: Color.fromRGBO(5, 35, 44, 1.0)),),
                                        ),
                                        TextButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: const Text("취소",style: TextStyle(color: Color.fromRGBO(5, 35, 44, 1.0))),)
                                      ],
                                    );
                                  });
                                }, icon: const Icon(IconData(0xe0f1, fontFamily: 'MaterialIcons'),color: Colors.amber,size: 27,)):Container()
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
                                        child: Text("${context.watch<BookMarkList>().results[index]["content"]}",style: const TextStyle(fontSize: 18,color: Color.fromRGBO(5, 35, 44, 1.0)),maxLines: 5,),
                                      ),
                                      const SizedBox(height: 7,),
                                      Text("${context.watch<BookMarkList>().results[index]['bible']} ${context.watch<BookMarkList>().results[index]['chapter']+1}:${context.watch<BookMarkList>().results[index]['verse']} KRV",style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)),),
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
                          context.watch<BookMarkList>().results.isNotEmpty ?Text('${currentPage+1} / ${context.watch<BookMarkList>().results.length}',style: const TextStyle(fontSize: 15),) : Container(height: 40,),
                          const SizedBox(height: 15,)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.3 + 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 0.4,
                            color: Colors.grey
                        ),
                        color : const Color.fromRGBO(253, 250, 245, 1.0),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("나만의 메모",style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)
                                )),
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Memo()));
                                }, icon: const Icon(Icons.add,size: 25,))
                              ],
                            ),
                          ),
                          context.watch<MemoItems>().results.isNotEmpty ? Container(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              //color: Colors.grey,
                              height: MediaQuery.of(context).size.height*0.2 + 20,
                              child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:3,
                                childAspectRatio: 1,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ), itemBuilder: (context,index) => GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditMemo(title: context.watch<MemoItems>().results[index].title,content: context.watch<MemoItems>().results[index].content,id: context.watch<MemoItems>().results[index].id,)));
                                },
                                child: GestureDetector(
                                  onLongPress: (){
                                    showDialog(context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        content: const Text("메모를 삭제하시겠습니까?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("확인",style:TextStyle(fontSize: 18,color: Color.fromRGBO(5, 35, 44, 1.0))),
                                            onPressed: () {
                                              dhMemo.deleteMemoList(memoList[index].id);
                                              getDatabase(context);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: const Text("취소",style: TextStyle(fontSize: 18,color: Color.fromRGBO(5, 35, 44, 1.0)))
                                          )

                                        ],
                                      );
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow:[
                                          BoxShadow(
                                            color: colorData[index>=colorData.length?index-colorData.length:index],
                                            spreadRadius: 0,
                                            blurRadius: 0,
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(),
                                            Text(context.watch<MemoItems>().results[index].title,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                            Text(getDate(context.watch<MemoItems>().results[index].setTime),style: const TextStyle(fontSize: 10, color: Colors.black),),
                                            const SizedBox()
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ),itemCount: context.watch<MemoItems>().results.length,dragStartBehavior: DragStartBehavior.start,)
                          ) : SizedBox( height:MediaQuery.of(context).size.height*0.2 - 35,child: const Center(child: Text("등록된 메모가 없습니다"),),)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }else if(naviIndex == 1){
      return const SelectBible();
    }else{
      return const user_settings_page();
    }
  }
}

