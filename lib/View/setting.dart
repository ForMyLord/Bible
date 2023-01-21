import 'package:bible/Database/userSettingDB.dart';
import 'package:bible/Model/userSettingData.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../Provider/userSetting.dart';

class user_settings_page extends StatefulWidget {
  const user_settings_page({Key? key}) : super(key: key);

  @override
  State<user_settings_page> createState() => _user_settings_pageState();
}

class _user_settings_pageState extends State<user_settings_page> {

  String? UserName = null;
  String? userFontStyle;

  double? size;
  String? Style;

  bool vertical = false;

  List<bool> selectStyle = [false,false,false];

  DBHelperSetting dh = DBHelperSetting();

  List<Widget> fontShape = <Widget>[
    const Text(
      '기본',
      style: TextStyle(
        fontFamily: '',
        fontSize: 18,
      ),
    ),
    const Text(
      '나눔명조',
      style: TextStyle(
        fontFamily: 'NanumMyeongjo',
        fontSize: 18,
      ),
    ),
    const Text(
      '송명',
      style: TextStyle(
        fontFamily: 'SongMyung',
        fontSize: 24,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {

    String font = context.watch<setFontStyle>().fontStyle;

    if(font == 'NanumGothic'){
      selectStyle = [true,false,false];
    }else if(font == 'NanumMyeongjo'){
      selectStyle = [false,true,false];
    }else if(font == 'SongMyung'){
      selectStyle = [false,false,true];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("설정", style: TextStyle(color: Color.fromRGBO(253, 250, 245, 1.0),fontFamily: ''),),
        backgroundColor: const Color.fromRGBO(5, 35, 44, 1.0),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            child: const Text("확인",style: TextStyle(fontFamily: '',color: Color.fromRGBO(253, 250, 245, 1.0),fontSize: 18),),
            onPressed: (){
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
                height: MediaQuery.of(context).size.height*0.17,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          '요한복음 3:16 KRV',
                          style: TextStyle(fontSize: 18, color: Colors.indigo,fontFamily: ''),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          '하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니 이는 저를 믿는 자마다 멸망치 않고 영생을 얻게 하려 하심이니라',
                          style: TextStyle(
                            fontSize: context.watch<setFontSize>().i,
                            fontFamily: userFontStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ), //미리보기

          const SizedBox(
            height: 40,
          ),

          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '글꼴',
                    style: TextStyle(fontSize: 20,fontFamily: ''),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: 50,
              child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {

                      int fontSize = context.read<setFontSize>().i.toInt();

                      for (int i = 0; i < selectStyle.length; i++) {
                        if (index == 0) {
                          userFontStyle = 'NanumGothic';
                          // 폰트 스타일이랑 폰트크기랑 같이 업데이트 해줘야 한다.

                          dh.changeUserSettingValue(
                            userSettingDatas(fontSize: fontSize, fontStyle: userFontStyle!)
                          );
                          context.read<setFontStyle>().setFontStyles(userFontStyle!);

                        } else if (index == 1) {
                          userFontStyle = 'NanumMyeongjo';
                          dh.changeUserSettingValue(
                              userSettingDatas(fontSize: fontSize, fontStyle: userFontStyle!)
                          );
                          context.read<setFontStyle>().setFontStyles(userFontStyle!);
                        } else if (index == 2) {
                          userFontStyle = 'SongMyung';
                          dh.changeUserSettingValue(
                              userSettingDatas(fontSize: fontSize, fontStyle: userFontStyle!)
                          );
                          context.read<setFontStyle>().setFontStyles(userFontStyle!);
                        }
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.orangeAccent[700],
                  selectedColor: Colors.white,
                  fillColor: Colors.orangeAccent[200],
                  color: Colors.orangeAccent[400],
                  constraints: BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 90.0,
                  ),
                  isSelected: selectStyle,
                  children: fontShape,
                ),
              ])), //글꼴

          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '폰트크기',
                    style: TextStyle(fontSize: 20,fontFamily: ''),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('${context.watch<setFontSize>().i}')
                ],
              ),
            ),
          ), //글자 크기

          SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              //side: BorderSide(color: Colors.red) // border line color
                            )),
                      ),
                      onPressed: () {
                        context.read<setFontSize>().addFontNum();
                        dh.changeUserSettingValue(userSettingDatas(fontSize: context.read<setFontSize>().i.toInt(), fontStyle: context.read<setFontStyle>().fontStyle));
                      },
                      child: const Icon(Icons.add)),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              //side: BorderSide(color: Colors.red) // border line color
                            )),
                      ),
                      onPressed: () {
                        context.read<setFontSize>().minusFontNum();
                        dh.changeUserSettingValue(userSettingDatas(fontSize: context.read<setFontSize>().i.toInt(), fontStyle: context.read<setFontStyle>().fontStyle));
                      },
                      child: const Icon(
                        Icons.remove,
                        color: Colors.orange,
                      ))
                ],
              ))
        ],
      ),
    );
  }

}

