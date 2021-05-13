import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/src/elements/BlockButtonWidget.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';
import 'package:spare_do/src/pages/signup.dart';

import '../../base_url.dart';
import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';

class SettingsWidget extends StatefulWidget {
  final String username, userphone, usercity;
  SettingsWidget(this.username, this.userphone, this.usercity);

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

String userid,
    LoggedInUserId,
    LoggedInUserName,
    LoggedInUserEmail,
    SelectedLocation,
    LoggedInUserCity;

class _SettingsWidgetState extends StateMVC<SettingsWidget> {
  SettingsController _con;

  _SettingsWidgetState() : super(SettingsController()) {
    _con = controller;
  }
  void getYearId(yearId) {
    SelectedLocation = yearId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + yearId);
  }

  Future<void> main1() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = (prefs.get('user_id'));
    var userName = (prefs.get('user_name'));
    var userEmail = (prefs.get('user_phone'));
    var usercity = (prefs.get('user_city'));

    LoggedInUserId = userId;
    LoggedInUserName = userName;
    LoggedInUserCity = usercity;
    print('helooooo' + '${LoggedInUserCity}');

    LoggedInUserEmail = userEmail;
  }

  String location, SelectedDistict, SelectedStatId, state, district, city;
  List cityList = List();
  List districtList = List();
  List locationList = List();
  List CurrentLocationList = List();

  void getCityId(locationId) {
    location = locationId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + locationId);
  }

  Future getCurrentLocationList() async {
    var response = await http.get(BaseUrl.getCurrentLocations + 'buyer_id=' + LoggedInUserId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.CurrentLocationList = data['data'];
    print('City');
    print(this.CurrentLocationList);
  }

  Future getCity(districtId) async {
    SelectedDistict = districtId;
    var response = await http
        .get(BaseUrl.city + 'location_id=' + SelectedStatId + '&' + 'district_id=' + districtId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.cityList = data['data'];
    print('City');
    print(this.cityList);
  }

  Future getDistrict(stateId) async {
    SelectedStatId = stateId;
    var response = await http.get(BaseUrl.district + 'location_id=' + stateId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.districtList = data['data'];
    print('District');
    print(this.districtList);
  }

  Future getLocation() async {
    var response = await http.get(BaseUrl.locations);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.locationList = data['data'];
    print('location');

    print('locoooooo' + location);
    print(this.locationList);
  }

  String userName1;
  String phone;
  String stateNameal, districtNameal, cityNameal;
  final _usernamecontroller = TextEditingController(text: LoggedInUserName);
  final _phonecontroller = TextEditingController(text: LoggedInUserEmail);
  // final TextEditingController _usernamecontroller = TextEditingController();
  // final TextEditingController _phonecontroller = TextEditingController();

  List updatedProfile = List();
  Future profileUpdate() async {
    // EasyLoading.show(
    //     dismissOnTap: false,
    //     maskType: EasyLoadingMaskType.black,
    //     status: 'loading...',
    //     indicator: SpinKitThreeBounce(
    //       color: Theme.of(context).accentColor,
    //     ));
    print('hllll');

    print(SelectedStatId);
    print(SelectedDistict);
    print(location);
    print('hllll');

    var response = await http.post(BaseUrl.profileUpdate +
                'name=' +
                _usernamecontroller.text +
                '&' +
                'phone=' +
                _phonecontroller.text +
                '&' +
                'state=' +
                SelectedStatId ==
            null
        ? 1
        : SelectedStatId +
            '&' +
            'district=' +
            SelectedDistict +
            '&' +
            'city=' +
            location +
            '&' +
            'buyer_id=' +
            LoggedInUserId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pushNamed('/Pages', arguments: 1);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.setString('user_id', LoginList[0]['id'].toString());
      // prefs.setString('user_name', LoginList[0]['name'].toString());
      EasyLoading.dismiss();

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }

    this.updatedProfile = data['data'];
    print('location');
    print('updatedProfile');
    print(this.updatedProfile);
  }

  @override
  void initState() {
    getLocation();

    main1();
    getCurrentLocationList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    main1();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: BaseAppBar(
        title: Text('title'),
        appBar: AppBar(
          leading: Icon(Icons.ac_unit),
        ),
        // widgets: <Widget>[Icon(Icons.more_vert)],
      ),
      //  drawer: DrawerWidget(),
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
            SizedBox(
              height: 2.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  S.of(context).profile,
                  style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            // Text(widget.usercity),
            SizedBox(
              height: 2.0.h,
            ),
            Container(
                height: 75.0.h,
                width: 80.0.w,
                child: CurrentLocationList.length > 0
                    ? ListView.builder(
                        itemCount: CurrentLocationList.length,
                        itemBuilder: (context, index) {
                          stateNameal = CurrentLocationList[index]['state_name'];
                          districtNameal = CurrentLocationList[index]['district_name'];
                          cityNameal = CurrentLocationList[index]['city_name'];
                          userName1 = CurrentLocationList[index]['name'];
                          return Container(
                            height: 75.0.h,
                            width: 80.0.w,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 4.0.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                                    child: TextFormField(
                                      //  initialValue: CurrentLocationList[index]['name'],
                                      keyboardType: TextInputType.text,
                                      controller: _usernamecontroller,

                                      //validator: RequiredValidator(errorText: "username is required"),
                                      // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                      validator:
                                          RequiredValidator(errorText: "username is required"),
                                      decoration: InputDecoration(
                                        //  labelText: S.of(context).user_name,
                                        labelStyle: TextStyle(color: Colors.black87),
                                        contentPadding: EdgeInsets.all(12),
                                        //   hintText: '${CurrentLocationList[index]['name']}',
                                        hintStyle: TextStyle(color: Colors.black87),
                                        prefixIcon: Icon(Icons.person_outline,
                                            color: Theme.of(context).accentColor),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                                    child: TextFormField(
                                      //  controller: _phonecontroller,
                                      //   initialValue: CurrentLocationList[index]['phone'],
                                      maxLength: 10,
                                      //initialValue: '${widget.userphone}',
                                      controller: _phonecontroller,
                                      keyboardType: TextInputType.number,
                                      validator: MultiValidator([
                                        RequiredValidator(errorText: "Phone Number is required"),
                                        PhoneNumberValidator()
                                      ]),

                                      //validator: RequiredValidator(errorText: "username is required"),
                                      // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        // prefixText: '+91 ',
                                        prefixStyle:
                                            TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                        // prefix: Text('+91'),
                                        //  labelText: 'Phone',
                                        labelStyle: TextStyle(color: Colors.black87),
                                        contentPadding: EdgeInsets.all(12),
                                        //   hintText: '${CurrentLocationList[index]['phone']}',
                                        hintStyle: TextStyle(color: Colors.black87),
                                        prefixIcon:
                                            Icon(Icons.phone, color: Theme.of(context).accentColor),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(horizontal: 30.0.sp),
                                  //   child: DropdownSearch<UserModel>(
                                  //     searchBoxDecoration: InputDecoration(
                                  //         prefixIcon: Icon(Icons.search),
                                  //         border: OutlineInputBorder(
                                  //             borderRadius: new BorderRadius.circular(5.0),
                                  //             borderSide: BorderSide(color: Colors.pinkAccent)),
                                  //         focusedBorder: OutlineInputBorder(),
                                  //         contentPadding: EdgeInsets.all(12),
                                  //         labelText: "Search location",
                                  //         labelStyle: TextStyle(color: Colors.black87)),
                                  //     showSearchBox: true,
                                  //     mode: Mode.BOTTOM_SHEET,
                                  //     dropdownSearchDecoration: InputDecoration(
                                  //       hintText: '${LoggedInUserCity}',
                                  //       hintStyle: TextStyle(color: Colors.black87),
                                  //       border:
                                  //           new UnderlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
                                  //       contentPadding: EdgeInsets.all(12),
                                  //       prefixIcon: Icon(Icons.location_on, color: Theme.of(context).accentColor),
                                  //     ),
                                  //     onFind: (String filter) async {
                                  //       var response = await Dio().get(
                                  //         BaseUrl.locations,
                                  //         queryParameters: {"filter": filter},
                                  //       );
                                  //
                                  //       var models = UserModel.fromJsonList(response.data['data']);
                                  //
                                  //       return models;
                                  //     },
                                  //     onChanged: (UserModel data) {
                                  //       setState(() {
                                  //         getYearId(data.id);
                                  //       });
                                  //       print(data.id);
                                  //     },
                                  //     popupTitle: Container(
                                  //       height: 50,
                                  //       decoration: BoxDecoration(
                                  //         color: Theme.of(context).accentColor,
                                  //         borderRadius: BorderRadius.only(
                                  //           topLeft: Radius.circular(20),
                                  //           topRight: Radius.circular(20),
                                  //         ),
                                  //       ),
                                  //       child: Center(
                                  //         child: Text(
                                  //           S.of(context).location_,
                                  //           style: TextStyle(
                                  //             fontSize: 24,
                                  //             fontWeight: FontWeight.bold,
                                  //             color: Colors.white,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     popupShape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.only(
                                  //         topLeft: Radius.circular(24),
                                  //         topRight: Radius.circular(24),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 2.0.h,
                                  // ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                                    child: DropdownButtonFormField(
                                      validator: (value) => value == null ? 'field required' : null,
                                      //   validator: RequiredValidator(errorText: "Choose Model"),
                                      decoration: new InputDecoration(
                                        prefixIcon: Icon(Icons.location_on_rounded,
                                            color: Theme.of(context).accentColor),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 15, bottom: 11, top: 11, right: 15),
                                      ),
                                      value: state,

                                      hint: Text(
                                        '${CurrentLocationList[index]['state_name']}',
                                        style: TextStyle(fontSize: 11.0.sp, color: Colors.black87),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: locationList.map((list2) {
                                        return DropdownMenuItem(
                                          child: Text(list2['name'].toString()),
                                          value: list2['id'].toString(),
                                        );
                                      })?.toList(),
                                      onChanged: (value3) {
                                        setState(() {
                                          //  getVariant(value3);
                                          getDistrict(value3);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                                    child: DropdownButtonFormField(
                                      validator: (value) => value == null ? 'field required' : null,
                                      //   validator: RequiredValidator(errorText: "Choose Model"),
                                      decoration: new InputDecoration(
                                        prefixIcon: Icon(Icons.location_on_rounded,
                                            color: Theme.of(context).accentColor),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 15, bottom: 11, top: 11, right: 15),
                                      ),
                                      value: district,

                                      hint: Text(
                                        '${CurrentLocationList[index]['district_name']}',
                                        style: TextStyle(fontSize: 11.0.sp, color: Colors.black87),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: districtList.map((list2) {
                                        return DropdownMenuItem(
                                          child: Text(list2['name'].toString()),
                                          value: list2['id'].toString(),
                                        );
                                      })?.toList(),
                                      onChanged: (value3) {
                                        setState(() {
                                          //  getVariant(value3);
                                          getCity(value3);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                                    child: DropdownButtonFormField(
                                      validator: (value) => value == null ? 'field required' : null,
                                      //   validator: RequiredValidator(errorText: "Choose Model"),
                                      decoration: new InputDecoration(
                                        prefixIcon: Icon(Icons.location_on_rounded,
                                            color: Theme.of(context).accentColor),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            left: 15, bottom: 11, top: 11, right: 15),
                                      ),
                                      value: city,

                                      hint: Text(
                                        '${CurrentLocationList[index]['city_name']}',
                                        style: TextStyle(fontSize: 11.0.sp, color: Colors.black87),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: cityList.map((list2) {
                                        return DropdownMenuItem(
                                          child: Text(list2['city'].toString()),
                                          value: list2['id'].toString(),
                                        );
                                      })?.toList(),
                                      onChanged: (value3) {
                                        setState(() {
                                          getCityId(value3);
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: BlockButtonWidget(
                                      text: Text(
                                        'Update',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.7),
                                      ),
                                      color: Theme.of(context).accentColor,
                                      onPressed: () {
                                        profileUpdate();

                                        //   print(_usernamecontroller.text);
                                        // print(_passwordcontroller.text);
                                        // _formKey.currentState.validate() ? LoginFunc() : null;

                                        //   _con.login();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: SpinKitThreeBounce(
                          color: Theme.of(context).accentColor,
                        ),
                      )),
          ],
        ),
      ),
    );

//     return Scaffold(
//         key: _con.scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             'Profile',
//             style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
//           ),
//         ),
//
//
//
//
//
//
//
//
//
//
//
//
//         body: currentUser.value.id == null
//             ? CircularLoadingWidget(height: 500)
//             : SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(vertical: 7),
//                 child: Column(
//                   children: <Widget>[
//
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             child: Column(
//                               children: <Widget>[
//                                 Text(
//                                   currentUser.value.name,
//                                   textAlign: TextAlign.left,
//                                   style: Theme.of(context).textTheme.headline3,
//                                 ),
//                                 Text(
//                                   currentUser.value.email,
//                                   style: Theme.of(context).textTheme.caption,
//                                 )
//                               ],
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                             ),
//                           ),
//                           SizedBox(
//                               width: 55,
//                               height: 55,
//                               child: InkWell(
//                                 borderRadius: BorderRadius.circular(300),
//                                 onTap: () {
//                                   Navigator.of(context).pushNamed('/Profile');
//                                 },
//                                 child: CircleAvatar(
//                                   backgroundImage: NetworkImage(currentUser.value.image.thumb),
//                                 ),
//                               )),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
//                       ),
//                       child: ListView(
//                         shrinkWrap: true,
//                         primary: false,
//                         children: <Widget>[
//                           ListTile(
//                             leading: Icon(Icons.person),
//                             title: Text(
//                               S.of(context).profile_settings,
//                               style: Theme.of(context).textTheme.bodyText1,
//                             ),
//                             trailing: ButtonTheme(
//                               padding: EdgeInsets.all(0),
//                               minWidth: 50.0,
//                               height: 25.0,
//                               child: ProfileSettingsDialog(
//                                 user: currentUser.value,
//                                 onChanged: () {
//                                   _con.update(currentUser.value);
// //                                  setState(() {});
//                                 },
//                               ),
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {},
//                             dense: true,
//                             title: Text(
//                               S.of(context).full_name,
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                             trailing: Text(
//                               currentUser.value.name,
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {},
//                             dense: true,
//                             title: Text(
//                               S.of(context).email,
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                             trailing: Text(
//                               currentUser.value.email,
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {},
//                             dense: true,
//                             title: Text(
//                               S.of(context).phone,
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                             trailing: Text(
//                               currentUser.value.phone,
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {},
//                             dense: true,
//                             title: Text(
//                               S.of(context).address,
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                             trailing: Text(
//                               Helper.limitString(currentUser.value.address ?? S.of(context).unknown),
//                               overflow: TextOverflow.fade,
//                               softWrap: false,
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {},
//                             dense: true,
//                             title: Text(
//                               S.of(context).about,
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                             trailing: Text(
//                               Helper.limitString(currentUser.value.bio),
//                               overflow: TextOverflow.fade,
//                               softWrap: false,
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
//                       ),
//                       child: ListView(
//                         shrinkWrap: true,
//                         primary: false,
//                         children: <Widget>[
//                           ListTile(
//                             leading: Icon(Icons.credit_card),
//                             title: Text(
//                               S.of(context).payments_settings,
//                               style: Theme.of(context).textTheme.bodyText1,
//                             ),
//                             trailing: ButtonTheme(
//                               padding: EdgeInsets.all(0),
//                               minWidth: 50.0,
//                               height: 25.0,
//                               child: PaymentSettingsDialog(
//                                 creditCard: _con.creditCard,
//                                 onChanged: () {
//                                   _con.updateCreditCard(_con.creditCard);
//                                   //setState(() {});
//                                 },
//                               ),
//                             ),
//                           ),
//                           ListTile(
//                             dense: true,
//                             title: Text(
//                               S.of(context).default_credit_card,
//                               style: Theme.of(context).textTheme.bodyText2,
//                             ),
//                             trailing: Text(
//                               _con.creditCard.number.isNotEmpty ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...') : '',
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(6),
//                         boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.15), offset: Offset(0, 3), blurRadius: 10)],
//                       ),
//                       child: ListView(
//                         shrinkWrap: true,
//                         primary: false,
//                         children: <Widget>[
//                           ListTile(
//                             leading: Icon(Icons.settings),
//                             title: Text(
//                               S.of(context).app_settings,
//                               style: Theme.of(context).textTheme.bodyText1,
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {
//                               Navigator.of(context).pushNamed('/Languages');
//                             },
//                             dense: true,
//                             title: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.translate,
//                                   size: 22,
//                                   color: Theme.of(context).focusColor,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   S.of(context).languages,
//                                   style: Theme.of(context).textTheme.bodyText2,
//                                 ),
//                               ],
//                             ),
//                             trailing: Text(
//                               S.of(context).english,
//                               style: TextStyle(color: Theme.of(context).focusColor),
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {
//                               Navigator.of(context).pushNamed('/DeliveryAddresses');
//                             },
//                             dense: true,
//                             title: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.place,
//                                   size: 22,
//                                   color: Theme.of(context).focusColor,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   S.of(context).delivery_addresses,
//                                   style: Theme.of(context).textTheme.bodyText2,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ListTile(
//                             onTap: () {
//                               Navigator.of(context).pushNamed('/Help');
//                             },
//                             dense: true,
//                             title: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   Icons.help,
//                                   size: 22,
//                                   color: Theme.of(context).focusColor,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   S.of(context).help_support,
//                                   style: Theme.of(context).textTheme.bodyText2,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ));
  }
}
