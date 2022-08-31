import 'package:bible/Model/bible_list.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Bible extends StatefulWidget {

  final int bibleChapter;
  final int biblePassenger;
  final String bibleTitle;
  final Map<String,Map<String,String>> bible = genesis;

  Bible({required this.bibleChapter, required this.biblePassenger, required this.bibleTitle});

  @override
  State<Bible> createState() => _BibleState();
}

class _BibleState extends State<Bible> {

  final ItemScrollController itemScrollController = ItemScrollController();


  @override
  Widget build(BuildContext context) {

    double c_width = MediaQuery.of(context).size.width*0.95;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bibleTitle} ${widget.bibleChapter+1} 장"),
      ),
      body: SafeArea(
        child: Container(
          width: c_width,
            child: ScrollablePositionedList.builder(itemCount: widget.bible["1장"]!.length, itemBuilder: (context,index){
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Text("${index+1}절  ${widget.bible["1장"]!["${index+1}절"]}",style: const TextStyle(
                    fontSize: 20
                ),textAlign: TextAlign.left),
              );
            },initialScrollIndex: widget.biblePassenger)
          ),
        ),
      );
  }
}
