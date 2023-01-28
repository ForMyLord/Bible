import 'package:bible/Database/bookmarkDB.dart';
import 'package:bible/Database/userSettingDB.dart';
import 'package:bible/Provider/BookMarkList.dart';
import 'package:bible/Provider/userSetting.dart';
import 'package:bible/Utils/getChapter.dart';
import 'package:bible/View/selectChapter.dart';
import 'package:bible/View/setting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/bible_list.dart';
import 'selectBible.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter_native_splash/flutter_native_splash.dart';

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


  List<String> searchList = []; // 검색 리스트

  List<Map<String,dynamic>> results = []; // 북마크 리스트
  List<Map<String,dynamic>> fontStyles = [];

  bool showSplash = true;

  late DBHelper dh;
  late DBHelperSetting dhSetting;

  int naviIndex = 0;

  String randomBibleWord = "";
  String randomBible = "";
  String randomChapter = "";
  String randomVerse = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    dh = DBHelper();
    dhSetting = DBHelperSetting();

    getBookmark(context);
    getFont(context);

    randomBibleWord = getRandomWordsOfBible(); // 랜덤 말씀 넘기
    FlutterNativeSplash.remove();
  }

  Future<void> getBookmark(BuildContext context) async{ // 데이터 가져오기
    results = await dh.queryAll();

    context.read<BookMarkList>().setData(results);
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

  String getDate(String date){
    String newDate = '';

    for(int i = 0; i < 11; i ++){
      newDate+= date[i];
    }

    return newDate;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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

  Widget showWidget(){

    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    if(naviIndex == 0){
      return SingleChildScrollView(
        child: Container(
            color: const Color.fromRGBO(244, 244, 244, 0.3),
            // physics: const NeverScrollableScrollPhysics(), // 스크롤 막기
            child:Column(
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
                                  if(item.values.first.contains(value)){ // 포함된 단어가 있는 경우

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
                          Container(
                            height: showSearchPreview?getAnimateContainerHeight():0,
                            child: Scrollbar(
                              trackVisibility: false,
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
                Container(
                    height: deviceHeight*0.77,
                    child: SingleChildScrollView(
                      child:
                      Column(
                        children: [
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
                                                await getBookmark(context);
                                                int id = await results[currentPage]['id'];
                                                await dh.deleteBookMark(id);
                                                Navigator.pop(context);
                                                getBookmark(context);
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
                                    height: MediaQuery.of(context).size.height*0.29,
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
                                              child: Text("${context.watch<BookMarkList>().results[index]["content"]}",style: const TextStyle(fontSize: 18,color: Color.fromRGBO(5, 35, 44, 1.0)),maxLines: 7,),
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
                                context.watch<BookMarkList>().results.isNotEmpty?Text('${currentPage+1} / ${context.watch<BookMarkList>().results.length}',style: const TextStyle(fontSize: 15),) : Container(height: 40,),
                                const SizedBox(height: 15,)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.39,
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
                                    children: const [
                                      Text("순간의 말씀",style: TextStyle(
                                          fontSize: 25, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 13,),
                                      SizedBox(
                                        width: deviceWidth*0.9,
                                        child: Text(randomBibleWord,style: const TextStyle(fontSize: 18,color: Color.fromRGBO(5, 35, 44, 1.0)),maxLines: 5,),
                                      ),
                                      const SizedBox(height: 7,),
                                      Text("$randomBible ${int.parse(randomChapter)+1}:${int.parse(randomVerse)+1} KRV",style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Color.fromRGBO(5, 35, 44, 1.0)),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            )
        ),
      );
    }else if(naviIndex == 1){
      setState((){
        currentPage = 0;
      });
      return const SelectBible();
    }else{
      return const user_settings_page();
    }
  }

  String getRandomWordsOfBible() { // 말씀 랜덤 구절 선택하기

    List<String> bible = bibleLength.keys.toList();

    int maxLength = bible.length;

    int randomNum = Random().nextInt(maxLength); // 배열 인덱스 값 고려

    String bibleName = bible[randomNum];

    int bibleChapter = Random().nextInt(bibleLength[bibleName]!); // 랜덤한 chapter 수 선택

    Map<String, dynamic>? selectedBible = bibleEnglishName[bibleName];

    List<dynamic> result = selectedBible!["${bibleChapter+1}장"]; // 장에 맞는 절들 가져오기

    int bibleVerseLength = Random().nextInt(selectedBible!["${bibleChapter+1}장"].length);

    dynamic verseResult = result[bibleVerseLength]; // 절들 중에 랜덤으로 선택

    String content = verseResult["content"]; // 선택한 것중에 내용 선택

    randomBible = bibleName;
    randomChapter = bibleChapter.toString();
    randomVerse = (bibleVerseLength+1).toString();

    return content; // 내용 return
  }

  double getAnimateContainerHeight(){ // 높이 조절
    double result = 0.0;

    if(searchList.length <= 8 && searchList.length >5){
      result = showSearchHeight - 8*searchList.length;
    }else if(searchList.length > 8){
      result = showSearchHeight - 2*searchList.length;
    }
    else{
      result = showSearchHeight;
    }

    return result;
  }

}

