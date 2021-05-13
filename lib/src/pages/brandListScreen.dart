import 'dart:convert';

import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';
import 'package:spare_do/src/pages/BookingForm.dart';

import '../../generated/l10n.dart';
import '../models/category.dart';
import 'login.dart';

class BrandList extends StatefulWidget {
  @override
  _BrandListState createState() => _BrandListState();
}

Category category;
double marginLeft;

class _BrandListState extends State<BrandList> {
  List brandsList = List();
  String UserId;
  final LocalStorage storage = new LocalStorage("");
  Future getBrands() async {
    final LocalStorage storage = new LocalStorage("");
    var selected_category = storage.getItem('category_id');
    // var selected_brand=storage.setItem('brand_id', brandsList[index]['name']);
    // categoryName=storage.getItem('category_name');

    var response = await http.get(BaseUrl.brands + 'category_id=' + selected_category);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });

    this.brandsList = data['data'];
    print('branddddddddddddddddList');
    print(this.brandsList);
  }

  @override
  void initState() {
    getBrands();
    LoginCheck();
//    _clearvalue();
    super.initState();
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getBrands();
    });
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: BaseAppBar(
          title: Text('title'),
          appBar: AppBar(),
          //  widgets: <Widget>[Icon(Icons.more_vert)],
        ),

        // drawer: DrawerWidget(),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            children: [
              SizedBox(
                height: 2.0.h,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).choose_brand,
                      style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2.0.h,
              ),
              Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.1, 0.9],
                      colors: [
                        Colors.grey[50],
                        Colors.grey[50],
                      ],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.875,
                  child: brandsList.length > 0
                      ? Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                              itemCount: brandsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Ink(
                                    color: Colors.grey,
                                    child: Container(
                                      child: TranslationAnimatedWidget.tween(
                                        duration: Duration(milliseconds: 150),
                                        translationDisabled: Offset(0, 400),
                                        translationEnabled: Offset(0, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15)),
                                          height: MediaQuery.of(context).size.height * 0.5,
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: BouncingWidget(
                                            duration: Duration(milliseconds: 100),
                                            scaleFactor: 1.5,
                                            onPressed: () {
                                              var selected_category = storage.setItem(
                                                  'brand_id', brandsList[index]['id'].toString());

                                              // print(brnad);
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      duration: Duration(milliseconds: 400),
                                                      type: PageTransitionType.rightToLeft,
                                                      child: BookingForm()));
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 10,
                                              shadowColor: Colors.grey[50],
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      '${BaseUrl.brandImage}${brandsList[index]['image']}',
                                                  placeholder: (context, url) => Image.asset(
                                                    'assets/img/loading.gif',
                                                    height:
                                                        MediaQuery.of(context).size.height * 0.2,
                                                    width: MediaQuery.of(context).size.width * 0.2,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Text(
                                              //   brandsList[index]['name'].toUpperCase() ?? '',
                                              //   style: TextStyle(fontSize: 15),
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                                // return ListTile(
                                //   title: Text(brandsList[index]['name']),
                                //   leading: Image.network('http://192.168.1.147:8080/spare_do/public/assets/brand/${brandsList[index]['image']}'),
                                // );
                              }),
                        )
                      : Center(
                          child: SpinKitThreeBounce(
                            color: Theme.of(context).accentColor,
                          ),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
