import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Database/memoDB.dart';
import '../Model/bible_list.dart';
import '../Model/memoList.dart';
import '../Provider/memoItems.dart';

class EditMemo extends StatefulWidget {
  const EditMemo(
      {Key? key, required this.title, required this.content, required this.id})
      : super(key: key);

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

  List<DropdownMenuItem> menuItems = [];

  String selectItem = "창세기";

  int maxVerse = 1;

  @override
  void initState() {
    // TODO: implement initState
    _titleController.text = widget.title;
    _contentController.text = widget.content;
    bibleEnglishName.keys.forEach((value) {
      menuItems.add(DropdownMenuItem(
        value: value,
        child: Text(value),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("메모수정"),
            backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: (){
                MemoList memo = MemoList(
                    id: widget.id,
                    title: _titleController.text,
                    content: _contentController.text,
                    setTime: DateTime.now().toString());

                // 데이터 저장
                editDB(memo, context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            actions: [
              TextButton(
                onPressed: () async{
                  DBHelperMemo().deleteMemoList(widget.id);

                  List<MemoList> results = await DBHelperMemo().getMemoList();

                  print(results);

                  context.read<MemoItems>().setData(results);

                  Navigator.pop(context);
                },
                child: const Text("삭제",
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (BuildContext context,
                                void Function(void Function()) setState) {
                              return AlertDialog(
                                title: const Text("말씀 추가"),
                                content: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1 +
                                          15,
                                  child: Column(
                                    children: [
                                      DropdownButton(
                                        items: menuItems,
                                        onChanged: (value) {
                                          setState(() {
                                            selectItem = value;
                                          });
                                        },
                                        value: selectItem,
                                        menuMaxHeight: 300,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: _chapterController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    '1~${bibleLength[selectItem]}장',
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          5, 35, 44, 1.0)),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                if (value.isEmpty) {
                                                  setState(() {
                                                    maxVerse = 0;
                                                  });
                                                }

                                                setState(() {
                                                  if (bibleEnglishName[
                                                              selectItem]![
                                                          "${value}장"] !=
                                                      null) {
                                                    maxVerse = bibleEnglishName[
                                                                selectItem]![
                                                            "${value}장"]
                                                        .length;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextField(
                                              controller: _verseController,
                                              decoration: InputDecoration(
                                                hintText: maxVerse > 1
                                                    ? '1~$maxVerse절'
                                                    : '절',
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromRGBO(
                                                          5, 35, 44, 1.0)),
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
                                  TextButton(
                                      onPressed: () {
                                        if (selectItem.isNotEmpty &&
                                            _chapterController.text.isNotEmpty &&
                                            _verseController.text.isNotEmpty) {
                                          selectItem =
                                              selectItem.replaceAll(" ", "");

                                          bibleEnglishName.keys.forEach((key) {
                                            if (key.contains(selectItem)) {
                                              bibleEnglishName[key]!
                                                  .forEach((key, value) {
                                                if (key ==
                                                    "${_chapterController.text}장") {
                                                  if (value.length <
                                                          int.parse(
                                                              _verseController
                                                                  .text) ||
                                                      int.parse(_verseController
                                                              .text) <=
                                                          0) {
                                                    _verseController.clear();
                                                  } else {
                                                    _contentController.text =
                                                        "${_contentController.text}\n(${selectItem} ${_chapterController.text}:${_verseController.text})\n ${value[int.parse(_verseController.text) + 1]['content']}";
                                                    Navigator.of(context).pop();
                                                  }
                                                }
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: const Text("확인",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  5, 35, 44, 1.0)))),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("취소",
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(5, 35, 44, 1.0))),
                                  )
                                ],
                              );
                            },
                          );
                        });
                  },
                  child: const Text(
                    "말씀추가",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 25),
                  decoration: const InputDecoration(
                      hintText: '제목을 적어주세요', border: InputBorder.none),
                  autofocus: true,
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: TextField(
                          controller: _contentController,
                          style: const TextStyle(fontSize: 20),
                          decoration: const InputDecoration(
                              hintText: '내용을 입력해주세요', border: InputBorder.none),
                          maxLines: 13,
                        ),
                      ))),
            ],
          )),
    );
  }

  Future<void> editDB(MemoList memoList, BuildContext context) async {
    DBHelperMemo dh = DBHelperMemo();

    var data = memoList;

    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      dh.updateMemoList(data);
      List<MemoList> results = await dh.getMemoList();
      context.read<MemoItems>().setData(results);
    }
    _titleController.clear();
    _contentController.clear();
    Navigator.pop(context);
  }
}
