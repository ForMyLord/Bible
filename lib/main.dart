import 'package:bible/Provider/BookMarkList.dart';
import 'package:bible/Provider/userSetting.dart';
import 'package:bible/View/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers:[
      ChangeNotifierProvider(create: (_)=> BookMarkList()),
      ChangeNotifierProvider(create: (_)=> setFontSize()),
      ChangeNotifierProvider(create: (_)=> setFontStyle())
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
        builder:(context,child){
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0)
          );
        },
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: context.watch<setFontStyle>().fontStyle
        ),
        home: const Homepage()
      );
  }
}

