import 'package:bible/View/select_verse.dart';
import 'package:flutter/material.dart';

class SelectBibleChapter extends StatefulWidget {
  const SelectBibleChapter({Key? key, required this.bibleTitle, required this.chapterLength}) : super(key: key);

  final String bibleTitle;
  final int chapterLength;

  @override
  State<SelectBibleChapter> createState() => _SelectBibleChapterState();
}

class _SelectBibleChapterState extends State<SelectBibleChapter> {

  String jang = '장';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    if(widget.bibleTitle == '시편'){
      jang = '편';
    }
  }

  int selectedChapter = 0;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.bibleTitle,style: const TextStyle(color:Colors.white, fontWeight: FontWeight.w500,fontSize: 20)),
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
                   for(int i = 0; i <widget.chapterLength; i++) GestureDetector(
                     child:Card(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(9.0)
                       ),
                       elevation: 3.0,
                       child: Padding(
                         padding: const EdgeInsets.all(7),
                         child: Center(
                           child: Text(
                             '${i+1}$jang',style: const TextStyle(
                               fontSize: 18,fontWeight: FontWeight.w600
                           ),
                           ),
                         ),
                       ),
                     ),
                     onTap: (){
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectBibleVerse(selectedChapter: i, bibleTitle: widget.bibleTitle,chapterLength: widget.chapterLength)));
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
