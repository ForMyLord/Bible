import 'package:bible/Model/bible_list.dart';
import 'package:bible/View/select_chapter.dart';
import 'package:flutter/material.dart';

class SelectBible extends StatefulWidget {
  const SelectBible({Key? key}) : super(key: key);

  @override
  State<SelectBible> createState() => _SelectBibleState();
}

class _SelectBibleState extends State<SelectBible> {

  int selectedChapter = 0;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    List<String> bible = bibleLength.keys.toList();

    List<int> length = bibleLength.values.toList();

    return Scaffold(
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
                  for(int i = 0; i <bible.length; i++) GestureDetector(
                    child:Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9.0)
                      ),
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Center(
                          child: Text(
                            bible[i],style: const TextStyle(
                              fontSize: 15,fontWeight: FontWeight.w600
                          ),
                          ),
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SelectBibleChapter(bibleTitle: bible[i], chapterLength:length[i])));
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
