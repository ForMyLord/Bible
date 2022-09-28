import 'dart:convert';

import 'package:bible/Database/memoDB.dart';
import 'package:bible/Model/bible_list.dart';
import 'package:bible/Model/memoList.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/memoItems.dart';

class Memo extends StatefulWidget {
  const Memo({Key? key}) : super(key: key);

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _bibleController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _verseController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
        title: const Text("메모추가"),
        actions: [
          TextButton(onPressed: (){
            MemoList memo = MemoList(
              id:setSha(DateTime.now().toString()),
              title: _titleController.text,
              content: _contentController.text,
              setTime: DateTime.now().toString()
            );

            // 데이터 저장
            saveDB(memo, context);
          }, child: const Text("저장",style: TextStyle(color: Colors.white,fontSize: 17))),
          TextButton(onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return  AlertDialog(
                    title: const Text("말씀 추가"),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height*0.1 + 15,
                      child: Column(
                        children: [
                          TextField(
                            autofocus: true,
                            controller: _bibleController,
                            decoration: const InputDecoration(
                              hintText: '성경',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(5, 35, 44, 1.0)),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(flex: 1,child: TextField(
                                controller: _chapterController,
                                decoration: const InputDecoration(
                                  hintText: '장',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(5, 35, 44, 1.0)),
                                  ),
                                ),
                              ),),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: _verseController,
                                  decoration: const InputDecoration(
                                    hintText: '절',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(5, 35, 44, 1.0)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: (){

                        if(_bibleController.text.isNotEmpty && _chapterController.text.isNotEmpty && _verseController.text.isNotEmpty){

                          bibleEnglishName.keys.forEach((key) {
                            if(key.contains(_bibleController.text)){

                              bibleEnglishName[key]!.forEach((key, value) {
                                if(key == "${_chapterController.text}장"){

                                  if(value.length < int.parse(_verseController.text) || int.parse(_verseController.text)<=0){
                                    _verseController.clear();
                                  }else{
                                    _contentController.text= "${_contentController.text}\n(${_bibleController.text} ${_chapterController.text}:${_verseController.text})\n ${value[int.parse(_verseController.text)+1]['content']}";
                                    Navigator.of(context).pop();
                                  }
                                }
                              });
                            }
                          });
                        }
                      }, child: const Text("확인",style: TextStyle(color: Color.fromRGBO(5, 35, 44, 1.0)))),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child: const Text("취소",style: TextStyle(color: Color.fromRGBO(5, 35, 44, 1.0))),)
                    ],
                  );
                },
              );
            });
          }, child: const Text("말씀추가",style: TextStyle(fontSize: 16,color: Colors.white),))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize:25),
              decoration: const InputDecoration(
                hintText: '제목을 적어주세요',
                border: InputBorder.none
              ),
              autofocus: true,
            ),
          ),
          const Divider(
            thickness: 1,
          )
          ,
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Container(
              height: MediaQuery.of(context).size.height*0.7,
              child: InkWell(
                splashColor: Colors.transparent,
                onDoubleTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return  AlertDialog(
                          title: const Text("말씀 추가"),
                          content: Container(
                            height: MediaQuery.of(context).size.height*0.1 + 15,
                            child: Column(
                              children: [
                                TextField(
                                  autofocus: true,
                                  controller: _bibleController,
                                  decoration: const InputDecoration(
                                      hintText: '성경',
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color.fromRGBO(5, 35, 44, 1.0)),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(flex: 1,child: TextField(
                                      controller: _chapterController,
                                      decoration: const InputDecoration(
                                          hintText: '장',
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color.fromRGBO(5, 35, 44, 1.0)),
                                        ),
                                      ),
                                    ),),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        controller: _verseController,
                                        decoration: const InputDecoration(
                                            hintText: '절',
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Color.fromRGBO(5, 35, 44, 1.0)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(onPressed: (){

                              if(_bibleController.text.isNotEmpty && _chapterController.text.isNotEmpty && _verseController.text.isNotEmpty){
                                _bibleController.text = _bibleController.text.replaceAll(" ", "");

                                bibleEnglishName.keys.forEach((key) {
                                  if(key.contains(_bibleController.text)){

                                    bibleEnglishName[key]!.forEach((key, value) {
                                      if(key == "${_chapterController.text}장"){

                                        if(value.length < int.parse(_verseController.text) || int.parse(_verseController.text)<=0){
                                          _verseController.clear();
                                        }else{
                                          _contentController.text= "${_contentController.text}\n(${_bibleController.text} ${_chapterController.text}:${_verseController.text})\n ${value[int.parse(_verseController.text)+1]['content']}";
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    });
                                  }
                                });
                              }
                            }, child: const Text("확인",style: TextStyle(color: Color.fromRGBO(5, 35, 44, 1.0)),)),
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text("취소",style: TextStyle(color: Color.fromRGBO(5, 35, 44, 1.0))),)
                          ],
                        );
                      },
                    );
                  });
                },
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      hintText: '내용을 입력해주세요',
                      border: InputBorder.none
                  ),
                  maxLines: 13,
                ),
              )
            )
          )
        ],
      )
    );
  }

  Future<void> saveDB(MemoList memoList, BuildContext context) async {
    DBHelperMemo dh = DBHelperMemo();

    var data = MemoList(
      title: memoList.title,
      content: memoList.content,
      id: memoList.id,
      setTime: memoList.setTime,
    );

    if(_titleController.text.isNotEmpty && _contentController.text.isNotEmpty){
      dh.insertMemo(data);
      List<MemoList> results = await dh.getMemoList();
      context.read<MemoItems>().setData(results);
    }

    _titleController.clear();
    _contentController.clear();

    Navigator.pop(context);
  }


  String setSha(String text){
    var bytes = utf8.encode(text);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

}




