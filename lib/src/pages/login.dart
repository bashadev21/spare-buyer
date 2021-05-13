import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/pages/signup.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import 'otpScreen.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;
  List LoginList;
  bool _isLoad;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  Future LoginFunc() async {
    EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        status: 'loading...',
        indicator: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
        ));

    var response =
        await http.post(BaseUrl.login + 'phone=' + _phonecontroller.text);
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });
    this.LoginList = data['data'];
    print('listtttt');
    print(this.LoginList);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      if (data['data'] == null) {
        // initState();
        // setState(() {
        //   _showMyDialog();
        // });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(_phonecontroller.text)));

        // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
        // CoolAlert.show(
        //   context: context,
        //   type: CoolAlertType.confirm,
        //   text: "Waiting For Admin Approval",
        // );
      } else {
        EasyLoading.dismiss();
        print('resonse $LoginList');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', LoginList[0]['id'].toString());
        prefs.setString('user_name', LoginList[0]['name'].toString());
        prefs.setString('user_phone', LoginList[0]['phone'].toString());
        prefs.setString('user_city', LoginList[0]['city'].toString());
        prefs.setString('user_password', _passwordcontroller.text);

        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);

        Fluttertoast.showToast(
            msg: "Welcome",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      if (response.statusCode == 401) {
        EasyLoading.dismiss();

        Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    setState(() {
      print(response);
      print(response);
    });
    print('statusCode : ' + response.statusCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(50),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(120.0)),
                    color: Colors.black),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(25) - 120,
              child: Container(
                  width: config.App(context).appWidth(64),
                  height: config.App(context).appHeight(37),
                  child: Column(
                    children: [
                      Image.asset('assets/img/2.png',
                          height: 10.0.h, width: 50.0.w),
                    ],
                  )),
            ),
            Positioned(
              top: config.App(context).appHeight(40) - 120,
              child: Container(
                width: config.App(context).appWidth(64),
                height: config.App(context).appHeight(37),
                child: Text(
                  S.of(context).lets_start_with_login,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.0.sp,
                      color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(40) - 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0.w,
                ),
                padding: EdgeInsets.only(
                    top: 6.0.h, right: 10.0.w, left: 10.0.w, bottom: 2.0.h),
                width: config.App(context).appWidth(82),
//              height: config.App(context).appHeight(55),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // TextFormField(
                      //   controller: _usernamecontroller,
                      //
                      //   maxLength: 10,
                      //   keyboardType: TextInputType.phone,
                      //   validator: MultiValidator([
                      //     RequiredValidator(errorText: "Phone Number Required"),
                      //     EmailValidator(errorText: "Enter Valid Phone Number")
                      //   ]),
                      //   //   onSaved: (input) => _con.user.email = input,
                      //
                      //   decoration: InputDecoration(
                      //     counterText: '',
                      //     labelText: 'Phone',
                      //     labelStyle:
                      //         TextStyle(color: Theme.of(context).accentColor),
                      //     contentPadding: EdgeInsets.all(12),
                      //     hintText: '',
                      //     prefixText: '+91',
                      //     hintStyle: TextStyle(
                      //         color: Theme.of(context)
                      //             .focusColor
                      //             .withOpacity(0.7)),
                      //     prefixIcon: Icon(Icons.phone,
                      //         color: Theme.of(context).accentColor),
                      //     border: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //             color: Theme.of(context)
                      //                 .focusColor
                      //                 .withOpacity(0.2))),
                      //     focusedBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //             color: Theme.of(context)
                      //                 .focusColor
                      //                 .withOpacity(0.5))),
                      //     enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //             color: Theme.of(context)
                      //                 .focusColor
                      //                 .withOpacity(0.2))),
                      //   ),
                      // ),
                      // SizedBox(height: 30),
                      // TextFormField(
                      //   keyboardType: TextInputType.text,
                      //   controller: _passwordcontroller,
                      //   // onSaved: (input) => _con.user.password = input,
                      //   validator: MultiValidator([
                      //     RequiredValidator(errorText: "password is required"),
                      //   ]),
                      //   obscureText: _con.hidePassword,
                      //   decoration: InputDecoration(
                      //     labelText: S.of(context).password,
                      //     labelStyle:
                      //         TextStyle(color: Theme.of(context).accentColor),
                      //     contentPadding: EdgeInsets.all(12),
                      //     hintText: '••••••••••••',
                      //     hintStyle: TextStyle(
                      //         color: Theme.of(context)
                      //             .focusColor
                      //             .withOpacity(0.7)),
                      //     prefixIcon: Icon(Icons.lock_outline,
                      //         color: Theme.of(context).accentColor),
                      //     suffixIcon: IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           _con.hidePassword = !_con.hidePassword;
                      //         });
                      //       },
                      //       color: Theme.of(context).focusColor,
                      //       icon: Icon(_con.hidePassword
                      //           ? Icons.visibility
                      //           : Icons.visibility_off),
                      //     ),
                      //     border: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //             color: Theme.of(context)
                      //                 .focusColor
                      //                 .withOpacity(0.2))),
                      //     focusedBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //             color: Theme.of(context)
                      //                 .focusColor
                      //                 .withOpacity(0.5))),
                      //     enabledBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //             color: Theme.of(context)
                      //                 .focusColor
                      //                 .withOpacity(0.2))),
                      //   ),
                      // ),
                      TextFormField(
                        controller: _phonecontroller,
                        //   inputFormatters: [Te],
                        cursorColor: Theme.of(context).accentColor,

                        maxLength: 10,

                        onSaved: (input) => _con.user.email = input,
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Phone Number is required"),
                          PhoneNumberValidator()
                        ]),
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          prefixText: '+91 ',
                          labelText: S.of(context).phone,
                          labelStyle: TextStyle(color: Colors.black87),
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: '',
                          hintStyle:
                              TextStyle(color: Theme.of(context).focusColor),
                          prefixIcon: Icon(Icons.call,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).focusColor)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black87)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Center(
                        child: Text(
                          'Note: OTP will be send to this number',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: Text(
                          S.of(context).login,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.7),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          //   print(_usernamecontroller.text);
                          print(_passwordcontroller.text);
                          _formKey.currentState.validate() ? LoginFunc() : null;
                          //   _con.login();
                        },
                      ),
                      SizedBox(height: 5.0.h),
                      // RoundedLoadingButton(
                      //     color: Theme.of(context).accentColor,
                      //     child: Text('Submit'),
                      //     onPressed: () {
                      //
                      //     })

                      // FlatButton(
                      //   onPressed: () {
                      //     Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                      //   },
                      //   shape: StadiumBorder(),
                      //   textColor: Theme.of(context).hintColor,
                      //   child: Text(S.of(context).skip),
                      //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      // ),
