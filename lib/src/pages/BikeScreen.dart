import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:spare_do/src/elements/BlockButtonWidget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
class BikeScreen extends StatefulWidget {
  @override
  _BikeScreenState createState() => _BikeScreenState();
}
String brand ,model,variant,year;
int _groupValue = -1;
String selected;
String select;

class _BikeScreenState extends State<BikeScreen> {
  List<Asset> images = List<Asset>();
  @override
  void initState() {
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
        maxImages: 7,
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
   //   _error = error;
    });
  }

  File _image1;
  final picker = ImagePicker();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   // leading: new IconButton(
        //   //   icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
        //   //   onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        //   // ),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.transparent,
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
        //   title:Text('Spare Do Seller',style:Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing:1.3))),
        //
        //   // actions: <Widget>[
        //   //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        //   // ],
        // ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Spare Do Buyer',
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body:SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 25),
            child: ListView(
              children: [
                Center(child: Text('Bike',style: Theme.of(context).textTheme.headline3.merge(TextStyle(letterSpacing: 1.3)),)),
                // DecoratedBox(
                // decoration: ShapeDecoration(
                //   color: Colors.transparent,
                //   shape: RoundedRectangleBorder(
                //     side: BorderSide(width: 2.0, style: BorderStyle.solid,  color: Theme.of(context).accentColor,),
                //     borderRadius: BorderRadius.all(Radius.circular(100.0)),
                //   ),
                // ),

                //    DecoratedBox(
                //       decoration: ShapeDecoration(
                // color: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //           side: BorderSide(width: 2.0, style: BorderStyle.solid,  color: Theme.of(context).accentColor,),
                //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //         ),
                //       ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'select Brand'
                    ),

                    isExpanded: true,
                    value: brand,
                 //   icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87,),
                    // underline: Container(
                    //   height: 2,
                    // color:  Theme.of(context).accentColor,
                    // ),
                    onChanged: (String newValue) {
                      setState(() {
                        brand = newValue;
                      });
                    },
                    items: <String>['BMW', 'Jaguar', 'Bentley', 'Acura']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'select Model'
                    ),

                    isExpanded: true,
                    value: model,
                //    icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87,),
                    // underline: Container(
                    //   height: 2,
                    // color:  Theme.of(context).accentColor,
                    // ),
                    onChanged: (String newValue) {
                      setState(() {
                        model = newValue;
                      });
                    },
                    items: <String>['Ford', 'Hyundai', 'Three', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'select Variant'
                    ),

                    isExpanded: true,
                    value: variant,
              //      icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87,),
                    // underline: Container(
                    //   height: 2,
                    // color:  Theme.of(context).accentColor,
                    // ),
                    onChanged: (String newValue) {
                      setState(() {
                        variant = newValue;
                      });
                    },
                    items: <String>['210', '100', '300', '120']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        labelText: 'select Year'
                    ),

                    isExpanded: true,
                    value: year,
                //    icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black87,),
                    // underline: Container(
                    //   height: 2,
                    // color:  Theme.of(context).accentColor,
                    // ),
                    onChanged: (String newValue) {
                      setState(() {
                        year = newValue;
                      });
                    },
                    items: <String>['2000', '2001', '2003', '2004']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                // ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     DecoratedBox(
                //       decoration: ShapeDecoration(
                //         color: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //           side: BorderSide(width: 2.0, style: BorderStyle.solid,  color: Theme.of(context).accentColor,),
                //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //         ),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                //         child: DropdownButton<String>(
                //           isExpanded: true,
                //           value: dropdownValue,
                //           icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                //           iconSize: 24,
                //           elevation: 16,
                //           style: TextStyle(color: Colors.black87,),
                //           underline: Container(
                //             height: 2,
                //             //  color: Colors.deepPurpleAccent,
                //           ),
                //           onChanged: (String newValue) {
                //             setState(() {
                //               dropdownValue = newValue;
                //             });
                //           },
                //           items: <String>['One', 'Two', 'Free', 'Four']
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     DecoratedBox(
                //       decoration: ShapeDecoration(
                //         color: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //           side: BorderSide(width: 2.0, style: BorderStyle.solid,  color: Theme.of(context).accentColor,),
                //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //         ),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                //         child: DropdownButton<String>(
                //           isExpanded: true,
                //           value: dropdownValue,
                //           icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                //           iconSize: 24,
                //           elevation: 16,
                //           style: TextStyle(color: Colors.black87,),
                //           underline: Container(
                //             height: 2,
                //             //  color: Colors.deepPurpleAccent,
                //           ),
                //           onChanged: (String newValue) {
                //             setState(() {
                //               dropdownValue = newValue;
                //             });
                //           },
                //           items: <String>['One', 'Two', 'Free', 'Four']
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                //     SizedBox(
                //       height: 20,
                //     ),
                //     DecoratedBox(
                //       decoration: ShapeDecoration(
                //         color: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //           side: BorderSide(width: 2.0, style: BorderStyle.solid,  color: Theme.of(context).accentColor,),
                //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
                //         ),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(vertical:0.0,horizontal: 25),
                //         child: DropdownButton<String>(
                //           isExpanded: true,
                //           value: dropdownValue,
                //           icon: Icon(Icons.arrow_downward,color: Theme.of(context).accentColor,),
                //           iconSize: 24,
                //           elevation: 16,
                //           style: TextStyle(color: Colors.black87,),
                //           underline: Container(
                //             height: 2,
                //             //  color: Colors.deepPurpleAccent,
                //           ),
                //           onChanged: (String newValue) {
                //             setState(() {
                //               dropdownValue = newValue;
                //             });
                //           },
                //           items: <String>['One', 'Two', 'Free', 'Four']
                //               .map<DropdownMenuItem<String>>((String value) {
                //             return DropdownMenuItem<String>(
                //               value: value,
                //               child: Text(value),
                //             );
                //           }).toList(),
                //         ),
                //       ),
                //     ),
                SizedBox(
                  height: 15,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Text('Select Fuel Type'),
                //     ],
                //   ),
                // ),

                // Row(
                //   children: <Widget>[
                //     Expanded(
                //       flex: 1,
                //       child: RadioListTile(
                //         value: 0,
                //         groupValue: _groupValue,
                //         title: Text("Petrol"),
                //         onChanged: (newValue) =>
                //             setState(() => _groupValue = newValue),
                //         activeColor: Colors.red,
                //         selected: false,
                //       ),
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: RadioListTile(
                //         value: 1,
                //         groupValue: _groupValue,
                //         title: Text("Diesel"),
                //         onChanged: (newValue) =>
                //             setState(() => _groupValue = newValue),
                //         activeColor: Colors.red,
                //         selected: false,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                // Row(
                //   children: [
                    // Expanded(
                    //   flex: 1,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(6),
                    //         border: Border.all(color:Theme.of(context).accentColor)
                    //     ),
                    //     child: Center(
                    //       child:_image1 == null
                    //           ? Text('No image ')
                    //           : Image.file(_image1),
                    //     ),
                    //     height: 100,
                    //     width: 100,
                    //
                    //   ),
                    // ),



                            OutlineButton.icon(

                                onPressed: loadAssets, icon:Icon( Icons.camera_alt_rounded),   label:images==null? Text(' Upload Image'):Text('Upload Image')),
                            SizedBox(height: 2,),
                            Container(
                              height: 30,
                              child: Expanded(child: buildGridView()),
                            ),
                            OutlineButton.icon(onPressed: (){}, icon:Icon( Icons.audiotrack), label: Text('Record Audio')),




                //   ],
                // ),
                SizedBox(
                  height: 30,
                ),
                BlockButtonWidget(
                  text: Text(
                    '                   Submit                  ',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {


                  },
                ),

              ],
            ),
          ),
        )
    );
  }
}
