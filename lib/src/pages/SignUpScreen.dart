import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(80.0.sp)),
                color: Colors.black),
            height: 35.0.h,
          ),
          Container(
              height: 60.0.h,
              width: 80.0.w,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return Text('heloooo');
                  })),
        ],
      ),
    );
  }
}
