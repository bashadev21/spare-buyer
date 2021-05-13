import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:file/local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:file/file.dart';
// import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/base_url.dart';
import 'package:spare_do/src/elements/BlockButtonWidget.dart';
import 'package:spare_do/src/elements/CustomAppBar.dart';
import 'package:spare_do/src/pages/carScreen.dart';
import 'package:spare_do/src/pages/login.dart';
import 'package:spare_do/src/pages/pages.dart';

import '../../generated/l10n.dart';

typedef void OnError(Exception exception);
var KUrl = "https://sparesdo.com/public/assets/booking_voice_note/9/602b8b42860f0bookingVoice.wav";

@immutable
class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body,
  });
}

class BookingForm extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  BookingForm({localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _BookingFormState createState() => _BookingFormState();
}

enum PlayerState { stopped, playing, paused }

class _BookingFormState extends State<BookingForm> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';

  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool pressAttention = false;
  int groupValue = -1;
  String brand,
      model,
      variant,
      year,
      selectedModelId,
      selectedBrandId,
      UserId,
      selectedvariant,
      state,
      district,
      city,
      SelectedFuelId,
      fuel;
  final _formKey = GlobalKey<FormState>();
  List modelList = List();
  List variantList = List();
  List locationList = List();
  List cityList = List();

  List yearList = List();
  List fuelList = List();
  List districtList = List();
  bool _autovalidate = false;
  String selectedSalutation;
  String name;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  var image;
  final picker = ImagePicker();
  List imagearray = [];
  _opencam() async {
    image = await picker.getImage(source: ImageSource.camera).then((pickedFile) => pickedFile.path);
    imagearray.add(image);
    setState(() {
      imagearray;
      print(imagearray);
    });
  }

  final TextEditingController _controller = TextEditingController();
  final LocalStorage storage = new LocalStorage("");
  Future getModels() async {
    var brnad = storage.getItem('brand_id');
    var selected_category = storage.getItem('category_id');
    selectedBrandId = brand;

    var response = await http.get(BaseUrl.models +
        'category_id=' +
        selected_category.toString() +
        '&' +
        'brand_id=' +
        brnad.toString());
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });

    this.modelList = data['data'];
    print('listtttt');
    print(this.modelList);
  }

  // Initially password is obscure
  bool _obscureText = true;

  String _password;

  // Toggles the password show status

  File _image1;

  Future getImage() async {
    final pickedFile1 = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile1 != null) {
        _image1 = File(pickedFile1.path);
      } else {
        print('No image selected.');
      }
    });
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

  Future getVariant(modelId) async {
    var brnad = storage.getItem('brand_id');
    var selected_category = storage.getItem('category_id');

    selectedModelId = modelId;
    var response = await http.get(BaseUrl.variants +
        'category_id=' +
        selected_category +
        '&' +
        'brand_id=' +
        brnad +
        '&' +
        'model_id=' +
        modelId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.variantList = data['data'];
    print('varienttttt');
    print(this.variantList);
  }

  Future getYear(variantId) async {
    var brnad = storage.getItem('brand_id');
    var selected_category = storage.getItem('category_id');
    ;
    selectedvariant = variantId;
    print(variantId);
    var response = await http.get(BaseUrl.year +
        'category_id=' +
        selected_category +
        '&' +
        'brand_id=' +
        brnad +
        '&' +
        'model_id=' +
        selectedModelId +
        '&' +
        'variant_id=' +
        variantId);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });
    print('yearrrrrrrrr');
    this.yearList = data['data'];
    print(this.yearList);
  }

  void getYearId(yearId) {
    SelectedYearId = yearId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + yearId);
  }

  void getFuelId(fuelId) {
    SelectedFuelId = fuelId;
    print('ful' + fuelId);
  }

  Future getFuel() async {
    var response = await http.get(BaseUrl.fuel);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });

    this.fuelList = data['data'];
    print(this.fuelList);
  }

  Future uploadmultipleimage(List imagearray) async {
    var uri = Uri.parse(BaseUrl.booking);

    http.MultipartRequest request = new http.MultipartRequest('POST', uri);

    var brnad = storage.getItem('brand_id');
    var selected_category = storage.getItem('category_id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('user_id');
    setState(() {
      var current_user = (prefs.getString('user_id') ?? '');
      UserId = prefs.getString('user_id');
      print(UserId);
    });
    print('radiooo' + '${groupValue}');
    print('radiooo' + '${fuel}');
    print('state' + '${SelectedStatId}');
    print('cityyyy' + '${location}');
    print('disttttttt' + '${SelectedDistict}');
    print('radiooo' + '${fuel}');

    request.fields['category'] = selected_category;
    request.fields['model'] = selectedModelId;
    request.fields['brand'] = brnad;
    request.fields['city'] = location;
    request.fields['state'] = SelectedStatId;

    request.fields['district'] = SelectedDistict;
    request.fields['variant'] = selectedvariant;
    request.fields['year'] = SelectedYearId;
    request.fields['buyer'] = UserId;
    request.fields['description'] = _controller.text;
    request.fields['fuel'] = SelectedFuelId;
    //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));

    List<MultipartFile> newList = new List<MultipartFile>();

    for (int i = 0; i < imagearray.length; i++) {
      File imageFile = File(imagearray[i].toString());
      var stream = new http.ByteStream(imageFile.openRead());
      stream.cast();
      var length = await imageFile.length();
      print(length);
      var multipartFile =
          new http.MultipartFile('images', stream, length, filename: imageFile.path);
      newList.add(multipartFile);
    }

    request.files.addAll(newList);

    var response = await request.send();

    if (response.statusCode == 200) {
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future book() async {
    _showMyDialogload();

    print('imgessssssss' + '${_image1}');
    var brnad = storage.getItem('brand_id');
    var selected_category = storage.getItem('category_id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('user_id');
    setState(() {
      var current_user = (prefs.getString('user_id') ?? '');
      UserId = prefs.getString('user_id');
      print(UserId);
    });
    print('radiooo' + '${groupValue}');
    print('radiooo' + '${fuel}');
    print('state' + '${SelectedStatId}');
    print('cityyyy' + '${location}');
    print('disttttttt' + '${SelectedDistict}');
    print('radiooo' + '${fuel}');

    final uri = Uri.parse(BaseUrl.booking);
    var request = http.MultipartRequest('POST', uri);
    request.fields['category'] = selected_category;
    request.fields['model'] = selectedModelId;
    request.fields['brand'] = brnad;
    request.fields['city'] = location;
    request.fields['state'] = SelectedStatId;

    request.fields['district'] = SelectedDistict;
    request.fields['variant'] = selectedvariant;
    request.fields['year'] = SelectedYearId;
    request.fields['buyer'] = UserId;
    request.fields['description'] = _controller.text;
    request.fields['fuel'] = SelectedFuelId;
    request.fields['images'] = json.encode(imagearray);
    print('imagesssssssssssssssssssssssss' + '${json.encode(imagearray)}');
    // print(_current?.path);
    // if (_image1 != null) {
    //   var pic = await http.MultipartFile.fromPath('images', _image1.path);
    //   request.files.add(pic);
    // }
    var string_voice = _current?.path;
    if (string_voice.contains('.temp')) {
    } else {
      var audio = await http.MultipartFile.fromPath('voice_note', _current?.path);
      request.files.add(audio);
    }

    var response = await request.send();

    setState(() {
      print('statusCode : ' + response.statusCode.toString());
      print(response);
    });
    if (response.statusCode == 200) {
      sendNotification();
      return _showMyDialog15min();
    } else {
      return LinearProgressIndicator();
    }
  }

  List<Object> imagesList = List<Object>();
  Future<File> _imageFile;
  final List<Message> messages = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    getFuel();
    getModels();
    getLocation();
    LoginCheck();
    _init();
    initAudioPlayer();

    super.initState();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        //  setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    var ss = _current?.path;
    await audioPlayer.play(ss);

    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  String location, SelectedDistict, SelectedStatId;
  void getCityId(locationId) {
    location = locationId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + locationId);
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

  // Future mute(bool muted) async {
  //   await audioPlayer.mute(muted);
  //   setState(() {
  //     isMuted = muted;
  //   });
  // }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 5,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 500,
          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 2,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: BaseAppBar(
        title: Text('title'),
        appBar: AppBar(),
        //  widgets: <Widget>[Icon(Icons.more_vert)],
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   centerTitle: true,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //   ),
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.grey[50],
          height: MediaQuery.of(context).size.height * 0.89,
          child: Column(
            children: [
              Container(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).booking_page,
                      style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  // autovalidateMode: true,
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.79,
                    child: ListView(
                      //   physics: new BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child: DropdownButtonFormField(
                            validator: (value) => value == null ? 'field required' : null,
                            //   validator: RequiredValidator(errorText: "Choose Model"),
                            decoration: new InputDecoration(
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
                              contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            value: model,

                            hint: Text(
                              S.of(context).select_model,
                              style: TextStyle(fontSize: 11.0.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: modelList.map((list2) {
                              return DropdownMenuItem(
                                child: Text(list2['name'].toString()),
                                value: list2['id'].toString(),
                              );
                            })?.toList(),
                            onChanged: (value3) {
                              setState(() {
                                getVariant(value3);
                              });
                            },
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.040,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child: DropdownButtonFormField(
                            //  validator: RequiredValidator(errorText: "Choose Variant"),
                            validator: (value) => value == null ? 'field required' : null,
                            decoration: new InputDecoration(
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
                              contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            ),

                            value: variant,
                            hint: Text(
                              S.of(context).select_variant,
                              style: TextStyle(fontSize: 11.0.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: variantList.map((list3) {
                              return DropdownMenuItem(
                                child: Text(list3['name']),
                                value: list3['id'].toString(),
                              );
                            }).toList(),
                            onChanged: (value3) {
                              setState(() {
                                //     variant=value3;

                                getYear(value3);
                              });
                            },
                          ),
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),

                        Container(
                          height: 10.0.h,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                                    child: DropdownButtonFormField(
                                      validator: (value) => value == null ? 'field required' : null,
                                      //    validator: RequiredValidator(errorText: "Choose Year"),
                                      decoration: new InputDecoration(
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

                                      value: year,
                                      hint: Text(
                                        S.of(context).year_,
                                        style: TextStyle(fontSize: 11.0.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: yearList.map((list4) {
                                        return DropdownMenuItem(
                                          child: Text(list4['name']),
                                          value: list4['id'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (value3) {
                                        setState(() {
                                          getYearId(value3);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                                    child: DropdownButtonFormField(
                                      validator: (value) => value == null ? 'field required' : null,
                                      //    validator: RequiredValidator(errorText: "Choose Year"),
                                      decoration: new InputDecoration(
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

                                      value: fuel,
                                      hint: Text(
                                        S.of(context).fuel_,
                                        style: TextStyle(fontSize: 11.0.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      items: fuelList.map((list4) {
                                        return DropdownMenuItem(
                                          child: Text(list4['name']),
                                          value: list4['id'].toString(),
                                        );
                                      }).toList(),
                                      onChanged: (value3) {
                                        setState(() {
                                          getFuelId(value3);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        //   child: Row(
                        //     children: [
                        //       Text('Select Fuel Type'),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   height: 7.0.h,
                        //   child: GridView.builder(
                        //       physics: const NeverScrollableScrollPhysics(),
                        //       gridDelegate:
                        //           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        //       // scrollDirection: Axis.horizontal,
                        //       itemCount: fuelList.length,
                        //       itemBuilder: (context, index) {
                        //         return Padding(
                        //           padding: const EdgeInsets.all(0.0),
                        //           child: RadioListTile(
                        //             value: fuelList[index]['id'],
                        //             groupValue: groupValue,
                        //             title: Text(fuelList[index]['name']),
                        //             onChanged: (newValue) {
                        //               setState(() {
                        //                 groupValue = newValue;
                        //
                        //                 print(newValue);
                        //               });
                        //             },
                        //             activeColor: Theme.of(context).accentColor,
                        //             selected: false,
                        //           ),
                        //         );
                        //       }),
                        // ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child: Theme(
                            data: new ThemeData(
                              primaryColor: Theme.of(context).accentColor,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    stops: [0.1, 0.9],
                                    colors: [Colors.grey[50], Colors.grey[50]],
                                  ),
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Theme.of(context).focusColor.withOpacity(0.3),
                                        offset: Offset(0, 2),
                                        blurRadius: 7.0)
                                  ]),
                              child: new TextFormField(
                                // validator: RequiredValidator(errorText: "Description Required"),
                                autofocus: false,
                                controller: _controller,
                                maxLength: 100,
                                maxLines: 3,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                    hintText: 'Description',
                                    hintStyle: TextStyle(
                                      fontSize: 11.0.sp,
                                    ),

                                    // labelText: "Product Description",
                                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),

                        // Container(
                        //   height: 10.0.h,
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         width: 25.0.w,
                        //         color: Colors.grey[50],
                        //         child: _image1 == null ? Container() : Image.file(_image1),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 1.0.h),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.040,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child: DropdownButtonFormField(
                            validator: (value) => value == null ? 'field required' : null,
                            //   validator: RequiredValidator(errorText: "Choose Model"),
                            decoration: new InputDecoration(
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
                              contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            value: state,

                            hint: Text(
                              'Select State',
                              style: TextStyle(fontSize: 11.0.sp),
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.040),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child: DropdownButtonFormField(
                            validator: (value) => value == null ? 'field required' : null,
                            //   validator: RequiredValidator(errorText: "Choose Model"),
                            decoration: new InputDecoration(
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
                              contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            value: district,

                            hint: Text(
                              'Select District',
                              style: TextStyle(fontSize: 11.0.sp),
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
                        //  MessagingWidget(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.040),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0.w),
                          child: DropdownButtonFormField(
                            validator: (value) => value == null ? 'field required' : null,
                            //   validator: RequiredValidator(errorText: "Choose Model"),
                            decoration: new InputDecoration(
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
                              contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            ),
                            value: city,

                            hint: Text(
                              'Select City',
                              style: TextStyle(fontSize: 11.0.sp),
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
                        // Expanded(child: MessagingWidget()),
                        // SizedBox(height: MediaQuery.of(context).size.height * 0.040),
                        //
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                        //   child: Theme(
                        //     data: Theme.of(context).copyWith(brightness: Brightness.dark),
                        //     child: DropdownSearch<UserModel>(
                        //       autoFocusSearchBox: true,
                        //       //  validator: (value) => value == null ? 'Location is required' : null,
                        //       searchBoxDecoration: InputDecoration(
                        //           prefixIcon:
                        //               Icon(Icons.search, color: Theme.of(context).accentColor),
                        //           border: OutlineInputBorder(
                        //               borderRadius: new BorderRadius.circular(5.0),
                        //               borderSide: BorderSide(color: Colors.pinkAccent)),
                        //           focusedBorder: OutlineInputBorder(),
                        //           contentPadding: EdgeInsets.all(12),
                        //           labelText: S.of(context).search_location,
                        //           labelStyle: TextStyle(color: Colors.black87)),
                        //       showSearchBox: true,
                        //       mode: Mode.BOTTOM_SHEET,
                        //       dropdownSearchDecoration: InputDecoration(
                        //         hintText: S.of(context).other_location,
                        //         hintStyle: TextStyle(color: Colors.black87),
                        //         border: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.black87)),
                        //         isDense: true,
                        //         // border: OutlineInputBorder(
                        //         //     borderSide: BorderSide(color: Colors.black87)),
                        //         disabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.black87)),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.black87)),
                        //         enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.black87)),
                        //
                        //         contentPadding: EdgeInsets.all(12),
                        //         prefixIcon: Icon(Icons.location_on,
                        //             size: 25, color: Theme.of(context).accentColor),
                        //       ),
                        //       onFind: (String filter) async {
                        //         var response = await Dio().get(
                        //           BaseUrl.locations,
                        //           queryParameters: {"filter": filter},
                        //         );
                        //
                        //         var models = UserModel.fromJsonList(response.data['data']);
                        //
                        //         return models;
                        //       },
                        //       onChanged: (UserModel data) {
                        //         setState(() {
                        //           getYearId(data.id);
                        //         });
                        //         print(data.id);
                        //       },
                        //       popupTitle: Container(
                        //         height: 50,
                        //         decoration: BoxDecoration(
                        //           color: Theme.of(context).accentColor,
                        //           borderRadius: BorderRadius.only(
                        //             topLeft: Radius.circular(20),
                        //             topRight: Radius.circular(20),
                        //           ),
                        //         ),
                        //         child: Center(
                        //           child: Text(
                        //             S.of(context).other_location,
                        //             style: TextStyle(
                        //               fontSize: 24,
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       popupShape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.only(
                        //           topLeft: Radius.circular(24),
                        //           topRight: Radius.circular(24),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.040),
                        // _image1 == null
                        //     ? Container()
                        //     : Container(
                        //         height: 100,
                        //         width: 100,
                        //         child: Image.file(_image1),
                        //       ),

                        // SizedBox(height: 1.0.h),
                        // Container(
                        //   color: Colors.grey,
                        //   height: 10.0.h,
                        //   child: Row(
                        //     children: [
                        //       Container(
                        //         width: 200,
                        //         color: Colors.blue,
                        //         child: buildGridView(),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black87)),
                            child: Column(
                              children: [
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        S.of(context).voice_record,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14.0.w,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          switch (_currentStatus) {
                                            case RecordingStatus.Initialized:
                                              {
                                                _start();
                                                break;
                                              }
                                            case RecordingStatus.Recording:
                                              {
                                                _pause();
                                                break;
                                              }
                                            case RecordingStatus.Paused:
                                              {
                                                _resume();
                                                break;
                                              }
                                            case RecordingStatus.Stopped:
                                              {
                                                _init();
                                                break;
                                              }
                                            default:
                                              break;
                                          }
                                        },
                                        child: new CircleAvatar(
                                            child: _buildText(_currentStatus),
                                            backgroundColor: Theme.of(context).accentColor),
                                      ),
                                    ),
                                    _currentStatus == RecordingStatus.Stopped
                                        ? Container()
                                        : Row(
                                            children: [
                                              SizedBox(
                                                width: 5.0.w,
                                              ),
                                              CircleAvatar(
                                                backgroundColor: Theme.of(context).accentColor,
                                                child: new IconButton(
                                                    onPressed:
                                                        _currentStatus != RecordingStatus.Unset
                                                            ? _stop
                                                            : null,
                                                    // child: new Icon(Icons.stop),
                                                    icon: new Icon(Icons.stop),
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      width: 5.0.w,
                                    ),
                                    onPlayAudio == true
                                        ? Container()
                                        : _currentStatus == RecordingStatus.Stopped
                                            ? CircleAvatar(
                                                backgroundColor: Theme.of(context).accentColor,
                                                child: Center(
                                                  child: IconButton(
                                                    onPressed: () {
                                                      isPlaying ? pause() : play();
                                                    },
                                                    icon: isPlaying
                                                        ? Icon(Icons.pause)
                                                        : Icon(Icons.play_arrow),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              )

                                            //   child: new Text("Play", style: TextStyle(color: Colors.white)),

                                            : Container(),
                                  ],
                                ),

                                // new FlatButton(
                                //     onPressed: _toggle,
                                //     child: new Icon(_obscureText ? Icons.play_arrow : Icons.pause)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 3.0.w),
                                    isPlaying
                                        ? Text(
                                            position != null
                                                ? "${positionText ?? ''} / ${durationText ?? ''}"
                                                : duration != null
                                                    ? durationText
                                                    : '',
                                            style: TextStyle(fontSize: 10.0.sp),
                                          )
                                        : Container(),
                                    new Text("${_current?.duration.toString().split('.')[0]}"),
                                    SizedBox(width: 3.0.w),
                                    _currentStatus == RecordingStatus.Paused
                                        ? Text('Resume', style: TextStyle(color: Colors.green))
                                        : Container(),
                                    _currentStatus == RecordingStatus.Recording
                                        ? Text('Recording', style: TextStyle(color: Colors.red))
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.040),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.0.w),
                          child: Container(
                            height: 8.0.h,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 6.0.h,
                                      width: 65.0.w,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          TextButton(
                                              onPressed: _opencam,
                                              child: Text(
                                                S.of(context).upload_image,
                                                style: TextStyle(
                                                    color: Colors.grey, fontSize: 12.0.sp),
                                              )),
                                          SizedBox(
                                            width: 12.5.w,
                                          ),
                                          InkWell(
                                            onTap: _opencam,
                                            child: CircleAvatar(
                                                backgroundColor: Theme.of(context).accentColor,
                                                child: Icon(
                                                  Icons.camera_alt_rounded,
                                                  color: Colors.black,
                                                )),
                                          ),

                                          // Expanded(child: buildGridView1())
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                //   RecorderExample(),
                                // Container(
                                //   height: 6.0.h,
                                //   width: 65.0.w,
                                //   child:
                                // ),
                              ],
                            ),
                          ),
                        ),

                        imagearray.isEmpty
                            ? Container()
                            : SizedBox(
                                height: 10.0.h,
                                child: imagearray.isEmpty
                                    ? Container()
                                    : GridView.count(
                                        reverse: false,
                                        primary: false,
                                        shrinkWrap: true,
                                        crossAxisCount: 5,
                                        children: List.generate(imagearray.length, (index) {
                                          var img = imagearray[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(children: [
                                              Container(child: Image.file(new File(img))),
                                              Positioned(
                                                right: 5.0.sp,
                                                child: InkWell(
                                                  child: Icon(
                                                    Icons.remove_circle,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      imagearray = List.from(imagearray)
                                                        ..removeAt(index);
                                                      // images.replaceRange(index, index + 1, ['Add Image']);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ]),
                                          );
                                        }),
                                      )),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.020),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: BlockButtonWidget(
                            text: Text(
                              S.of(context).submit,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.7),
                            ),
                            color: Theme.of(context).accentColor,
                            onPressed: () {
                              uploadmultipleimage(imagearray);
                              // _currentStatus != RecordingStatus.Unset ? _stop : null;
                              // if (_formKey.currentState.validate()) {
                              //   //form is valid, proceed further
                              //   _currentStatus == RecordingStatus.Recording ? null : book();
                              //   // _formKey.currentState
                              //   //     .save(); //save once fields are valid, onSaved method invoked for every form fields
                              //
                              //   print('audiopath ' + _current?.path);
                              //
                              //   setState(() {
                              //     _autovalidate = true; //enable realtime validation
                              //   });
                              // }

                              print(selectedModelId);
                              print(selectId);

                              print(selectedvariant);

                              print(_controller.text);

                              print(groupValue);
                              //   _showMyDialog15min();
                            },
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.06)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future BookingSuccess() {
    EasyLoading.dismiss();
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Booking saved Success",
        barrierDismissible: false,
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Comming Soon!',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Launching on FEB-15 '),
                //  Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath =
            appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        // after initialization
        var current = await _recorder.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current.status;
          print(_currentStatus);
        });
      } else {
        Scaffold.of(context)
            .showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          // text = 'Start';
          return Icon(
            Icons.keyboard_voice_rounded,
            color: Colors.black,
          );
          break;
        }
      case RecordingStatus.Recording:
        {
          return Icon(
            Icons.pause,
            color: Colors.black,
          );

          // text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          return Icon(
            Icons.play_arrow,
            color: Colors.black,
          );
          //  text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          return Icon(
            Icons.delete,
            color: Colors.black,
          );
          text = 'Delete';

          break;
        }
      default:
        break;
    }
    // return Text(text, style: TextStyle(color: Colors.black));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    setState(() {
      _obscureText = !_obscureText;
      audioPlayer.pause();
    });

    await audioPlayer.play(_current.path, isLocal: true);
    //  _obscureText == true ? await audioPlayer.play(_current.path, isLocal: true) : null;
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }

  Future<void> _showMyDialogSuccess() async {
    EasyLoading.dismiss();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          decoration:
              BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Container(
              height: 25.0.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 2.0.h,
                  ),
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 40.0.sp,
                  ),
                  Text(
                    ' Booking Saved Success',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w600, fontSize: 12.0.sp),
                  ),
                  SizedBox(
                    height: 2.0.h,
                  ),
                  FlatButton(
                      color: Theme.of(context).accentColor,
                      shape:
                          new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      child: Text('Back to Home'),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PagesWidget(
                                      currentTab: 1,
                                    )));
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showMyDialogload() async {
    EasyLoading.dismiss();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12.0)),
              height: 100,
              width: 50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SpinKitThreeBounce(
                        color: Theme.of(context).accentColor,
                      ),
                      Text(
                        'Uploading',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: 'Buyer Added New quote',
      body: 'notification to seller',
      // fcmToken: fcmToken,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  Future<void> _showMyDialog15min() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 62.0.h,
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor, width: 3.0.sp)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.0.h,
                    ),
                    Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.green,
                      size: 40.0.sp,
                    ),
                    Text(
                      '... Success ...',
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40.0.h,
                        child: Column(
                          children: [
                            Container(
                              height: 18.0.h,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sit Back And Relax We Will',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.7),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Update Your Order details',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.7),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Within 15mins !!!',
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.0.sp,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.7),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 22.0.h,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        color: Theme.of(context).accentColor,
                                        size: 50.0.sp,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                  BlockButtonWidget(
                                    text: Text(
                                      "Back to Home",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.7),
                                    ),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed('/Pages', arguments: 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
        // return AlertDialog(
        //   title: Text('AlertDialog Title'),
        //   content: SingleChildScrollView(
        //     child: ListBody(
        //       children: <Widget>[
        //         Text('This is a demo alert dialog.'),
        //         Text('Would you like to approve of this message?'),
        //       ],
        //     ),
        //   ),
        //   actions: <Widget>[
        //     TextButton(
        //       child: Text('Approve'),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }

  basename(String path) {
    final file = File(path);
    return file;
  }
}

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
      'AAAA_I7wyDk:APA91bH_NUxCl12OnNDe_1d8P8vXX9Qkbs0Hmw336WAZwLPEBkGVmnA5bsDOw90q4zkPdrw3ixtblSd3AGsQmwE79UKJ3bCjPc62wYA3sDCqjvfsC2nWv-eNfa-X0pwuOPbmWygrud-a';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title, @required String body, @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '6',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
