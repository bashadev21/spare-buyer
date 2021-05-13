import 'package:flutter/material.dart';
import 'package:spare_do/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../elements/DrawerWidget.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;

  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Change Password',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(
              letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        // actions: <Widget>[
        //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor),
        // ],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: ListView(
            children: [
              SizedBox(
                height: 30,
              ),
              TextFormField(
                // obscureText: _con.hidePassword,
                //  onSaved: (input) => _con.user.password = input,
                validator: (input) => input.length < 6
                    ? S.of(context).should_be_more_than_6_letters
                    : null,
                decoration: InputDecoration(
                  labelText: 'Old Password',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  contentPadding: EdgeInsets.all(12),
                  hintText: '••••••••••••',
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Theme.of(context).accentColor),
                  // suffixIcon: IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _con.hidePassword = !_con.hidePassword;
                  //     });
                  //   },
                  //   color: Theme.of(context).focusColor,
                  //   icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                  // ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                // obscureText: _con.hidePassword,
                //  onSaved: (input) => _con.user.password = input,
                validator: (input) => input.length < 6
                    ? S.of(context).should_be_more_than_6_letters
                    : null,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  contentPadding: EdgeInsets.all(12),
                  hintText: '••••••••••••',
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Theme.of(context).accentColor),
                  // suffixIcon: IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _con.hidePassword = !_con.hidePassword;
                  //     });
                  //   },
                  //   color: Theme.of(context).focusColor,
                  //   icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                  // ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                // obscureText: _con.hidePassword,
                //  onSaved: (input) => _con.user.password = input,
                validator: (input) => input.length < 6
                    ? S.of(context).should_be_more_than_6_letters
                    : null,
                decoration: InputDecoration(
                  labelText: 'Re - Enter',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  contentPadding: EdgeInsets.all(12),
                  hintText: '••••••••••••',
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Theme.of(context).accentColor),
                  // suffixIcon: IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _con.hidePassword = !_con.hidePassword;
                  //     });
                  //   },
                  //   color: Theme.of(context).focusColor,
                  //   icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                  // ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                ),
              ),
              SizedBox(height: 20),
              BlockButtonWidget(
                text: Text(
                  'Change Password',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

//       body: currentUser.value.apiToken == null
//           ? PermissionDeniedWidget()
//           : SingleChildScrollView(
// //              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
//               child: Column(
//                 children: <Widget>[
//                   ProfileAvatarWidget(user: currentUser.value),
//                   ListTile(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     leading: Icon(
//                       Icons.person,
//                       color: Theme.of(context).hintColor,
//                     ),
//                     title: Text(
//                       S.of(context).about,
//                       style: Theme.of(context).textTheme.headline4,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       currentUser.value?.bio ?? "",
//                       style: Theme.of(context).textTheme.bodyText2,
//                     ),
//                   ),
//                   ListTile(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                     leading: Icon(
//                       Icons.shopping_basket,
//                       color: Theme.of(context).hintColor,
//                     ),
//                     title: Text(
//                       S.of(context).recent_orders,
//                       style: Theme.of(context).textTheme.headline4,
//                     ),
//                   ),
//                   _con.recentOrders.isEmpty
//                       ? EmptyOrdersWidget()
//                       : ListView.separated(
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           primary: false,
//                           itemCount: _con.recentOrders.length,
//                           itemBuilder: (context, index) {
//                             var _order = _con.recentOrders.elementAt(index);
//                             return OrderItemWidget(expanded: index == 0 ? true : false, order: _order);
//                           },
//                           separatorBuilder: (context, index) {
//                             return SizedBox(height: 20);
//                           },
//                         ),
//                 ],
//               ),
//             ),
    );
  }
}
