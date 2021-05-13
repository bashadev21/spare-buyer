import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';

import '../../generated/l10n.dart';
import 'booking_Details.dart';

class SellerDetails extends StatefulWidget {
  final int id;

  SellerDetails(
    this.id,
  );

  List sellerDetails = List();

  @override
  _SellerDetailsState createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  String SellerAmount;
  String bookid, sellerId, amount;
  int SellerId;
  List sellerDetails = List();
  List bidDetails = List();
  Future SellerFunc() async {
    var response = await http.get('${BaseUrl.sellerDetails}${widget.id.toString()}');

    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });

    this.sellerDetails = data['data'];
    print(this.sellerDetails);
    print('selllllllllllll');
    print(sellerDetails);
  }

  Future saveBid() async {
    var response = await http.post(BaseUrl.saveBid +
        'booking_id=' +
        widget.id.toString() +
        '&' +
        'seller_id=' +
        SellerId.toString() +
        '&' +
        'amount=' +
        SellerAmount);
    bookid = widget.id.toString();
    sellerId = SellerId.toString();
    amount = SellerAmount;
    print('bookid :' + widget.id.toString());
    print('sellerIddaaa :' + SellerId.toString());
    print('selleramount :' + SellerAmount);
    //  var response=await http.post('http://192.168.1.147:8080/spare_do/public/api/save_bid?booking_id=${widget.id.toString()}&');
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });

    // this.bidDetails = data['data'];
    // print(this.bidDetails);
    // print(bidDetails);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BookingDetails(widget.id)));
      Fluttertoast.showToast(
          msg: "Seller Saved Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
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
  void initState() {
    SellerFunc();
    // SellerFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('title'),
        appBar: AppBar(),
        // widgets: <Widget>[Icon(Icons.more_vert)],
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   leading: new IconButton(
      //     icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Image.asset(
      //     'assets/img/2.png',
      //     height: MediaQuery.of(context).size.height * 0.3,
      //     width: MediaQuery.of(context).size.width * 0.4,
      //   ),
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
      // ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 2.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).seller_list,
                  style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            // sellerDetails.length == 0
            //     ? Container(
            //   child: Center(
            //     child: Text('No sellers Found'),
            //   ),
            // )

            SizedBox(height: 1.0.h),
            Container(
                height: 77.0.h,
                width: 92.0.w,
                child: sellerDetails == null
                    ? Container(
                        child: Center(child: Text('No Records Found')),
                      )
                    : sellerDetails.length > 0
                        ? ListView.builder(
                            itemCount: sellerDetails.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3.0,
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  height: 45.0.h,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 25.0.sp, vertical: 6),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 1.0.h,
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 1.0.h,
                                                          ),
                                                          Text('Id',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 11.0.sp)),
                                                          SizedBox(
                                                            height: 0.5.h,
                                                          ),
                                                          Text(
                                                              '${sellerDetails[index]['id'].toString()}',
                                                              style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontSize: 12.0.sp,
                                                                  fontWeight: FontWeight.w600)),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 1.0.h,
                                                        ),
                                                        Text('Name',
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 11.0.sp)),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                            '${sellerDetails[index]['name'].toString()}',
                                                            style: TextStyle(
                                                                color: Colors.black87,
                                                                fontSize: 12.0.sp,
                                                                fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 1.0.h,
                                                          ),
                                                          Text('Price',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 11.0.sp)),
                                                          SizedBox(
                                                            height: 0.5.h,
                                                          ),
                                                          Text(
                                                              '₹ ${sellerDetails[index]['amount'].toString()}',
                                                              style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontSize: 12.0.sp,
                                                                  fontWeight: FontWeight.w600)),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 1.0.h,
                                                        ),
                                                        Text('Return Days',
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 11.0.sp)),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                            '${sellerDetails[index]['return_days'].toString()}',
                                                            style: TextStyle(
                                                                color: Colors.black87,
                                                                fontSize: 12.0.sp,
                                                                fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 1.0.h,
                                                          ),
                                                          Text('State',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 11.0.sp)),
                                                          SizedBox(
                                                            height: 0.5.h,
                                                          ),
                                                          Text(
                                                              '${sellerDetails[index]['state_name'].toString()}',
                                                              style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontSize: 12.0.sp,
                                                                  fontWeight: FontWeight.w600)),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 1.0.h,
                                                        ),
                                                        Text('District',
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 11.0.sp)),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                            '${sellerDetails[index]['district_name'].toString()}',
                                                            style: TextStyle(
                                                                color: Colors.black87,
                                                                fontSize: 12.0.sp,
                                                                fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                  )),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  flex: 4,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            height: 1.0.h,
                                                          ),
                                                          Text('City',
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 11.0.sp)),
                                                          SizedBox(
                                                            height: 0.5.h,
                                                          ),
                                                          Text(
                                                              '${sellerDetails[index]['city_name'].toString()}',
                                                              style: TextStyle(
                                                                  color: Colors.black87,
                                                                  fontSize: 12.0.sp,
                                                                  fontWeight: FontWeight.w600)),
                                                        ],
                                                      ),
                                                    ),
                                                  )),
                                              Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                  flex: 2,
                                                  fit: FlexFit.tight,
                                                  child: Container(
                                                    height: 8.0.h,
                                                    child: Center(
                                                      child: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                        onPressed: () {
                                                          SellerId =
                                                              sellerDetails[index]['seller_id'];
                                                          SellerAmount =
                                                              sellerDetails[index]['amount'];

                                                          _showMyDialog();
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (context) =>
                                                          //             BookingDetails(
                                                          //                 sellerDetails[index]
                                                          //                 ['id'])));
                                                        },
                                                        child: Text(
                                                          'Confirm',
                                                          style: TextStyle(
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        color: Theme.of(context).accentColor,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },

                            // Flexible(
                            //   flex: 2,
                            //   fit: FlexFit.tight,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.only(
                            //           topLeft: Radius.circular(5.0.sp), topRight: Radius.circular(5.0.sp)),
                            //       border: Border.all(color: Colors.black87),
                            //     ),
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(4.0),
                            //       child: Container(
                            //         decoration: BoxDecoration(
                            //           color: Theme.of(context).accentColor,
                            //           borderRadius: BorderRadius.only(
                            //             topLeft: Radius.circular(5.0.sp),
                            //             bottomLeft: Radius.circular(5.0.sp),
                            //             bottomRight: Radius.circular(5.0.sp),
                            //             topRight: Radius.circular(5.0.sp),
                            //           ),
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             Flexible(
                            //               fit: FlexFit.tight,
                            //               flex: 2,
                            //               child: Container(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: BorderRadius.only(
                            //                       topLeft: Radius.circular(5.0.sp),
                            //                       bottomLeft: Radius.circular(5.0.sp)),
                            //                   color: Theme.of(context).accentColor,
                            //                 ),
                            //                 child: Center(
                            //                     child: Text(
                            //                   S.of(context).id_,
                            //                   overflow: TextOverflow.fade,
                            //                   maxLines: 1,
                            //                   style: TextStyle(fontWeight: FontWeight.w600),
                            //                 )),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.symmetric(vertical: 4),
                            //               child: Container(width: 1, color: Colors.white),
                            //             ),
                            //             Flexible(
                            //               fit: FlexFit.tight,
                            //               flex: 2,
                            //               child: Container(
                            //                 color: Theme.of(context).accentColor,
                            //                 child: Center(
                            //                     child: Column(
                            //                   mainAxisAlignment: MainAxisAlignment.center,
                            //                   children: [
                            //                     Row(
                            //                       mainAxisAlignment: MainAxisAlignment.center,
                            //                       children: [
                            //                         Text(
                            //                           S.of(context).seller_,
                            //                           overflow: TextOverflow.fade,
                            //                           maxLines: 2,
                            //                           style: TextStyle(fontWeight: FontWeight.w600),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                     Row(
                            //                       mainAxisAlignment: MainAxisAlignment.center,
                            //                       children: [
                            //                         Text(
                            //                           S.of(context).name_,
                            //                           overflow: TextOverflow.fade,
                            //                           maxLines: 2,
                            //                           style: TextStyle(fontWeight: FontWeight.w600),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ],
                            //                 )),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.symmetric(vertical: 4),
                            //               child: Container(width: 1, color: Colors.white),
                            //             ),
                            //             Flexible(
                            //               fit: FlexFit.tight,
                            //               flex: 2,
                            //               child: Container(
                            //                 color: Theme.of(context).accentColor,
                            //                 child: Center(
                            //                     child: Column(
                            //                   mainAxisAlignment: MainAxisAlignment.center,
                            //                   children: [
                            //                     Row(
                            //                       mainAxisAlignment: MainAxisAlignment.center,
                            //                       children: [
                            //                         Text(
                            //                           S.of(context).return_,
                            //                           overflow: TextOverflow.fade,
                            //                           maxLines: 2,
                            //                           style: TextStyle(fontWeight: FontWeight.w600),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                     Row(
                            //                       mainAxisAlignment: MainAxisAlignment.center,
                            //                       children: [
                            //                         Text(
                            //                           S.of(context).days_,
                            //                           overflow: TextOverflow.fade,
                            //                           maxLines: 2,
                            //                           style: TextStyle(fontWeight: FontWeight.w600),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ],
                            //                 )),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.symmetric(vertical: 4),
                            //               child: Container(width: 1, color: Colors.white),
                            //             ),
                            //             Flexible(
                            //               fit: FlexFit.tight,
                            //               flex: 2,
                            //               child: Container(
                            //                 color: Theme.of(context).accentColor,
                            //                 child: Center(
                            //                     child: Text(
                            //                   S.of(context).amount_,
                            //                   overflow: TextOverflow.fade,
                            //                   maxLines: 1,
                            //                   style: TextStyle(fontWeight: FontWeight.w600),
                            //                 )),
                            //               ),
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.symmetric(vertical: 4),
                            //               child: Container(width: 1, color: Colors.white),
                            //             ),
                            //             Flexible(
                            //               fit: FlexFit.tight,
                            //               flex: 2,
                            //               child: Container(
                            //                 decoration: BoxDecoration(
                            //                   borderRadius: BorderRadius.only(
                            //                       topRight: Radius.circular(5.0.sp),
                            //                       bottomRight: Radius.circular(5.0.sp)),
                            //                   color: Theme.of(context).accentColor,
                            //                 ),
                            //                 child: Center(
                            //                     child: Text(
                            //                   S.of(context).select_,
                            //                   overflow: TextOverflow.fade,
                            //                   maxLines: 1,
                            //                   style: TextStyle(fontWeight: FontWeight.w600),
                            //                 )),
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // Flexible(
                            //   flex: 16,
                            //   fit: FlexFit.tight,
                            //   child: Container(
                            //     // decoration: BoxDecoration(
                            //     //   borderRadius: BorderRadius.only(
                            //     //       bottomRight: Radius.circular(5.0.sp),
                            //     //       bottomLeft: Radius.circular(5.0.sp)),
                            //     //   border: Border.all(color: Colors.black87),
                            //     // ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         sellerDetails == 0
                            //             ? Container(
                            //                 child: Text('empty'),
                            //               )
                            //             : Container(
                            //                 height: 500,
                            //                 width: 91.0.w,
                            //                 child: sellerDetails.length > 0
                            //                     ? ListView.builder(
                            //                         itemCount: sellerDetails.length,
                            //                         itemBuilder: (context, index) {
                            //                           return Padding(
                            //                             padding: EdgeInsets.symmetric(
                            //                                 horizontal: 1.5.w, vertical: 0.7.h),
                            //                             child: Container(
                            //                               height: 6.0.h,
                            //                               width: 92.5.w,
                            //                               decoration: BoxDecoration(
                            //                                 boxShadow: [
                            //                                   new BoxShadow(
                            //                                     color: Colors.black26,
                            //                                     blurRadius: 10.0,
                            //                                   ),
                            //                                 ],
                            //                                 borderRadius: BorderRadius.only(
                            //                                   topLeft: Radius.circular(5.0.sp),
                            //                                   bottomLeft: Radius.circular(5.0.sp),
                            //                                   bottomRight: Radius.circular(5.0.sp),
                            //                                   topRight: Radius.circular(5.0.sp),
                            //                                 ),
                            //                                 color: Colors.white,
                            //                               ),
                            //                               child: Row(
                            //                                 children: [
                            //                                   Flexible(
                            //                                     fit: FlexFit.tight,
                            //                                     flex: 2,
                            //                                     child: Container(
                            //                                       decoration: BoxDecoration(
                            //                                         borderRadius: BorderRadius.only(
                            //                                             topLeft: Radius.circular(5.0.sp),
                            //                                             bottomLeft: Radius.circular(5.0.sp)),
                            //                                         color: Colors.white,
                            //                                       ),
                            //                                       child: Center(
                            //                                           child: Text(
                            //                                         '${sellerDetails[index]['id'].toString()}',
                            //                                         style: TextStyle(
                            //                                             fontWeight: FontWeight.w600),
                            //                                       )),
                            //                                     ),
                            //                                   ),
                            //                                   Padding(
                            //                                     padding:
                            //                                         const EdgeInsets.symmetric(vertical: 4),
                            //                                     child: Container(
                            //                                         width: 1, color: Colors.black87),
                            //                                   ),
                            //                                   Flexible(
                            //                                     fit: FlexFit.tight,
                            //                                     flex: 2,
                            //                                     child: Container(
                            //                                       color: Colors.white,
                            //                                       child: Center(
                            //                                           child: Text(
                            //                                         '${sellerDetails[index]['name'].toString()}',
                            //                                         style: TextStyle(
                            //                                             fontWeight: FontWeight.normal,
                            //                                             color: Colors.grey[600]),
                            //                                       )),
                            //                                     ),
                            //                                   ),
                            //                                   Padding(
                            //                                     padding:
                            //                                         const EdgeInsets.symmetric(vertical: 4),
                            //                                     child: Container(
                            //                                         width: 1, color: Colors.black87),
                            //                                   ),
                            //                                   Flexible(
                            //                                     fit: FlexFit.tight,
                            //                                     flex: 2,
                            //                                     child: Container(
                            //                                       color: Colors.white,
                            //                                       child: Center(
                            //                                           child: Text(
                            //                                         '${sellerDetails[index]['return_days'].toString()}',
                            //                                         style: TextStyle(
                            //                                             fontWeight: FontWeight.normal,
                            //                                             color: Colors.grey[600]),
                            //                                       )),
                            //                                     ),
                            //                                   ),
                            //                                   Padding(
                            //                                     padding:
                            //                                         const EdgeInsets.symmetric(vertical: 4),
                            //                                     child: Container(
                            //                                         width: 1, color: Colors.black87),
                            //                                   ),
                            //                                   Flexible(
                            //                                     fit: FlexFit.tight,
                            //                                     flex: 2,
                            //                                     child: Container(
                            //                                       color: Colors.white,
                            //                                       child: Center(
                            //                                           child: Text(
                            //                                         '${sellerDetails[index]['amount'].toString()}',
                            //                                       )),
                            //                                     ),
                            //                                   ),
                            //                                   Padding(
                            //                                     padding:
                            //                                         const EdgeInsets.symmetric(vertical: 4),
                            //                                     child: Container(
                            //                                         width: 1, color: Colors.black87),
                            //                                   ),
                            //                                   Flexible(
                            //                                     fit: FlexFit.tight,
                            //                                     flex: 2,
                            //                                     child: Container(
                            //                                       decoration: BoxDecoration(
                            //                                         borderRadius: BorderRadius.only(
                            //                                             topRight: Radius.circular(5.0.sp),
                            //                                             bottomRight: Radius.circular(5.0.sp)),
                            //                                         color: Colors.white,
                            //                                       ),
                            //                                       child: Center(
                            //                                           child: IconButton(
                            //                                         onPressed: () {
                            //                                           SellerId =
                            //                                               sellerDetails[index]['seller_id'];
                            //                                           SellerAmount =
                            //                                               sellerDetails[index]['amount'];
                            //
                            //                                           _showMyDialog();
                            //                                           // Navigator.push(
                            //                                           //     context,
                            //                                           //     MaterialPageRoute(
                            //                                           //         builder: (context) =>
                            //                                           //             BookingDetails(
                            //                                           //                 sellerDetails[index]
                            //                                           //                 ['id'])));
                            //                                         },
                            //                                         icon: Icon(
                            //                                           Icons.check_circle,
                            //                                           size: 22.0.sp,
                            //                                           color: Colors.green,
                            //                                         ),
                            //                                       )),
                            //                                     ),
                            //                                   )
                            //                                 ],
                            //                               ),
                            //                             ),
                            //                           );
                            //                         })
                            //                     : Center(
                            //                         child: SpinKitThreeBounce(
                            //                           color: Theme.of(context).accentColor,
                            //                         ),
                            //                       ))
                            //       ],
                            //     ),
                            //   ),
                            // )
                          )
                        : Center(
                            child: SpinKitThreeBounce(
                              color: Theme.of(context).accentColor,
                            ),
                          ))
          ],
        ),
      ),

      // body: (
      //     Container(
      //   child: Column(
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           color: Theme.of(context).accentColor,
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      //           child: Row(
      //             children: [
      //               Flexible(
      //                 flex: 7,
      //                 fit: FlexFit.tight,
      //                 child: Container(
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       Text(
      //                         'Seller ',
      //                         overflow: TextOverflow.fade,
      //                         maxLines: 1,
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .headline6
      //                             .merge(TextStyle(color: Theme.of(context).primaryColor)),
      //                       ),
      //                       Text(
      //                         'Name',
      //                         overflow: TextOverflow.fade,
      //                         maxLines: 1,
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .headline6
      //                             .merge(TextStyle(color: Theme.of(context).primaryColor)),
      //                       ),
      //                     ],
      //                   ),
      //                   height: MediaQuery.of(context).size.height * 0.1,
      //                   color: Theme.of(context).accentColor,
      //                 ),
      //               ),
      //               Flexible(
      //                 flex: 5,
      //                 fit: FlexFit.tight,
      //                 child: Container(
      //                   height: MediaQuery.of(context).size.height * 0.1,
      //                   color: Theme.of(context).accentColor,
      //                   child: Center(
      //                     child: Text(
      //                       'Rs.(₹)',
      //                       style: Theme.of(context)
      //                           .textTheme
      //                           .headline6
      //                           .merge(TextStyle(color: Theme.of(context).primaryColor)),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //
      //               Flexible(
      //                 flex: 5,
      //                 fit: FlexFit.tight,
      //                 child: Container(
      //                   height: MediaQuery.of(context).size.height * 0.1,
      //                   color: Theme.of(context).accentColor,
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       Text(
      //                         'Return ',
      //                         overflow: TextOverflow.fade,
      //                         maxLines: 1,
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .headline6
      //                             .merge(TextStyle(color: Theme.of(context).primaryColor)),
      //                       ),
      //                       Text(
      //                         'Days',
      //                         overflow: TextOverflow.fade,
      //                         maxLines: 1,
      //                         style: Theme.of(context)
      //                             .textTheme
      //                             .headline6
      //                             .merge(TextStyle(color: Theme.of(context).primaryColor)),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Flexible(
      //                 flex: 5,
      //                 fit: FlexFit.tight,
      //                 child: Container(
      //                   height: MediaQuery.of(context).size.height * 0.1,
      //                   color: Theme.of(context).accentColor,
      //                   child: Center(
      //                     child: Text(
      //                       'Action',
      //                       style: Theme.of(context)
      //                           .textTheme
      //                           .headline6
      //                           .merge(TextStyle(color: Theme.of(context).primaryColor)),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               // Column(
      //               //   children: [
      //               //     Text(
      //               //       'Seller ',
      //               //       style: Theme.of(context).textTheme.headline6.merge(
      //               //           TextStyle(color: Theme.of(context).primaryColor)),
      //               //     ),
      //               //     Text(
      //               //       'Name',
      //               //       style: Theme.of(context).textTheme.headline6.merge(
      //               //           TextStyle(color: Theme.of(context).primaryColor)),
      //               //     ),
      //               //   ],
      //               // ),
      //               // Text(
      //               //   '     Rs.(₹)',
      //               //   style: Theme.of(context).textTheme.headline6.merge(
      //               //       TextStyle(color: Theme.of(context).primaryColor)),
      //               // ),
      //               // Column(
      //               //   children: [
      //               //     Text(
      //               //       'Return ',
      //               //       style: Theme.of(context).textTheme.headline6.merge(
      //               //           TextStyle(color: Theme.of(context).primaryColor)),
      //               //     ),
      //               //     Text(
      //               //       'Days',
      //               //       style: Theme.of(context).textTheme.headline6.merge(
      //               //           TextStyle(color: Theme.of(context).primaryColor)),
      //               //     ),
      //               //   ],
      //               // ),
      //               // Text(
      //               //   'Action',
      //               //   style: Theme.of(context).textTheme.headline6.merge(
      //               //       TextStyle(color: Theme.of(context).primaryColor)),
      //               // ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Container(
      //         height: MediaQuery.of(context).size.height * 0.77,
      //         child: ListView(children: [
      //           Container(
      //             height: MediaQuery.of(context).size.height * 0.77,
      //             child: sellerDetails.length > 0
      //                 ? ListView.builder(
      //                     itemCount: sellerDetails.length,
      //                     itemBuilder: (context, index) {
      //                       return Padding(
      //                         padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      //                         child: Container(
      //                           decoration: BoxDecoration(boxShadow: [
      //                             new BoxShadow(
      //                               color: Colors.black54,
      //                               blurRadius: 2.0,
      //                             ),
      //                           ], borderRadius: BorderRadius.circular(10)),
      //                           child: Row(
      //                             children: [
      //                               Flexible(
      //                                   flex: 7,
      //                                   fit: FlexFit.tight,
      //                                   child: Container(
      //                                     decoration: BoxDecoration(
      //                                       borderRadius: BorderRadius.only(
      //                                           topLeft: Radius.circular(10.0),
      //                                           bottomLeft: Radius.circular(10.0)),
      //                                       color: Colors.grey[100],
      //                                     ),
      //                                     height: MediaQuery.of(context).size.height * 0.08,
      //                                     child: Center(
      //                                         child: Text(
      //                                       sellerDetails[index]['name'],
      //                                       overflow: TextOverflow.fade,
      //                                       maxLines: 1,
      //                                       style: TextStyle(fontSize: 16),
      //                                     )),
      //                                   )),
      //                               Flexible(
      //                                   flex: 5,
      //                                   fit: FlexFit.tight,
      //                                   child: Container(
      //                                     child: Center(
      //                                       child: Text(
      //                                         sellerDetails[index]['amount'],
      //                                         overflow: TextOverflow.fade,
      //                                         maxLines: 1,
      //                                         style: TextStyle(fontSize: 17),
      //                                       ),
      //                                     ),
      //                                     height: MediaQuery.of(context).size.height * 0.08,
      //                                     color: Colors.grey[100],
      //                                   )),
      //                               Flexible(
      //                                   flex: 5,
      //                                   fit: FlexFit.tight,
      //                                   child: Container(
      //                                     height: MediaQuery.of(context).size.height * 0.08,
      //                                     color: Colors.grey[100],
      //                                     child: Center(
      //                                       child: Text(
      //                                         sellerDetails[index]['return_days'],
      //                                         overflow: TextOverflow.fade,
      //                                         maxLines: 1,
      //                                         style: TextStyle(fontSize: 17),
      //                                       ),
      //                                     ),
      //                                   )),
      //                               Flexible(
      //                                   flex: 5,
      //                                   fit: FlexFit.tight,
      //                                   child: Container(
      //                                     decoration: BoxDecoration(
      //                                       borderRadius: BorderRadius.only(
      //                                           topRight: Radius.circular(10.0),
      //                                           bottomRight: Radius.circular(10.0)),
      //                                       color: Colors.grey[100],
      //                                     ),
      //                                     height: MediaQuery.of(context).size.height * 0.08,
      //                                     child: IconButton(
      //                                         icon: Icon(
      //                                           Icons.check_circle,
      //                                           color: Colors.green,
      //                                           size: 30,
      //                                         ),
      //                                         onPressed: () {
      //                                           SellerId = sellerDetails[index]['seller_id'];
      //                                           SellerAmount = sellerDetails[index]['amount'];
      //
      //                                           _showMyDialog();
      //                                         }),
      //                                   )),
      //                             ],
      //                           ),
      //                         ),
      //                       );
      //                     }
      //
      //                     // itemBuilder: (context, index) => Padding(
      //                     //     padding: EdgeInsets.all(8.0),
      //                     //     child: Row(
      //                     //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                     //       children: [
      //                     //         Text(sellerDetails[index]['name']),
      //                     //         Text(sellerDetails[index]['amount']),
      //                     //         Text(sellerDetails[index]['return_days']),
      //                     //         InkWell(
      //                     //             onTap: () {
      //                     //               SellerId = sellerDetails[index]['seller_id'];
      //                     //               SellerAmount = sellerDetails[index]['amount'];
      //                     //
      //                     //               _showMyDialog();
      //                     //             },
      //                     //             child: Icon(
      //                     //               Icons.check_circle,
      //                     //               color: Colors.green,
      //                     //             )),
      //                     //       ],
      //                     //     )),
      //                     )
      //                 : Center(child: CircularProgressIndicator()),
      //           ),
      //         ]),
      //       ),
      //     ],
      //   ),
      // )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you select this Seller?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                saveBid();
              },
            ),
          ],
        );
      },
    );
  }
}
