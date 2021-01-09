import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

// Make updated copyright text
DateTime nowDate = new DateTime.now();
DateTime nowYear = new DateTime(nowDate.year);
String nowYearStr = nowYear.toString();
String justYearStr = nowYearStr.substring(0, 4);
final String copyright = 'Copyright © ' + justYearStr + ' dpora';

class _DporaAppState extends State<DporaApp> {
  // default app-wide colors
  Color boxBGColor = Colors.grey[900];
  Color iconColor = Colors.grey[700];
  Color menuColor = Colors.blueGrey;

  // this is updated when user hits Return or Enter on their keyboard
  String submittedText = '';

  // updatable content from DB
  String menuMessage = 'Have private yet meaningful\nchats with total strangers\n\n';
  String stimText =
      'Mind on your money. Money on your mind. Sippin on gin and juice. West Side, yall!';
  Color userColor = Colors.greenAccent; // userText updated in userOutput below
  String tileTextLT = 'left top text here';
  Color textColorLT = Colors.orangeAccent;
  String tileTextLB = 'left bottom text here';
  Color textColorLB = Colors.blueAccent;
  String tileTextRT =
      'this text is about 25 words or something maybe longer. this text is about 25 words or maybe shorter. this text is about 25 words or so.';
  Color textColorRT = Colors.purpleAccent;
  String tileTextRB = 'right bottom text here and not there';
  Color textColorRB = Colors.redAccent;

  // for fading text
  double userOpacity = 1.0;
  double chatOpacity = 1.0;
  int userFadeTime = 10;
  int chatFadeTime = 10;

