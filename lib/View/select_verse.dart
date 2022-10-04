import 'package:bible/Utils/getChapter.dart';
import 'package:bible/View/bible.dart';
import 'package:flutter/material.dart';

class SelectBibleVerse extends StatefulWidget {
  const SelectBibleVerse({Key? key, required this.bibleTitle, required this.selectedChapter,required this.chapterLength}) : super(key: key);

  final String bibleTitle;
  final int selectedChapter;
  final int chapterLength;

  @override
  State<SelectBibleVerse> createState() => _SelectBibleVerseState();
}

class _SelectBibleVerseState extends State<SelectBibleVerse> {

  int verseLength = 0;

  int selectedVerse = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verseLength = getVerse(widget.bibleTitle, widget.selectedChapter+1);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(widget.bibleTitle,style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w500,fontSize: 20,)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () {Navigator.pop(context);},
          ),
          backgroundColor:const Color.fromRGBO(5, 35, 44, 1.0)
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(253, 250, 245, 1.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(20),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                crossAxisCount: 4,
                childAspectRatio: 1.3,
                children: [
                  for(int i = 0; i <verseLength; i++) GestureDetector(
                    child:Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0)
                      ),
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Center(
                          child: Text(
                            '${i+1}절',style: const TextStyle(
                              fontSize: 18,fontWeight: FontWeight.w600
                          ),
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Bible(bibleChapter: widget.selectedChapter, biblePassenger: i, bibleTitle: widget.bibleTitle)));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
