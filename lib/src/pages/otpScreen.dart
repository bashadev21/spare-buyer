import 'dart:async';
import 'dart:convert';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/elements/BlockButtonWidget.dart';

import '../helpers/app_config.dart' as config;

class OtpScreen extends StatefulWidget {
  final String phone;
  OtpScreen(this.phone);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

final _formKey = GlobalKey<FormState>();
bool hasError = false;
String currentText = "";

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
bool active;
var onTapRecognizer;

TextEditingController textEditingController = TextEditingController();

class _OtpScreenState extends State<OtpScreen> {
  List userList;
  Future otpverifyFunc() async {
    EasyLoading.show(
        status: 'Verifying..',
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        indicator: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
        ));
    var response =
        await http.post(BaseUrl.otpVerify + 'phone=' + widget.phone + '&' + 'otp=' + currentText);
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);

    setState(() {
      data = data;
      // this.LoginList = data['data'];
      // print('listtttt');
      // print(this.LoginList);
    });
    this.userList = data['data'];
    print('listtttt');
    print(this.userList);
    print('statusCode : ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', userList[0]['id'].toString());
      prefs.setString('user_name', userList[0]['name'].toString());
      prefs.setString('user_phone', userList[0]['phone'].toString());
      prefs.setString('user_city', userList[0]['city'].toString());

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    if (response.statusCode == 401) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Invalid OTP",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response body : ${response.body}');

      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    return response;
  }

  Future resendotpyFunc() async {
    var response = await http.post(BaseUrl.resendOtp + 'phone=' + widget.phone);
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);

    setState(() {
      data = data;
      // this.LoginList = data['data'];
      // print('listtttt');
      // print(this.LoginList);
    });
    this.userList = data['data'];
    print('listtttt');
    print(this.userList);
    print('statusCode : ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', userList[0]['id'].toString());
      prefs.setString('user_name', userList[0]['name'].toString());
      prefs.setString('user_phone', userList[0]['phone'].toString());
      prefs.setString('user_city', userList[0]['city'].toString());

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    if (response.statusCode == 401) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Invalid OTP",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response body : ${response.body}');

      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(70.0.sp)),
                  color: Colors.black),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(23) - 120,
            child: Container(
                width: config.App(context).appWidth(64),
                height: config.App(context).appHeight(37),
                child: Column(
                  children: [
                    Image.asset('assets/img/2.png', height: 100, width: 150),
                  ],
                )),
          ),
          Positioned(
            top: config.App(context).appHeight(39) - 120,
            child: Container(
              width: config.App(context).appWidth(65),
              height: config.App(context).appHeight(37),
              child: Text(
                'Verify your number!',
                style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 50,
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
                horizontal: 20,
              ),
              padding: EdgeInsets.only(top: 30, right: 27, left: 27, bottom: 30),
              width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'We have send you an OTP on',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'your number',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                        ),
                      ],
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                        child: PinCodeTextField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          appContext: context,
                          // pastedTextStyle: TextStyle(
                          //   color: Colors.green.shade600,
                          //   fontWeight: FontWeight.bold,
                          // ),
                          length: 4,

                          blinkWhenObscuring: true,

                          animationType: AnimationType.fade,
                          enablePinAutofill: true,
                          validator: (v) {
                            if (v.length < 4) {
                              return "Enter Valid Otp";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            disabledColor: Colors.white,
                            shape: PinCodeFieldShape.underline,
                            borderRadius: BorderRadius.circular(5),
                            selectedColor: Colors.black,
                            fieldHeight: 50,
                            fieldWidth: 40,
                            inactiveColor: Colors.black87,
                            activeColor: Theme.of(context).accentColor,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            activeFillColor: hasError ? Colors.orange : Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.white,
                          enableActiveFill: true,
                          //  errorAnimationController: errorController,
                          //   controller: textEditingController,

                          onCompleted: (v) {
                            print("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        )),
                    SizedBox(height: 20),
                    BlockButtonWidget(
                      text: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.black87, fontWeight: FontWeight.w600, letterSpacing: 0.7),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        otpverifyFunc();
                        print('otp' + currentText);
                        //   print(_usernamecontroller.text);
                        //     print(_passwordcontroller.text);
                        //   _formKey.currentState.validate() ? LoginFunc() : null;

                        //   _con.login();
                      },
                    ),
                    SizedBox(height: 2.0.h),
                    TextButton(
                      onPressed: () {
                        resendotpyFunc();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Resend OTP',
                            style: TextStyle(
                                color: Theme.of(context).accentColor, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 10),
                          CountdownFormatted(
                            onFinish: () {
                              setState(() {
                                active = true;
                              });
                            },
                            duration: Duration(seconds: 30),
                            builder: (BuildContext ctx, String remaining) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Theme.of(context).accentColor),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    remaining,
                                    style: TextStyle(color: Theme.of(context).accentColor),
                                  ),
                                ),
                              ); // 01:00:00
                            },
                          )
                        ],
                      ),
                    )

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
        ],
      ),
    );
  }
}
