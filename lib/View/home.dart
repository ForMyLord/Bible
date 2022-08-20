import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  String searchText = "";
  final TextEditingController _textController = TextEditingController();


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
                      _textController.text;
                      print(_textController.text);
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
                    ],
              )
            ),
          ),
          Expanded(
            flex: 6,
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

