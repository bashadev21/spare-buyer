import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../elements/CategoriesCarouselItemWidget.dart';
import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselWidget extends StatelessWidget {
  List<Category> categories;

  CategoriesCarouselWidget({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this.categories.isEmpty
        ? Center(
            child: Container(
              height: 200,
              child: SpinKitThreeBounce(
                color: Theme.of(context).accentColor,
              ),
            ),
          )
        : Container(
            height: 1500,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: this.categories.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 0 : _marginLeft = 0;
                return InkWell(
                  //  splashColor: Colors.blue,
                  //  onTap: () {},
                  //splashColor: Colors.red,
                  child: Ink(
                    child: new CategoriesCarouselItemWidget(
                      marginLeft: _marginLeft,
                      category: this.categories.elementAt(index),
                    ),
                  ),
                );
              },
            ));
  }
}
