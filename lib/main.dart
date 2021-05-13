import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer_util.dart';
import 'package:spare_do/src/pages/login.dart';
import 'package:spare_do/src/pages/pages.dart';

import 'base_url.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;

String UserId;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.get('user_id'));
  var userId = (prefs.get('user_id'));
  UserId = userId;
  await GlobalConfiguration().loadFromAsset("configurations");
  await Firebase.initializeApp();
  print(CustomTrace(StackTrace.current,
      message: "base_url: ${GlobalConfiguration().getValue('base_url')}"));
  print(CustomTrace(StackTrace.current,
      message: "api_base_url: ${GlobalConfiguration().getValue('api_base_url')}"));
  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..maskColor = Colors.blue
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.red
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.red
    ..textColor = Colors.red
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  void initState() {
    LoginCheck();
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    main();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return ValueListenableBuilder(
              valueListenable: settingRepo.setting,
              builder: (context, Setting _setting, _) {
                print(CustomTrace(StackTrace.current, message: _setting.toMap().toString()));

                return MaterialApp(
                  navigatorKey: settingRepo.navigatorKey,
                  title: _setting.appName,
                  home: UserId == null ? LoginWidget() : PagesWidget(),
                  builder: EasyLoading.init(),
                  onGenerateRoute: RouteGenerator.generateRoute,
                  debugShowCheckedModeBanner: false,
                  locale: _setting.mobileLanguage.value,
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  theme: ThemeData(
                    fontFamily: 'Poppins',
                    primaryColor: Color.fromRGBO(253, 163, 8, 1),
                    floatingActionButtonTheme:
                        FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                    brightness: Brightness.light,
                    accentColor: Color.fromRGBO(253, 163, 8, 1),
                    dividerColor: Colors.black87,
                    focusColor: Colors.grey[400],
                    hintColor: Colors.grey[400],
                    textTheme: TextTheme(
                      headline5: TextStyle(fontSize: 20.0, color: Colors.black87, height: 1.35),
                      headline4: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.35),
                      headline3: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.35),
                      headline2: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.35),
                      headline1: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87,
                          height: 1.5),
                      subtitle1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.35),
                      headline6: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.35),
                      bodyText2: TextStyle(fontSize: 12.0, color: Colors.black87, height: 1.35),
                      bodyText1: TextStyle(fontSize: 14.0, color: Colors.black87, height: 1.35),
                      caption: TextStyle(fontSize: 12.0, color: Colors.black87, height: 1.35),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
