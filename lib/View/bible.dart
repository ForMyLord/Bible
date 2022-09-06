import 'package:bible/Model/bible_list.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:convert';

class Bible extends StatefulWidget {

  final int bibleChapter;
  final int biblePassenger;
  final String bibleTitle;
  final Map<String,dynamic> bible = genesis;

  Bible({required this.bibleChapter, required this.biblePassenger, required this.bibleTitle});

  @override
  State<Bible> createState() => _BibleState();
}

class _BibleState extends State<Bible> {

  final ItemScrollController itemScrollController = ItemScrollController();


  @override
  Widget build(BuildContext context) {

    double c_width = MediaQuery.of(context).size.width*0.95;
    double media_width = MediaQuery.of(context).size.width;

    List<Object> data = widget.bible["${widget.bibleChapter+1}장"];
    int chapterLength = widget.bible["${widget.bibleChapter+1}장"].length;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bibleTitle} ${widget.bibleChapter+1} 장",style: const TextStyle(color: Colors.black),),
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          width: c_width,
            child: ScrollablePositionedList.builder(itemCount: chapterLength, itemBuilder: (context,index){

              int verse = jsonDecode(json.encode(data[index]))["verse"];
              String content = jsonDecode(json.encode(data[index]))["content"];

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: media_width*0.85,
                      child: Text("$verse절  $content",style: const TextStyle(
                          fontSize:20,
                      ),
                      ),
                    )
                  ],
                ),
              );
            },initialScrollIndex: widget.biblePassenger)
          ),
        ),
      );
  }
}
