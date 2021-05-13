import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/src/pages/Terms.dart';
import 'package:spare_do/src/pages/login.dart';
import 'package:spare_do/src/pages/settings.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

String userid, LoggedInUserId, LoggedInUserName, LoggedInUserEmail, LoggedInUserCity;

class _DrawerWidgetState extends StateMVC<DrawerWidget> {
  _DrawerWidgetState() : super(ProfileController()) {}

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userId = (prefs.get('user_id'));
    var userName = (prefs.get('user_name'));
    var userEmail = (prefs.get('user_phone'));
    var usercity = (prefs.get('user_city'));

    LoggedInUserId = userId;
    LoggedInUserName = userName;
    LoggedInUserCity = usercity;
    print(LoggedInUserName);
    print(LoggedInUserEmail);
    print(LoggedInUserId);
    print(LoggedInUserCity);
    LoggedInUserEmail = userEmail;
  }

  @override
  void initState() {
    // TODO: implement initState
    main();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // main();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // GestureDetector(
          //     onTap: () {
          //       // currentUser.value.apiToken != null
          //       //     ? Navigator.of(context).pushNamed('/Settings')
          //       //     : Navigator.of(context).pushNamed('/Login');
          //     },
          //     child: UserAccountsDrawerHeader(
          //       decoration: BoxDecoration(
          //         color: Colors.black,
          //       ),
          //       accountName: Text(
          //         LoggedInUserName,
          //         style: Theme.of(context).textTheme.headline6,
          //       ),
          //       accountEmail: Text(
          //         currentUser.value.email,
          //         style: Theme.of(context).textTheme.caption,
          //       ),
          //       currentAccountPicture: Image.asset(
          //         'assets/img/2.png',
          //         height: MediaQuery.of(context).size.height * 0.06,
          //         width: MediaQuery.of(context).size.width * 0.5,
          //       ),
          //     ),
          // ),

          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Container(
          //     color: Colors.black,
          //     child: ListTile(
          //       tileColor: Colors.black,
          //       onTap: () {
          //         //   Navigator.of(context).pushNamed('/Pages', arguments: 1);
          //       },
          //       leading: Icon(
          //         Icons.person,
          //         color: Theme.of(context).focusColor.withOpacity(1),
          //       ),
          //       title: Row(
          //         children: [
          //           Text(
          //             'Hi ,',
          //             style: TextStyle(color: Colors.white, fontSize: 18),
          //           ),
          //           Text(
          //             LoggedInUserName,
          //             style: TextStyle(color: Colors.white, fontSize: 20),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 3.0.h,
          ),
          CircleAvatar(
            radius: 30.0.sp,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.person,
              size: 30.0.sp,
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(
            height: 1.4.h,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).hi_,
                style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                LoggedInUserName,
                style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.w600),
              )
            ],
          ),
          SizedBox(
            height: 3.0.h,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0.w),
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 1.0.h,
          ),
          ListTile(
            onTap: () {
              //   Navigator.of(context).pushNamed('/Settings', arguments: 2);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SettingsWidget(LoggedInUserName, LoggedInUserEmail, LoggedInUserCity)));
            },
            leading: Icon(
              Icons.person,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).profile,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 1);
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).home,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              Icons.book,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).my_bookings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),

          // ListTile(
          //   onTap: () {
          //
          //   },
          //   leading: Icon(
          //     Icons.home,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     'home',
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Profile', arguments: 2);
          //   },
          //   leading: Icon(
          //     Icons.lock,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     'Change Password',
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),

          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 0);
          //   },
          //   leading: Icon(
          //     Icons.notifications,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).notifications,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 3);
          //   },
          //   leading: Icon(
          //     Icons.local_mall,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).my_orders,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Favorites');
          //   },
          //   leading: Icon(
          //     Icons.favorite,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).favorite_foods,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermsCon()));
            },
            leading: Icon(
              Icons.account_balance_wallet_rounded,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).terms,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/Pages', arguments: 2);
          //   },
          //   leading: Icon(
          //     Icons.chat,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).messages,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   dense: true,
          //   title: Text(
          //     S.of(context).application_preferences,
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          //   trailing: Icon(
          //     Icons.remove,
          //     color: Theme.of(context).focusColor.withOpacity(0.3),
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).help__support,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     if (currentUser.value.apiToken != null) {
          //       Navigator.of(context).pushNamed('/Settings');
          //     } else {
          //       Navigator.of(context).pushReplacementNamed('/Login');
          //     }
          //   },
          //   leading: Icon(
          //     Icons.settings,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     S.of(context).settings,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('user_id');
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (BuildContext ctx) => LoginWidget()));
            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              S.of(context).log_out,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          // ListTile(
          //   onTap: () {
          //     if (Theme.of(context).brightness == Brightness.dark) {
          //       setBrightness(Brightness.light);
          //       setting.value.brightness.value = Brightness.light;
          //     } else {
          //       setting.value.brightness.value = Brightness.dark;
          //       setBrightness(Brightness.dark);
          //     }
          //     setting.notifyListeners();
          //   },
          //   leading: Icon(
          //     Icons.brightness_6,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // ListTile(
          //   onTap: () {
          //     if (currentUser.value.apiToken != null) {
          //       logout().then((value) {
          //         Navigator.of(context).pushNamedAndRemoveUntil(
          //             '/Pages', (Route<dynamic> route) => false,
          //             arguments: 2);
          //       });
          //     } else {
          //       Navigator.of(context).pushNamed('/Login');
          //     }
          //   },
          //   leading: Icon(
          //     Icons.exit_to_app,
          //     color: Theme.of(context).focusColor.withOpacity(1),
          //   ),
          //   title: Text(
          //     currentUser.value.apiToken != null
          //         ? S.of(context).log_out
          //         : S.of(context).login,
          //     style: Theme.of(context).textTheme.subtitle1,
          //   ),
          // ),
          // currentUser.value.apiToken == null
          //     ? ListTile(
          //         onTap: () {
          //           Navigator.of(context).pushNamed('/SignUp');
          //         },
          //         leading: Icon(
          //           Icons.person_add,
          //           color: Theme.of(context).focusColor.withOpacity(1),
          //         ),
          //         title: Text(
          //           S.of(context).register,
          //           style: Theme.of(context).textTheme.subtitle1,
          //         ),
          //       )
          //     : SizedBox(height: 0),
          // setting.value.enableVersion
          //     ? ListTile(
          //         dense: true,
          //         title: Text(
          //           S.of(context).version + " " + setting.value.appVersion,
          //           style: Theme.of(context).textTheme.bodyText2,
          //         ),
          //         trailing: Icon(
          //           Icons.remove,
          //           color: Theme.of(context).focusColor.withOpacity(0.3),
          //         ),
          //       )
          //     : SizedBox(),
        ],
      ),
    );
  }
}
