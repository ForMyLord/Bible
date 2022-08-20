import 'package:flutter/material.dart';

class Bible extends StatefulWidget {
  Bible(this.title, {super.key});

  final String title;

  @override
  State<Bible> createState() => _BibleState();
}

class _BibleState extends State<Bible> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: Center(
        child: Text("${widget.title}"),
      ),
    );
  }
}
