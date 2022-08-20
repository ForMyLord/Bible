import 'package:bible/View/bible.dart';
import 'package:flutter/material.dart';
import '../Model/bible_list.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String a = "창세기";

  String searchText = "";
  final TextEditingController _textController = TextEditingController();
  bool showSearchPreview = false;

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
                        return Container(
                          height: 20,
                          child: Center(
                            child: GestureDetector(
                              child: Text('${bible_list[  index]}'),
                              onTap: (){
                                print("${bible_list[index]}가 클릭됨");
                                Navigator.push(context,MaterialPageRoute(builder: (context) => Bible("${bible_list[index]}")));
                              },
                            ),
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

