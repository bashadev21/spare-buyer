import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  // BaseAppBar({Key key, this.parentScaffoldKey}) : super(key: key);
  final Color backgroundColor = Colors.red;
  final Text title;
  final AppBar appBar;
  // final List<Widget> leading;
  // final IconButton widgets;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// you can add more fields that meet your needs

  BaseAppBar({
    Key key,
    this.title,
    this.appBar,
    // this.widgets,
    // this.leading,
    this.parentScaffoldKey,
  }) : super(key: key);
  void handleClick(String value) {
    switch (value) {
      case 'English':
        break;
      case 'தமிழ்':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        'assets/img/2.png',
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.4,
      ),
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),

      // leading: InkWell(
      //   onTap: () {
      //     onPressed:
      //     () => _scaffoldKey.currentState.openDrawer();
      //   },
      //   child: new Icon(
      //     Icons.menu,
      //     color: Colors.green,
      //   ),
      // ),
      // leading: new IconButton(
      //   icon: new Icon(Icons.settings),
      //   onPressed: () => _scaffoldKey.currentState.openDrawer(),
      // ),
      // actions: <Widget>[
      //   PopupMenuButton<String>(
      //     icon: Padding(
      //       padding: const EdgeInsets.all(0.0),
      //       child: Image.asset('assets/img/ENG.png'),
      //     ),
      //     onSelected: handleClick,
      //     itemBuilder: (BuildContext context) {
      //       return {'English', 'தமிழ்'}.map((String choice) {
      //         return PopupMenuItem<String>(
      //           value: choice,
      //           child: Text(choice),
      //         );
      //       }).toList();
      //     },
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
