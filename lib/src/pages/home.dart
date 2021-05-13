import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';
import 'package:spare_do/src/elements/DrawerWidget.dart';
import 'package:spare_do/src/pages/login.dart';

import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/CaregoriesCarouselWidget.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;
  final Geolocator geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress = "", UserId;

  Position currentLocation;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    // getCurrentLocation();
    LoginCheck();
    super.initState();
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {});
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
      child: Scaffold(
        appBar: BaseAppBar(
          title: Text('title'),
          appBar: AppBar(),
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
        body: RefreshIndicator(
            onRefresh: refresh,
            child:
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   mainAxisSize: MainAxisSize.max,
                //   children: List.generate(settingsRepo.setting.value.homeSections.length, (index) {
                //     String _homeSection = settingsRepo.setting.value.homeSections.elementAt(index);
                //     switch (_homeSection) {
                //       case 'slider':
                //         return HomeSliderWidget(slides: _con.slides);
                //       case 'search':
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           child: SearchBarWidget(
                //             onClickFilter: (event) {
                //               widget.parentScaffoldKey.currentState.openEndDrawer();
                //             },
                //           ),
                //         );
                //       case 'top_restaurants_heading':
                //         return Padding(
                //           padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Expanded(
                //                     child: Text(
                //                       S.of(context).top_restaurants,
                //                       style: Theme.of(context).textTheme.headline4,
                //                       maxLines: 1,
                //                       softWrap: false,
                //                       overflow: TextOverflow.fade,
                //                     ),
                //                   ),
                //                   InkWell(
                //                     onTap: () {
                //                       if (currentUser.value.apiToken == null) {
                //                         _con.requestForCurrentLocation(context);
                //                       } else {
                //                         var bottomSheetController = widget.parentScaffoldKey.currentState.showBottomSheet(
                //                           (context) => DeliveryAddressBottomSheetWidget(scaffoldKey: widget.parentScaffoldKey),
                //                           shape: RoundedRectangleBorder(
                //                             borderRadius: new BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                //                           ),
                //                         );
                //                         bottomSheetController.closed.then((value) {
                //                           _con.refreshHome();
                //                         });
                //                       }
                //                     },
                //                     child: Container(
                //                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.all(Radius.circular(5)),
                //                         color: settingsRepo.deliveryAddress.value?.address == null
                //                             ? Theme.of(context).focusColor.withOpacity(0.1)
                //                             : Theme.of(context).accentColor,
                //                       ),
                //                       child: Text(
                //                         S.of(context).delivery,
                //                         style: TextStyle(
                //                             color:
                //                                 settingsRepo.deliveryAddress.value?.address == null ? Theme.of(context).hintColor : Theme.of(context).primaryColor),
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(width: 7),
                //                   InkWell(
                //                     onTap: () {
                //                       setState(() {
                //                         settingsRepo.deliveryAddress.value?.address = null;
                //                       });
                //                     },
                //                     child: Container(
                //                       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.all(Radius.circular(5)),
                //                         color: settingsRepo.deliveryAddress.value?.address != null
                //                             ? Theme.of(context).focusColor.withOpacity(0.1)
                //                             : Theme.of(context).accentColor,
                //                       ),
                //                       child: Text(
                //                         S.of(context).pickup,
                //                         style: TextStyle(
                //                             color:
                //                                 settingsRepo.deliveryAddress.value?.address != null ? Theme.of(context).hintColor : Theme.of(context).primaryColor),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               if (settingsRepo.deliveryAddress.value?.address != null)
                //                 Padding(
                //                   padding: const EdgeInsets.only(top: 12),
                //                   child: Text(
                //                     S.of(context).near_to + " " + (settingsRepo.deliveryAddress.value?.address),
                //                     style: Theme.of(context).textTheme.caption,
                //                   ),
                //                 ),
                //             ],
                //           ),
                //         );
                //       case 'top_restaurants':
                //         return CardsCarouselWidget(restaurantsList: _con.topRestaurants, heroTag: 'home_top_restaurants');
                //       case 'trending_week_heading':
                //         return ListTile(
                //           dense: true,
                //           contentPadding: EdgeInsets.symmetric(horizontal: 20),
                //           leading: Icon(
                //             Icons.trending_up,
                //             color: Theme.of(context).hintColor,
                //           ),
                //           title: Text(
                //             S.of(context).trending_this_week,
                //             style: Theme.of(context).textTheme.headline4,
                //           ),
                //           subtitle: Text(
                //             S.of(context).clickOnTheFoodToGetMoreDetailsAboutIt,
                //             maxLines: 2,
                //             style: Theme.of(context).textTheme.caption,
                //           ),
                //         );
                //       case 'trending_week':
                //         return FoodsCarouselWidget(foodsList: _con.trendingFoods, heroTag: 'home_food_carousel');
                //       case 'categories_heading':
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           child: ListTile(
                //             dense: true,
                //             contentPadding: EdgeInsets.symmetric(vertical: 0),
                //             leading: Icon(
                //               Icons.category,
                //               color: Theme.of(context).hintColor,
                //             ),
                //             title: Text(
                //               S.of(context).food_categories,
                //               style: Theme.of(context).textTheme.headline4,
                //             ),
                //           ),
                //         );
                //       case 'categories':
                //         return CategoriesCarouselWidget(
                //           categories: _con.categories,
                //         );
                //       case 'popular_heading':
                //         return Padding(
                //           padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                //           child: ListTile(
                //             dense: true,
                //             contentPadding: EdgeInsets.symmetric(vertical: 0),
                //             leading: Icon(
                //               Icons.trending_up,
                //               color: Theme.of(context).hintColor,
                //             ),
                //             title: Text(
                //               S.of(context).most_popular,
                //               style: Theme.of(context).textTheme.headline4,
                //             ),
                //           ),
                //         );
                //       case 'popular':
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           child: GridWidget(
                //             restaurantsList: _con.popularRestaurants,
                //             heroTag: 'home_restaurants',
                //           ),
                //         );
                //       case 'recent_reviews_heading':
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           child: ListTile(
                //             dense: true,
                //             contentPadding: EdgeInsets.symmetric(vertical: 20),
                //             leading: Icon(
                //               Icons.recent_actors,
                //               color: Theme.of(context).hintColor,
                //             ),
                //             title: Text(
                //               S.of(context).recent_reviews,
                //               style: Theme.of(context).textTheme.headline4,
                //             ),
                //           ),
                //         );
                //       case 'recent_reviews':
                //         return Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                //           child: ReviewsListWidget(reviewsList: _con.recentReviews),
                //         );
                //       default:
                //         return SizedBox(height: 0);
                //     }
                //   }),
                // ),
                ListView(
              // mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).choose_vehicle_type1,
                        style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
//               ListTile(
//   contentPadding: EdgeInsets.symmetric(horizontal: 20),
//  // leading: Icon(Icons.location_on_rounded,  color: Theme.of(context).accentColor),
//
//  // title: Text(_currentAddress,style: Theme.of(context).textTheme.headline6,),
//                 title: Center(child: Text('Choose vehicle Type')),
// ),
                InkWell(
                  //splashColor: Colors.green,

                  child: CategoriesCarouselWidget(
                    categories: _con.categories,
                  ),
                ),

                // Stack(
                //     children:[
                //       TranslationAnimatedWidget.tween(
                //         duration: Duration(milliseconds: 250),
                //         translationDisabled: Offset(100, 0),
                //         translationEnabled: Offset(0, 0),
                //         child: OpacityAnimatedWidget.tween(
                //           opacityDisabled: 0,
                //           opacityEnabled: 1,
                //           child: InkWell(
                //             onTap: (){
                //               Navigator.push(context, MaterialPageRoute(builder: (context)=>BikeScreen()));
                //             },
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                   boxShadow: [new BoxShadow(
                //                     color: Colors.grey[400],
                //                     blurRadius: 20.0,
                //                   ),],
                //                 borderRadius: BorderRadius.all(Radius.circular(15)),
                //               ),
                //               height: MediaQuery.of(context).size.height*0.30,
                //               width: MediaQuery.of(context).size.width*0.80,
                //               // color: Colors.pink,
                //               child: Image.asset('assets/img/bike  Icon.png'),
                //               //    child: Image.network('data:image/jpeg;base64,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',height: MediaQuery.of(context).size.height*.5,width: MediaQuery.of(context).size.width*.5),
                //             ),
                //           ),
                //         ),
                //       ),
                //
                //
                //     ]
                // ),
                // Container(
                //   height: 600,
                //   width: 300,
                //   child: ListView.builder(
                //
                //     itemCount: 2 ,
                //     itemBuilder: (context, index) => Padding(
                //         padding: EdgeInsets.all(8.0),
                //         child:  Stack(
                //             children:[
                //               TranslationAnimatedWidget.tween(
                //                 duration: Duration(milliseconds: 250),
                //                 translationDisabled: Offset(-100, 0),
                //                 translationEnabled: Offset(0, 0),
                //                 child: OpacityAnimatedWidget.tween(
                //                   opacityDisabled: 0,
                //                   opacityEnabled: 1,
                //                   child: InkWell(
                //                     onTap: (){
                //                       Navigator.push(context, MaterialPageRoute(builder: (context)=>CarScreen()));
                //                     },
                //                     child: Container(
                //                       decoration: BoxDecoration(
                //                         color: Colors.white,
                //                         boxShadow: [new BoxShadow(
                //                           color: Colors.grey[400],
                //                           blurRadius: 20.0,
                //                         ),],
                //
                //                         borderRadius: BorderRadius.all(Radius.circular(15)),
                //                       ),
                //                       height: MediaQuery.of(context).size.height*0.30,
                //                       width: MediaQuery.of(context).size.width*0.80,
                //                       // color: Colors.pink,
                //                       child: Image.asset('assets/img/car Icon.png'),
                //                       //    child: Image.network('data:image/jpeg;base64,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',height: MediaQuery.of(context).size.height*.5,width: MediaQuery.of(context).size.width*.5),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //
                //
                //             ]
                //         ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
              ],
            )),
      ),
    );
  }
// void getCurrentLocation() async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   // await prefs.get(_currentAddress);
//
//   setState(() {
//     _currentPosition = position;
//     // print("Hi, Your location is ${_currentPosition}");
//   });
//   final coordinates = new Coordinates(position.latitude, position.longitude);
//
//   var addresses =
//   await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   var first = addresses.first;
//   // print("${first.featureName} : ${first.addressLine}");
//   print("Your current address is -   ${first.addressLine}");
//
//   setState(() {
//   //   _currentAddress = "${first.featureName}, ${first.addressLine}";
//     _currentAddress = " ${first.locality}, ${first.adminArea}";
//
//   });
// }
}