  // using this key to open and close drawer
  // programically (in addition to swiping)
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // using this to handle inputted text in the textfield
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ϕ dpora', // or use Φ
      theme: ThemeData.dark(),
      home: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.black,
        // appBar would go here
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Φ dpora\n \n',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: menuMessage,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          )),
                      TextSpan(
                          text: copyright,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: menuColor,
                ),
              ),
              ListTile(
                title: Text(
                  'About',
                  // style: TextStyle(),
                ),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  //close the drawer
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
              ListTile(
                title: Text('Privacy'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  //close the drawer
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
              ListTile(
                title: Text('Stats'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  //close the drawer
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
              ListTile(
                title: Text('Contact'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  //close the drawer
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
            ],
          ),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildVerticalLayout(
                    tileTextLT,
                    textColorLT,
                    tileTextLB,
                    textColorLB,
                    tileTextRT,
                    textColorRT,
                    tileTextRB,
                    textColorRB,
                  )
                : _buildHorizontalLayout(
                    tileTextLT,
                    textColorLT,
                    tileTextLB,
                    textColorLB,
                    tileTextRT,
                    textColorRT,
                    tileTextRB,
                    textColorRB,
                  );
          },
        ),
      ),
    );
  }

  Widget _stimulus(textSize) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: boxBGColor,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: iconColor,
                  ),
                  padding: EdgeInsets.zero, // need for alignment
                  tooltip: 'Φ Menu', // or use
                  onPressed: () =>
                      _drawerKey.currentState.openDrawer(), // open drawer
                ),
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.share_rounded,
                    color: iconColor,
                  ),
                  padding: EdgeInsets.zero, // need for alignment
                  tooltip: 'Share Topic',
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.threesixty_rounded,
                    color: iconColor,
                  ),
                  padding: EdgeInsets.zero, // need for alignment
                  tooltip: 'New Group & Topic',
                  onPressed: () {}, // maybe just restart app?
                ),
              ),
              Column(children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel_presentation_rounded,
                      color: iconColor,
                    ),
                    padding: EdgeInsets.zero, // need for alignment
                    tooltip: 'Same Group, New Topic',
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: 4, // create some space between
                ),
                Text(
                  '0', // no need for counter here, rather update from DB
                  style: TextStyle(
                    fontSize: 12,
                    color: iconColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
            ]),
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            child: Text(
              stimText,
              style: TextStyle(
                fontSize: textSize,
                color: Colors.yellow, //yellowAccent is too bright
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _userInput() {
    return TextField(
        controller: inputController,
        style: TextStyle(color: userColor),
        cursorColor: userColor,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: userColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: userColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: userColor),
          ),
          fillColor: boxBGColor,
          filled: true,
          labelText:
              'Select this box to type, then hit enter on your keyboard.',
          labelStyle: TextStyle(color: userColor),
          hintText: 'Responses disappear after 30 seconds. Be brief!',
          hintStyle: TextStyle(color: iconColor),
          // cancel text button
          suffixIcon: IconButton(
          onPressed: () => inputController.clear(),
          icon: Icon(Icons.clear, size: 10,),
          ),
        ),
        maxLength: 255,
        // this is way more than needed but allows for ascii art or venting
        autofocus: false,
        onEditingComplete: () {
          setState(() {
            userFadeTime = 0;
            userOpacity = 1.0;
            submittedText = inputController.text;
          });
          inputController.clear(); // clear text in input box
          Timer(Duration(seconds: 20), () {
            // after 20 seconds...
            setState(() {
              userFadeTime = 10; // fade duration
              userOpacity = 0.0;
            });
          });
        });
  }

  Widget _userOutput(textSize) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: userColor),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: boxBGColor,
      ),
      child: AnimatedOpacity(
        duration: Duration(seconds: userFadeTime), // fade duration
        opacity: userOpacity,
        child: Text(
          submittedText,
          style: TextStyle(fontSize: textSize, color: userColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // truncates, not scrollable
        ),
      ),
    );
  }

  Widget _chatTile(tileHeight, tileWidth, textSize, tileText, textColor) {
    // fades out tileText
    Timer(Duration(seconds: 20), () {
      setState(() {
        // just in case user just muted someone
        if (chatFadeTime == 1) {
          chatFadeTime = 10;
        }
        chatOpacity = 0.0;
      });
    });

    return Container(
      height: MediaQuery.of(context).size.height * tileHeight,
      width: MediaQuery.of(context).size.width * tileWidth,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: boxBGColor,
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
          child: SingleChildScrollView(
            child: AnimatedOpacity(
              duration: Duration(seconds: chatFadeTime), // fade duration
              opacity: chatOpacity,
              child: Text(
                tileText,
                style: TextStyle(fontSize: textSize, color: textColor),
              ),
            ),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  'USA',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: iconColor,
                  ),
                  overflow: TextOverflow.ellipsis, // truncates, not scrollable
                ),
              ),
              Row(
                children: [
                  //
                  Text(
                    '0', // no need for counter here, rather update from DB
                    //
                    style: TextStyle(
                      fontSize: 12,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      icon: Icon(
                        Icons.person_remove_outlined,
                        color: iconColor,
                      ),
                      padding: EdgeInsets.zero, // need for alignment
                      tooltip: 'Mute Person',
                      onPressed: () {
                        setState(() {
                          chatFadeTime = 1; // set to quick fade
                          chatOpacity = 0.0;
                          // reset fade duration
                        });
                        Timer(Duration(seconds: 1), () {
                          setState(() {
                            chatFadeTime = 10;
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ]),
      ]),
    );
  }

  Widget _buildVerticalLayout(
    tileTextLT,
    textColorLT,
    tileTextLB,
    textColorLB,
    tileTextRT,
    textColorRT,
    tileTextRB,
    textColorRB,
  ) {
    final allTileHeight = 0.2; // 20% screen height
    final allTileWidth = 0.45; // 45% screen width
    final allTextSize = 18; // 18 font size
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.23, //23%
          width: MediaQuery.of(context).size.width, //100%
          child: _stimulus(24),
        ),
        // build the chat titles, the left column (top & bottom) and right
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                _chatTile(
                  allTileHeight,
                  allTileWidth,
                  allTextSize,
                  tileTextLT,
                  textColorLT,
                ),
                _chatTile(
                  allTileHeight,
                  allTileWidth,
                  allTextSize,
                  tileTextLB,
                  textColorLB,
                ),
              ],
            ),
            Column(
              children: [
                _chatTile(
                  allTileHeight,
                  allTileWidth,
                  allTextSize,
                  tileTextRT,
                  textColorRT,
                ),
                _chatTile(
                  allTileHeight,
                  allTileWidth,
                  allTextSize,
                  tileTextRB,
                  textColorRB,
                ),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: _userOutput(18), // font size 18
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: _userInput(),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(
    tileTextLT,
    textColorLT,
    tileTextLB,
    textColorLB,
    tileTextRT,
    textColorRT,
    tileTextRB,
    textColorRB,
  ) {
    final allTileHeight = 0.33; // 33% screen height
    final allTileWidth = 0.21; // 21% screen width
    final allTextSize = 26; // 26 font size
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.355, //35.5%
                width: MediaQuery.of(context).size.width / 2,
                child: _stimulus(32),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.355,
                width: MediaQuery.of(context).size.width / 2,
                child: _userOutput(26), // font size 26
              ),
            ],
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _chatTile(
                        allTileHeight,
                        allTileWidth,
                        allTextSize,
                        tileTextLT,
                        textColorLT,
                      ),
                      _chatTile(
                        allTileHeight,
                        allTileWidth,
                        allTextSize,
                        tileTextLB,
                        textColorLB,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _chatTile(
                        allTileHeight,
                        allTileWidth,
                        allTextSize,
                        tileTextRT,
                        textColorRT,
                      ),
                      _chatTile(
                        allTileHeight,
                        allTileWidth,
                        allTextSize,
                        tileTextRB,
                        textColorRB,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
      Container(
        width: MediaQuery.of(context).size.width * 0.95, //95%
        padding: EdgeInsets.all(10),
        child: _userInput(),
      ),
    ]);
  }
}
