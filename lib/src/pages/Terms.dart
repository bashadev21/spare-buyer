import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';

import '../../base_url.dart';
import '../../generated/l10n.dart';

class TermsCon extends StatefulWidget {
  @override
  _TermsConState createState() => _TermsConState();
}

void handleClick(String value) {
  switch (value) {
    case 'English':
      print('English');
      break;
    case 'தமிழ்':
      print('தமிழ்');
      break;
  }
}

class _TermsConState extends State<TermsCon> {
  String termsList;
  Future getterms() async {
    var response = await http.get(BaseUrl.terms);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;

      print(data);
    });

    this.termsList = data['data'] + data['message'];
    print('location');
    print(termsList);
    print(this.termsList);
  }

  @override
  void initState() {
    getterms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('title'),
        appBar: AppBar(),
        //  widgets: <Widget>[Icon(Icons.more_vert)],
      ),
      // appBar: AppBar(
      //   leading: new IconButton(
      //     icon: new Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   centerTitle: true,
      //   // title: ValueListenableBuilder(
      //   //   valueListenable: settingsRepo.setting,
      //   //   builder: (context, value, child) {
      //   //     return Text(
      //   //       value.appName ?? S.of(context).home,
      //   //       style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
      //   //     );
      //   //   },
      //   // ),
      //   title: Image.asset(
      //     'assets/img/2.png',
      //     height: MediaQuery.of(context).size.height * 0.3,
      //     width: MediaQuery.of(context).size.width * 0.4,
      //   ),
      //
      //   actions: <Widget>[
      //     PopupMenuButton<String>(
      //       icon: Image.asset(
      //         'assets/img/3.png',
      //         height: 40.0.h,
      //         width: 30.0.w,
      //       ),
      //       onSelected: handleClick,
      //       itemBuilder: (BuildContext context) {
      //         return {'English', 'தமிழ்'}.map((String choice) {
      //           return PopupMenuItem<String>(
      //             value: choice,
      //             child: Row(
      //               children: [
      //                 Text(choice),
      //               ],
      //             ),
      //           );
      //         }).toList();
      //       },
      //     ),
      //     // Row(
      //     //   children: [
      //     //     CircleAvatar(
      //     //         backgroundColor: Colors.white,
      //     //         child: Text(
      //     //           'EN',
      //     //           style: TextStyle(color: Colors.black87),
      //     //         )),
      //     //   ],
      //     // ),
      //     // SizedBox(
      //     //   width: 2.0.h,
      //     // )
      //   ],
      // ),
      body: Container(
          child: Column(
        children: [
          SizedBox(
            height: 2.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).terms,
                style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 1.0.h,
          ),
          Container(
              height: 80.0.h,
              width: 90.0.w,
              child: ListView(
                children: [
                  termsList == null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: Container(
                              height: 80.0.h,
                              // width: 50.0.w,
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Theme.of(context).accentColor,
                                ),
                              )),
                        )
                      : Html(data: termsList),
                ],
              ))
        ],
      )),
    );
  }
}
