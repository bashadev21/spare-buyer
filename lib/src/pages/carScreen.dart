import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:spare_do/src/helpers/helper.dart';
import 'package:spare_do/src/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spare_do/src/models/route_argument.dart';
import 'package:spare_do/src/pages/class_sub.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:spare_do/src/elements/BlockButtonWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';



class CarScreen extends StatefulWidget {
  final RouteArgument routeArgument;
// final Map country = ModalRoute.of(context).settings.arguments;

  double marginLeft;
  Category category;

  CarScreen( {Key key, this.marginLeft, this.category, this.routeArgument,}) : super(key: key);
 // CarScreen({Key key, this.routeArgument,this.marginLeft, this.category,this.id }) : super(key: key);

  
  @override
  _CarScreenState createState() => _CarScreenState();
}
String brand ,model,variant,year;
int groupValue=-1,seleCtedFuelId;
String selected;
String select;
String selectId,branId;
String selectedModelId,UserId;
String categoryName,selectedvariant,fuel,SelectedYearId,selectedBrandId;


var category;


class _CarScreenState extends State<CarScreen> {
  File _image1;
  final picker = ImagePicker();
  List brandsList=List();
  List modelList=List();
  List variantList=List();
  List yearList=List();
  List fuelList=List();
  List dummy=List();
  final TextEditingController _controller = TextEditingController();


  final LocalStorage storage = new LocalStorage("");
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getModels()async{
    var brnad=storage.getItem('brand_id');
    var selected_category=storage.getItem('category_id');
    selectedBrandId=brand;
    print(selected_category);
    print(brnad);
    print(brnad);
    print(brnad);
    print(brnad);



    var response=await http.get('http://192.168.1.147:8080/spare_do/public/api/models?'+'category_id='+selected_category.toString()+'&'+'brand_id='+brnad.toString());
    var jsonBody=response.body;
    var data=json.decode(jsonBody);
    setState(() {
      data=data;
    });

    this.modelList=data['data'];
    print('listtttt');
    print(this.modelList);
  }

  Future getVariant(modelId)async
  {
    var selected_category=storage.getItem('category_id');
selectedModelId=modelId;
    var response=await http.get('http://192.168.1.147:8080/spare_do/public/api/variants?'+'category_id='+selected_category+'&'+'brand_id='+selectId+'&'+'model_id='+modelId);
    var jsonBody=response.body;
    var data=json.decode(jsonBody);
    setState(() {
      data=data;
      print(data);
    });

    this.variantList=data['data'];
    //print(this.brandsList);

  }

  Future getYear(variantId)async
  {
    var selected_category=storage.getItem('category_id');
selectedvariant=variantId;
    var response=await http.get('http://192.168.1.147:8080/spare_do/public/api/year?'+'category_id='+selected_category+'&'+'brand_id='+selectId+'&'+'model_id='+selectedModelId+'&'+'variant_id='+variantId);
    var jsonBody=response.body;
    var data=json.decode(jsonBody);
    setState(() {
      data=data;
      print(data);
    });

    this.yearList=data['data'];
    print(this.yearList);

  }


  Future getFuel()async{



    var response=await http.get('http://192.168.1.147:8080/spare_do/public/api/models?brand_id=1&category_id=1');
    var jsonBody=response.body;
    var data=json.decode(jsonBody);
    setState(() {
      data=data;
    });

    this.fuelList=data['data'];
    print(this.fuelList);
  }

  Future book()async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('current_user');
    setState((){
      var current_user=(prefs.getString('current_user') ?? '');
      UserId=currentUser.value.id;
      print(UserId);
    });


    var selected_category=storage.getItem('category_id');
  final   uri = Uri.parse('http://192.168.1.147:8080/spare_do/public/api/book');
var request=http.MultipartRequest('POST',uri);
    request.fields['category']=selected_category;
    request.fields['brand']=selectId;
    request.fields['model']=selectedModelId;
    request.fields['variant']=selectedvariant;
    request.fields['year']=SelectedYearId;
    request.fields['buyer']=UserId;
    request.fields['description']=_controller.text;
    request.fields['fuel']=groupValue.toString();
    var pic=await http.MultipartFile.fromPath('images', _image1.path);
    request.files.add(pic);
    var response=await request.send();

