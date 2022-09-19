import 'package:flutter/material.dart';

class Memo extends StatefulWidget {
  const Memo({Key? key}) : super(key: key);

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("메모"),
      ),
    );
  }
}
