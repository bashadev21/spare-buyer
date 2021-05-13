import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';
import 'package:spare_do/src/elements/DrawerWidget.dart';
import 'package:spare_do/src/pages/login.dart';

import '../../generated/l10n.dart';
import '../controllers/favorite_controller.dart';
import 'booking_Details.dart';

class FavoritesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  FavoritesWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends StateMVC<FavoritesWidget> {
  Timer _timer;
  int created_at;
  int _start = 10;
  int time;
  int dialog = 1;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final LocalStorage storage = new LocalStorage("");
  Future getBookingDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('user_id');
    setState(() {
      var current_user = (prefs.getString('user_id') ?? '');
      UserId = prefs.getString('user_id');
      print(UserId);
    });

    var response = await http.get(BaseUrl.myBookings + 'user_id=' + UserId);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });
    // final created_at = bookingList[index];
    // final date2 = DateTime(2021, 02, 22,12,10);

    this.bookingList = data['data'];

    setState(() {
      print(response);
      print(response);
    });
    print(data['data']);
    print('statusCode : ' + response.statusCode.toString());

    if (data['data'] == null) {
      Center(
        child: Container(
          child: Text('No data Found'),
        ),
      );
    }
  }

  int bookingId;
  int noSeller;

  Future NoSeller() async {
    var response = await http.get(BaseUrl.getBookingStatus + 'booking_id=' + bookingId.toString());
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });
    // final created_at = bookingList[index];
    // final date2 = DateTime(2021, 02, 22,12,10);

    this.noSeller = data['data'];

    setState(() {
      print(response);
      print(response);
    });
    print(data['data']);
    print('statusCode : ' + response.statusCode.toString());
  }

  String layout = 'grid';

  FavoriteController _con;
  List bookingList = List();
  _FavoritesWidgetState() : super(FavoriteController()) {
    _con = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
    getBookingDetails();
    LoginCheck();
    super.initState();
  }

  int Loginchk;
  Future LoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    print(prefs.get('user_password'));
    final userId = (prefs.get('user_id'));

    UserId = userId;
    var response = await http.get(
        BaseUrl.logCheck + 'user_id=' + UserId + '&' + 'password=' + prefs.get('user_password'));
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });
    this.Loginchk = data['data'];
    if (this.Loginchk == 1) {
      print('Logdd in');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('user_password');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWidget()));
    }

    print('listttttda');
    print(this.Loginchk);

    print('statusCodew : ' + response.statusCode.toString());
  }

  // createminutes(created_at, minute) {
  //   var created_at = created_at;
  //   var datenow = DateTime.now();
  //   var difference = date2.difference(created_at).inMinutes;
  //   var minutes = minute;
  //   var val = minutes - difference;
  // }

  @override
  Widget build(BuildContext context) {
    print('idddddddddddddddddddd');
    print('${bookingId}');

    return SafeArea(
      child: Scaffold(
        key: _con.scaffoldKey,
        appBar: BaseAppBar(
          appBar: AppBar(),
          //widgets: <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWidget(),
        // appBar: AppBar(
        //   leading: new IconButton(
        //     icon: new Icon(Icons.sort, color: Colors.white),
        //     onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        //   ),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.black,
        //   elevation: 0,
        //   centerTitle: true,
        //   title: Image.asset(
        //     'assets/img/2.png',
        //     height: MediaQuery.of(context).size.height * 0.3,
        //     width: MediaQuery.of(context).size.width * 0.4,
        //   ),
        //
        //   actions: <Widget>[
        //     Row(
        //       children: [
        //         CircleAvatar(
        //             backgroundColor: Colors.white,
        //             child: Text(
        //               'EN',
        //               style: TextStyle(color: Colors.black87),
        //             )),
        //       ],
        //     ),
        //     SizedBox(
        //       width: 2.0.h,
        //     )
        //   ],
        //   // actions: <Widget>[
        //   //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        //   // ],
        // ),

        body: Container(
          child: Column(
            children: [
              SizedBox(height: 2.0.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).my_bookings,
                    style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),
              Container(
                height: 67.0.h,
                width: 92.0.w,
                child: Column(
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0.sp), topRight: Radius.circular(5.0.sp)),
                          border: Border.all(color: Colors.black87),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0.sp),
                                bottomLeft: Radius.circular(5.0.sp),
                                bottomRight: Radius.circular(5.0.sp),
                                topRight: Radius.circular(5.0.sp),
                              ),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0.sp),
                                          bottomLeft: Radius.circular(5.0.sp)),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Center(
                                        child: Text(
                                      S.of(context).id_,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(width: 1, color: Colors.white),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 2,
                                  child: Container(
                                    color: Theme.of(context).accentColor,
                                    child: Center(
                                        child: Text(
                                      S.of(context).category_,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(width: 1, color: Colors.white),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 2,
                                  child: Container(
                                    color: Theme.of(context).accentColor,
                                    child: Center(
                                        child: Text(
                                      S.of(context).status_,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Container(width: 1, color: Colors.white),
                                ),
                                Flexible(
                                  fit: FlexFit.tight,
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5.0.sp),
                                          bottomRight: Radius.circular(5.0.sp)),
                                      color: Theme.of(context).accentColor,
                                    ),
                                    child: Center(
                                        child: Text(
                                      S.of(context).details_,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      style: TextStyle(fontWeight: FontWeight.w600),
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 16,
                      fit: FlexFit.tight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.0.sp),
                              bottomLeft: Radius.circular(5.0.sp)),
                          border: Border.all(color: Colors.black87),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 60.0.h,
                                width: 91.0.w,
                                child: bookingList == null
                                    ? Container(
                                        child: Center(child: Text('No Records Found')),
                                      )
                                    : bookingList.length > 0
                                        ? ListView.builder(
                                            itemCount: bookingList.length,
                                            itemBuilder: (context, index) {
                                              //  DateTime created_at = bookingList[index]['created_at'];
                                              DateTime created_at =
                                                  new DateFormat("yyyy-MM-dd hh:mm:ss")
                                                      .parse(bookingList[index]['updated_at']);
                                              print('create' +
                                                  '${bookingList[index]['updated_at']}' +
                                                  '${bookingList[index]['id']}');

                                              //  final date2 = DateTime(2021, 02, 22, 12, 10);
                                              final _current_date = DateTime.now();
                                              print('currnt' + '${_current_date}');
                                              final difference =
                                                  _current_date.difference(created_at).inMinutes;
                                              //  final secondsdif =
                                              //     _current_date.difference(created_at).inSeconds;
                                              final minutes = 15;
                                              var val = minutes - difference;
                                              print('vallllllllllllll');
                                              print(val);

                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1.5.w, vertical: 0.7.h),
                                                child: Container(
                                                  height: 8.0.h,
                                                  width: 92.5.w,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      new BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 10.0,
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(5.0.sp),
                                                      bottomLeft: Radius.circular(5.0.sp),
                                                      bottomRight: Radius.circular(5.0.sp),
                                                      topRight: Radius.circular(5.0.sp),
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 2,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(5.0.sp),
                                                                bottomLeft:
                                                                    Radius.circular(5.0.sp)),
                                                            color: Colors.white,
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            '${bookingList[index]['id'].toString()}' ??
                                                                '',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600),
                                                          )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(vertical: 4),
                                                        child: Container(
                                                            width: 1, color: Colors.black87),
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 2,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Center(
                                                              child: Text(
                                                            '${bookingList[index]['category_name'].toString()}' ??
                                                                '',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                color: Colors.grey[600]),
                                                          )),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(vertical: 4),
                                                        child: Container(
                                                            width: 1, color: Colors.black87),
                                                      ),
                                                      // Flexible(
                                                      //   fit: FlexFit.tight,
                                                      //   flex: 2,
                                                      //   child: Container(
                                                      //     color: Colors.white,
                                                      //     // child: Text(val.toString()),
                                                      //     child: Center(
                                                      //         child: CountdownFormatted(
                                                      //       duration: Duration(minutes: val),
                                                      //       builder: (BuildContext ctx,
                                                      //           String remaining) {
                                                      //         return Text(remaining); // 01:00:00
                                                      //       },
                                                      //     )),
                                                      //   ),
                                                      // ),

                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 2,
                                                        child: Container(
                                                            color: Colors.white,
                                                            child: Center(
                                                                child: bookingList[index]
                                                                            ['status'] ==
                                                                        0
                                                                    ? Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        children: [
                                                                          Text(
                                                                            'Pending',
                                                                            maxLines: 1,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .normal,
                                                                                color: Theme.of(
                                                                                        context)
                                                                                    .accentColor),
                                                                          ),
                                                                          Text(
                                                                            'Process',
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .normal,
                                                                                color: Theme.of(
                                                                                        context)
                                                                                    .accentColor),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Text(
                                                                        'Active',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: Colors.green),
                                                                      ))),
                                                      ),
                                                      // Flexible(
                                                      //   fit: FlexFit.tight,
                                                      //   flex: 2,
                                                      //   child: Container(
                                                      //     color: Colors.white,
                                                      //     child: CountdownFormatted(
                                                      //       onFinish: () {
                                                      //         print('heloooooooo');
                                                      //       },
                                                      //       duration: Duration(minutes: 5),
                                                      //       builder:
                                                      //           (BuildContext ctx, String remaining) {
                                                      //         return Text(
                                                      //           remaining,
                                                      //           style: TextStyle(fontSize: 12.0.sp),
                                                      //         ); // 01:00:00
                                                      //       },
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(vertical: 4),
                                                        child: Container(
                                                            width: 1, color: Colors.black87),
                                                      ),
                                                      Flexible(
                                                        fit: FlexFit.tight,
                                                        flex: 2,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                                topRight: Radius.circular(5.0.sp),
                                                                bottomRight:
                                                                    Radius.circular(5.0.sp)),
                                                            color: Colors.white,
                                                          ),
                                                          child: bookingList[index]['status'] == 0
                                                              ? Center(
                                                                  child: CountdownFormatted(
                                                                  onFinish: () {
                                                                    bookingId =
                                                                        bookingList[index]['id'];
                                                                    NoSeller();
                                                                    if (noSeller == 0) {
                                                                      _showMyDialog();
                                                                      Center(
                                                                          child: GestureDetector(
                                                                        onTap: () {},
                                                                        child: Text(
                                                                          'Change',
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Colors.redAccent),
                                                                        ),
                                                                      ));
                                                                    }
                                                                  },
                                                                  duration: Duration(minutes: val),
                                                                  builder: (BuildContext ctx,
                                                                      String remaining) {
                                                                    return Text(
                                                                        '${remaining.split(':')[0]}' +
                                                                            ' mins'); // 01:00:00
                                                                  },
                                                                ))
                                                              : Center(
                                                                  child: noSeller == 0
                                                                      ? Center(
                                                                          child: Text('Change'),
                                                                        )
                                                                      : IconButton(
                                                                          onPressed: () {
                                                                            Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                    builder: (context) =>
                                                                                        BookingDetails(
                                                                                            bookingList[index]
                                                                                                [
                                                                                                'id'])));
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.arrow_right,
                                                                            size: 22.0.sp,
                                                                            color: Colors.grey,
                                                                          ),
                                                                        )),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            })
                                        : Center(
                                            child: SpinKitThreeBounce(
                                              color: Theme.of(context).accentColor,
                                            ),
                                          ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empty'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('No Sellers Bidded'),
                Text('Change your Location?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Change'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