   // var response=await http.post('http://192.168.1.147:8080/spare_do/public/api/book?'+'category='+selected_category+'&'+'brand='+selectId+'&'+'model='+selectedModelId+'&'+'variant='+selectedvariant+'&'+'year='+SelectedYearId+'&'+'buyer='+UserId+'&'+'description='+_controller.text+'&'+'fuel='+groupValue.toString()+'&'+'images='+_image1);

setState(() {

  print(response);

});
    if (response.statusCode == 200) {
      return Navigator.of(context).pushNamed('/Pages');


    } else {
      return  LinearProgressIndicator();
    }
  }



  List<Asset> images = List<Asset>();

  @override
  void initState() {

    getModels();



    super.initState();






  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 10,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 200,
          height: 200,
        );
      }),
    );

  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
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


    if (!mounted) return;

    setState(() {
      images = resultList;
      //   _error = error;
    });
  }
  final _formKey = GlobalKey<FormState>();

void _clearvalue(){

    _formKey.currentState.reset();
    // @override
    // void dispose() {
    //  this.brandsList=[];
    //   super.dispose();
    // }


  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    getFuel();





    return Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(onPressed:_clearvalue,
          icon: Icon(Icons.arrow_back),),
          title: Text(
'Spare Do Buyer',
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),

      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 25),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Center(child: Text(categoryName,style: Theme.of(context).textTheme.headline3.merge(TextStyle(letterSpacing: 1.3)),)),





                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField(
                    value: model,
                    hint: Text('Select Model'),
                    items: modelList.map((list2){
                      return DropdownMenuItem(child: Text(list2['name'].toString()),
                        value: list2['id'].toString(),
                      );
                    })?.toList(),
                    onChanged: (value3){
                      setState(() {



                       getVariant(value3);

                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField(
                    value:  variant,
                    hint: Text('Select Variant'),
                    items: variantList.map((list3){
                      return DropdownMenuItem(child: Text(list3['name']),
                        value: list3['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value3){
                      setState(() {

                   //     variant=value3;

                       getYear(value3);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField(
                    value:  year,
                    hint: Text('Select Year'),
                    items: yearList.map((list4){
                      return DropdownMenuItem(child: Text(list4['name']),
                        value: list4['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value3){
                      setState(() {
                        getYearId(value3);


                   //     year=value3;



                      });
                    },
                  ),
                ),
                SizedBox(height:10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: Theme(
                    data: new ThemeData(
                        primaryColor: Theme.of(context).accentColor,

                    ),
                    child: new TextFormField(


                      controller: _controller,
maxLines: 3,
                      decoration: new InputDecoration(


                          labelText: "Description",
                          labelStyle: new TextStyle(
                              color:Theme.of(context).accentColor,
                          ),

                      ),

                    ),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text('Select Fuel Type'),
                    ],
                  ),
                ),
                SizedBox(
                  height:110,

                  child: ListView.builder(
                    // scrollDirection: Axis.horizontal,
                      itemCount: fuelList.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RadioListTile(

                            value: fuelList[index]['id'],
                            groupValue: groupValue,
                            title: Text(fuelList[index]['name']),
                            onChanged: (newValue) {
                              setState(() {
                                    groupValue=newValue;
                            //   getFuelId( newValue);
                                print(newValue);
                              });



                            },
                            activeColor:  Theme.of(context).accentColor,
                            selected: false,
                          ),
                        );
                      }),

                ),



                SizedBox(
                  height: 10,
                ),
                OutlineButton.icon(

                    onPressed: getImage, icon:Icon( Icons.camera_alt_rounded),   label:_image1==null? Text(' Upload Image'):Text('Selecetd Image')),
                SizedBox(height: 2,),
                Container(
                  height: 30,
                  child: Expanded(child: buildGridView()),
                ),
                OutlineButton.icon(onPressed: (){}, icon:Icon( Icons.audiotrack), label: Text('Record Audio')),
                SizedBox(
                  height: 20,
                ),
                BlockButtonWidget(

                  text: Text(
                    '                   Submit                  ',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {

                    print(selectedModelId);
                    print(selectId);
                    print(selectedvariant);
                    print(images);
                    print(_controller.text);

book();
print(groupValue);



                  },
                ),

              ],
            ),
          ),
        ),
      )
    );
  }

  void getYearId(yearId) {
  SelectedYearId=yearId;
  print('yeeeeeeeeeeeeeeeeeeeeee'+yearId);

  }

  void getFuelId(FuelId) {
  seleCtedFuelId=FuelId;
  print('fuellllllllllllll'+FuelId);
  }
}
