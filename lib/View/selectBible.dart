import 'package:bible/Model/bible_list.dart';
import 'package:bible/View/selectChapter.dart';
import 'package:flutter/material.dart';

class SelectBible extends StatefulWidget {
  const SelectBible({Key? key}) : super(key: key);

  @override
  State<SelectBible> createState() => _SelectBibleState();
}

class _SelectBibleState extends State<SelectBible> {

  int selectedChapter = 0;
  late List<String> bible;
  late List<int> length;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bible = bibleLength.keys.toList();
    length = bibleLength.values.toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: const Color.fromRGBO(253, 250, 245, 1.0),
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10
          ),
          itemCount: bible.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9.0)
                ),
                elevation: 3.0,
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Center(
                    child: Text(
                      bible[index],style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600
                    ),
                    ),
                  ),
                ),
              ),

              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectBibleChapter(bibleTitle: bible[index], chapterLength: length[index])));
              },
            );
          },
        ),
      )
    );
  }
}
