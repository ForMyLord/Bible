import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Database/memoDB.dart';
import '../Model/bible_list.dart';
import '../Model/memoList.dart';
import '../Provider/memoItems.dart';

class EditMemo extends StatefulWidget {
  const EditMemo({Key? key, required this.title, required this.content, required this.id}) : super(key: key);

  final String title;
  final String content;
  final String id;

  @override
  State<EditMemo> createState() => _EditMemoState();
}

class _EditMemoState extends State<EditMemo> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _bibleController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _verseController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("메모수정"),
          backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
          actions: [
            TextButton(onPressed: (){
              MemoList memo = MemoList(
                  id:widget.id,
                  title: _titleController.text,
                  content: _contentController.text,
                  setTime: DateTime.now().toString()
              );

              // 데이터 저장
              editDB(memo, context);
            }, child: const Text("저장",style: TextStyle(color: Colors.white,fontSize: 17)),),
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
                      highlightColor: Colors.transparent,
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
            ),
          ],
        )
    );
  }

  Future<void> editDB(MemoList memoList, BuildContext context) async {
    DBHelperMemo dh = DBHelperMemo();

    var data = memoList;

    if(_titleController.text.isNotEmpty && _contentController.text.isNotEmpty){
      dh.updateMemoList(data);
      List<MemoList> results = await dh.getMemoList();
      context.read<MemoItems>().setData(results);
    }
    _titleController.clear();
    _contentController.clear();
    Navigator.pop(context);
  }
}
