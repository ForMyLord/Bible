import 'package:bible/Provider/BookMarkList.dart';
import 'package:bible/Provider/memoItems.dart';
import 'package:flutter/material.dart';
import 'package:bible/View/home.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(create: (_)=> BookMarkList()),
      ChangeNotifierProvider(create: (_)=> MemoItems())
    ],
    child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Homepage()
      );
  }
}

