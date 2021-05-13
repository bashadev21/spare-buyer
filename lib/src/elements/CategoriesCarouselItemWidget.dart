import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:spare_do/src/pages/brandListScreen.dart';

import '../../base_url.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatefulWidget {
  double marginLeft;
  Category category;

  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category}) : super(key: key);

  @override
  _CategoriesCarouselItemWidgetState createState() => _CategoriesCarouselItemWidgetState();
}

class _CategoriesCarouselItemWidgetState extends State<CategoriesCarouselItemWidget> {
  List categoryList = List();

  final LocalStorage storage = new LocalStorage("");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      // onTap: () {
      //   print('you clicked ${widget.category.id}');
      //
      //   // Navigator.of(context).pushNamed('/CarScreen');
      // },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: widget.category.id,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(start: this.widget.marginLeft, end: 0),
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: MediaQuery.of(context).size.height * 0.32,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(15),
                  //   child: widget.category.avatar.toLowerCase().endsWith('.svg')
                  //       ? SvgPicture.network(
                  //           widget.category.avatar,
                  //           color: Theme.of(context).accentColor,
                  //         )
                  //       // : CachedNetworkImage(
                  //       //     fit: BoxFit.cover,
                  //       //     imageUrl: category.image.icon,
                  //       //     placeholder: (context, url) => Image.asset(
                  //       //       'assets/img/loading.gif',
                  //       //       fit: BoxFit.cover,
                  //       //     ),
                  //       //     errorWidget: (context, url, error) => Icon(Icons.error),
                  //       //   ),
                  //   :
                  //
                  //
                  //   Center(child:  Image.network('http://192.168.1.147:8080/spare_do/public/assets/category/${widget.category.avatar}'))
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Material(
                          child: InkWell(
                            splashColor: Colors.red,
                            // splashColor: The,
                            //highlightColor: Colors.transparent,
                            onTap: () {
                              storage.setItem('category_id', widget.category.id.toString());
                              storage.setItem('category_name', widget.category.name);
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      duration: Duration(milliseconds: 600),
                                      type: PageTransitionType.rightToLeftWithFade,
                                      child: BrandList()));
                            },
                            child: InkWell(
                              onTap: () {
                                storage.setItem('category_id', widget.category.id.toString());
                                storage.setItem('category_name', widget.category.name);
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        duration: Duration(milliseconds: 600),
                                        type: PageTransitionType.rightToLeftWithFade,
                                        child: BrandList()));
                                print("tapped");
                              },
                              // splashColor: Colors.blue,
                              child: InkWell(
                                onTap: () {
                                  storage.setItem('category_id', widget.category.id.toString());
                                  storage.setItem('category_name', widget.category.name);
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 600),
                                          type: PageTransitionType.rightToLeftWithFade,
                                          child: BrandList()));
                                  print("tapped");
                                },
                                child: BouncingWidget(
                                  duration: Duration(milliseconds: 100),
                                  scaleFactor: 1.5,
                                  onPressed: () {
                                    storage.setItem('category_id', widget.category.id.toString());
                                    storage.setItem('category_name', widget.category.name);
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            duration: Duration(milliseconds: 600),
                                            type: PageTransitionType.rightToLeftWithFade,
                                            child: BrandList()));
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.28,
                                    width: MediaQuery.of(context).size.width * 0.80,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.1, 0.6],
                                          colors: [
                                            Theme.of(context).accentColor,
                                            Theme.of(context).accentColor,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Theme.of(context).focusColor.withOpacity(0.3),
                                              offset: Offset(0, 2),
                                              blurRadius: 7.0)
                                        ]),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context).size.width * 0.12,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.55,
                                            ),
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 3.0.h,
                                                ),
                                                Text(
                                                  widget.category.name.toUpperCase(),
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: 25.0.sp,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Positioned(
                //   top: 0,
                //   left: MediaQuery.of(context).size.width * 0.18,
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.30,
                //     width: MediaQuery.of(context).size.width * 0.30,
                //     child: Column(
                //       children: [
                //         SizedBox(
                //           height: MediaQuery.of(context).size.height * 0.045,
                //         ),
                //         Container(
                //           height: MediaQuery.of(context).size.width * 0.27,
                //           width: MediaQuery.of(context).size.width * 0.3,
                //           decoration: BoxDecoration(
                //             gradient: LinearGradient(
                //               begin: Alignment.topLeft,
                //               end: Alignment.bottomRight,
                //               stops: [0.1, 0.6],
                //               colors: [
                //                 Color.fromRGBO(44, 159, 210, 0.3),
                //                 Color.fromRGBO(66, 200, 234, 0.1),
                //               ],
                //             ),
                //             borderRadius: BorderRadius.circular(100),
                //           ),
                //           // child: Padding(
                //           //   padding: const EdgeInsets.only(
                //           //       left: 20, right: 2, top: 20, bottom: 20),
                //           // 'https://sparesdo.com/public/assets/category/${widget.category.avatar}',
                //           child: CachedNetworkImage(
                //             imageUrl: '${BaseUrl.category}${widget.category.avatar}',
                //             color: Colors.white.withOpacity(0.7),
                //             height: MediaQuery.of(context).size.height * 0.1,
                //             width: MediaQuery.of(context).size.height * 0.1,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Positioned(
                //     top: 7.0.h,
                //     left: 14.0.w,
                //     child: CircleAvatar(
                //       radius: 43.0.sp,
                //       backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
                //     )),
                Positioned(
                  top: 0.0.h,
                  left: 12.0.w,
                  child: InkWell(
                    onTap: () {
                      storage.setItem('category_id', widget.category.id.toString());
                      storage.setItem('category_name', widget.category.name);
                      Navigator.push(
                          context,
                          PageTransition(
                              duration: Duration(milliseconds: 600),
                              type: PageTransitionType.rightToLeftWithFade,
                              child: BrandList()));
                      print("tapped");
                    },
                    splashColor: Colors.transparent,
                    child: BouncingWidget(
                      duration: Duration(milliseconds: 100),
                      scaleFactor: 1.5,
                      onPressed: () {
                        storage.setItem('category_id', widget.category.id.toString());
                        storage.setItem('category_name', widget.category.name);
                        Navigator.push(
                            context,
                            PageTransition(
                                duration: Duration(milliseconds: 600),
                                type: PageTransitionType.rightToLeftWithFade,
                                child: BrandList()));
                      },
                      child: Container(
                        height: 30.0.h,
                        width: 45.0.w,
                        child: CachedNetworkImage(
                          imageUrl: '${BaseUrl.category}${widget.category.avatar}',
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Container(
          //   margin: EdgeInsetsDirectional.only(start: this.widget.marginLeft, end: 20),
          //   child: Text(
          //     widget.category.id,
          //     overflow: TextOverflow.ellipsis,
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
        ],
      ),
    );
  }
}