//                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15.0.h,
              child: Column(
                children: <Widget>[
                  // FlatButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                  //   },
                  //   textColor: Theme.of(context).hintColor,
                  //   child: Text(S.of(context).i_forgot_password),
                  // ),
                  FlatButton(
                    onPressed: () {
                      // Navigator.of(context).pushReplacementNamed('/SignUp');
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 400),
                              type: PageTransitionType.rightToLeftWithFade,
                              child: SignUpWidget()));
                    },
                    textColor: Theme.of(context).hintColor,
                    child: Row(
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black87),
                        ),
                        Text(
                          " Register",
                          style: TextStyle(
                              color: Color.fromRGBO(253, 163, 8, 1),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Form(
                      key: _formKey,
                      child: KeyboardAvoider(
                        autoScroll: true,
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            Container(
                              child: Center(
                                  child: Text(
                                'Confirmation',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: RequiredValidator(
                                    errorText: "Days is required"),
                                decoration: InputDecoration(
                                  labelText: 'Return Days',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'days',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.calendar_today,
                                      color: Colors.grey[500]),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.2))),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .accentColor
                                              .withOpacity(0.2))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlineButton(
                                    borderSide: BorderSide(color: Colors.red),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {},
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.07,
                                  ),
                                  RaisedButton(
                                    color: Colors.green,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(30.0)),
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // actions: <Widget>[
            //   TextButton(
            //     child: Text(
            //       'Cancel',
            //       style: TextStyle(color: Colors.red),
            //     ),
            //     onPressed: () {
            //       displd();
            //       _amountController.clear();
            //       _rDaysController.clear();
            //       Navigator.of(context).pop();
            //     },
            //   ),
            //   TextButton(
            //     child: Text(
            //       'Confirm',
            //       style: TextStyle(color: Colors.green),
            //     ),
            //     onPressed: () {
            //       _formKey.currentState.validate() ? BidBook() : null;
            //
            //       print(UserId);
            //
            //       print(selectedBooking);
            //
            //       print(_amountController.text);
            //       print(_rDaysController.text);
            //     },
            //   ),
            // ],
          ),
        );
      },
    );
  }
}
