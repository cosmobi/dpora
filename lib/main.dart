import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:async';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:math';
// Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';

// Initialize FlutterFire and also wrap the
// DporaApp widget within a MaterialApp widget
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: DporaApp()));
}

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

// If both mobile data or wifi is turned off then tell
// the user (as a stimulus) to turn on one or both.
bool airplaneMode = false;
void checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    airplaneMode = true;
  }
}

// Will be used to hold platform identification
String platform;

// Creating link to main website
_dporaWebsite() async {
  const url = 'https://dpora.com';
  if (await canLaunch(url)) {
    await launch(
      url,
      forceWebView:
          true, // To open url in-app on android. iOS is in-app by default.
      // enableJavaScript: true, // uncomment if dpora.com uses javascript
    );
  } else {
    throw 'Could not launch $url';
  }
}

// Creating link to the web-based dynamic contact form
_contactForm() async {
  const url = 'https://contact.dpora.com';
  if (await canLaunch(url)) {
    await launch(
      url,
      forceWebView:
          true, // To open url in-app on android. iOS is in-app by default.
      // enableJavaScript: true, // uncomment if dpora.com uses javascript
    );
  } else {
    throw 'Could not launch $url';
  }
}

// Generate an UUID
String milliseconds = DateTime.now().millisecondsSinceEpoch.toString();
Random generateRandom = new Random();
String randomNumber = generateRandom.nextInt(1000000).toString();
final String uuid = randomNumber + milliseconds;

// Make updated copyright text
DateTime nowDate = new DateTime.now();
String nowYear = new DateTime(nowDate.year).toString().substring(0, 4);
final String copyright = 'Copyright © ' + nowYear + ' dpora';

// Default stimulus text
String stimText = 'Error: dpora is not working. Please try again later.';

// Default app-wide colors
Color boxBGColor = Colors.grey[900];
Color iconColor = Colors.grey[700];
Color menuColor = Colors.blueGrey;

// This is updated when user hits Return or Enter on their keyboard
String submittedText = '';

// TODO: later, pull this array content from the DB
// This list order will shuffle everytime the menu drawer closes
var menuMessages = [
  'Have private yet meaningful\nchats with total strangers',
  'Speak your mind and gain\nmultiple perspectives',
  'Educate and learn with others.\nDisagree and grow together.',
];

// Default values for the tileText and textColor
Color userColor = Colors.greenAccent;
String tileTextLT = 'The top left is orange.';
Color textColorLT = Colors.orangeAccent;
String tileTextLB = 'The bottom left is blue.';
Color textColorLB = Colors.blueAccent;
String tileTextRT = 'The top right is purple.';
Color textColorRT = Colors.purpleAccent;
String tileTextRB = 'The bottom right is red.';
Color textColorRB = Colors.redAccent;

// Set the opacity and duration for fading text
double userOpacity = 1.0;
double chatOpacity = 1.0;
int userFadeTime = 10; // in seconds
int chatFadeTime = 10;

// using this to handle inputted text in the textfield
TextEditingController inputController = TextEditingController();

// Use this key to open and close drawer
// programically (in addition to swiping)
GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

// Code needed for snackbars
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
bool waitStatus = false;
// alert user when attempting to post prematurely
final snackBarWait2Post = SnackBar(
  content: const Text('Wait for your last post to disappear!'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
// alert user when there is no internet connection
final snackBarNoInternet = SnackBar(
  content: const Text('No Internet Connection!'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 30),
);

class _DporaAppState extends State<DporaApp> {

  // Firebase realtime database reference
  final firebaseRTDB = FirebaseDatabase.instance.reference();

  // Anonymously authenticate user
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future signInAnonymously() async {
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      User user = userCredential.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Fetch a new stimulus and its instructions
  void newStimulus() {
    // Also get the instructions
    firebaseRTDB
        .child('instructions/ponder')
        .once()
        .then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      setState(() {
        stimText = snapshot.value;
      });
    });
  }

  // Add user comment
  // TODO: where to push it (2 places?)
  void addComments(String user, String comment) {
    firebaseRTDB
        .child('users/comment')
        .push()
        .set({'user': user, 'comment': comment});
    firebaseRTDB
        .child('groups/0001/yellow')
        .push()
        .set({'user': user, 'comment': comment});
  }

  @override
  Widget build(BuildContext context) {
    // is mobile data and wifi turned off?
    checkConnectivity();
    // detect platform
    if (kIsWeb) {
      // detect if web app
      platform = 'Web';
    } else {
      var os = Theme.of(context).platform;
      // detect OS app
      if (os == TargetPlatform.android) {
        platform = 'Android';
      } else if (os == TargetPlatform.iOS) {
        platform = 'iOS';
      } else if (os == TargetPlatform.windows) {
        platform = 'Windows';
      } else if (os == TargetPlatform.macOS) {
        platform = 'Macintosh';
      } else if (os == TargetPlatform.linux) {
        platform = 'Linux';
      } else if (os == TargetPlatform.fuchsia) {
        platform = 'Fuchsia';
      } else {
        platform = 'Unknown';
      }
    }

    // Sign in user anonymously to follow DB read and write rules
    signInAnonymously();
    // Get an intial stimulus and its instructions
    newStimulus();

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
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
                        ),
                      ),
                      TextSpan(
                        // pick the first message from list
                        text: menuMessages.first + '\n\n',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: copyright,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: menuColor,
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_outline_rounded),
                title: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Go to dpora.com
                  _dporaWebsite();
                  // shuffle order of menu messages list
                  setState(() {
                    menuMessages = menuMessages..shuffle();
                  });
                  //close the drawer
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_support_outlined),
                title: Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Go to web-based dynamic contact form
                  _contactForm();
                  setState(() {
                    menuMessages = menuMessages..shuffle();
                  });
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '\nPrivacy' + '\n\n',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '''
This app will guess your country from your
internet address but will not save IPs.

Every post replaces the previous post.
No previous posts are saved.

You were given this random number to jump in.
($uuid) Change it anytime.

Tap the About button above for more info.
''',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              // need to tap the DB to dynamically update the stats
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '\nLive Stats' + '\n\n',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '100 devices detected' + '\n\n',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: '10 countries represented' + '\n\n',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: '1000 posts per minute' + '\n\n',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: platform + ' Version 0.0.1' + '\n',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),
                      TextSpan(
                        text: '2021-03-14' + '\n',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              ListTile(
                leading: Icon(Icons.arrow_back_outlined),
                title: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    menuMessages = menuMessages..shuffle();
                  });
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
    if (airplaneMode == true) {
      // snackbar reminds user to wait until previous post disappears
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBarNoInternet);
      setState(() {
        stimText =
            'Are you in Airplane Mode? Please turn on mobile data, WiFi or both.';
      });
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: boxBGColor,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: iconColor,
                  ),
                  padding: EdgeInsets.zero, // need for alignment
                  tooltip: 'Φ Menu',
                  onPressed: () =>
                      _drawerKey.currentState.openDrawer(), // open drawer
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                  icon: Icon(
                    Icons.share_rounded,
                    color: iconColor,
                  ),
                  padding: EdgeInsets.zero, // need for alignment
                  tooltip: 'Share Topic',
                  onPressed: () {
                    Share.share(stimText + ' \nΦ dpora.com', subject: '');
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
                width: 20.0,
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
                  height: 20.0,
                  width: 20.0,
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
                  height: 4.0, // create some space between
                ),
                Text(
                  '0', // no need for counter here, rather update from DB
                  style: TextStyle(
                    fontSize: 12.0,
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
    int _timeUntilFade = 20;
    int _fadeDuration = 10;
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
          labelText: 'Tap here, type, then hit enter on keyboard.',
          labelStyle: TextStyle(color: userColor),
          hintText: 'Text disappears after 30 seconds. Be brief!',
          hintStyle: TextStyle(color: iconColor),
          // cancel text button
          suffixIcon: IconButton(
            onPressed: () => inputController.clear(),
            icon: Icon(
              Icons.clear,
              size: 10.0,
            ),
          ),
        ),
        maxLength: 255,
        // this is way more than needed but allows for ascii art or venting
        autofocus: false,
        onEditingComplete: () {
          if (waitStatus == true) {
            // snackbar reminds user to wait until previous post disappears
            rootScaffoldMessengerKey.currentState
                .showSnackBar(snackBarWait2Post);
          } else {
            setState(() {
              userFadeTime = 0;
              userOpacity = 1.0;
              submittedText = inputController.text;
              waitStatus = true;
            });
            inputController.clear(); // clear text in input box
            Timer(Duration(seconds: _timeUntilFade), () {
              // after 20 seconds...
              setState(() {
                userFadeTime = _fadeDuration;
                userOpacity = 0.0;
              });
            });
            Timer(Duration(seconds: _timeUntilFade + _fadeDuration), () {
              setState(() {
                waitStatus = false;
              });
            });
          }
        });
  }

  Widget _userOutput(textSize) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
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
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
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
                    height: 20.0,
                    width: 20.0,
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
    final allTextSize = 18.0; // 18 font size
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.23, //23%
          width: MediaQuery.of(context).size.width, //100%
          child: _stimulus(24.0),
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
          child: _userOutput(18.0), // font size 18
        ),
        Container(
          padding: EdgeInsets.all(10.0),
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
    final allTextSize = 26.0; // 26 font size
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.355, //35.5%
                width: MediaQuery.of(context).size.width / 2.0,
                child: _stimulus(32.0),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.355,
                width: MediaQuery.of(context).size.width / 2.0,
                child: _userOutput(26.0), // font size 26
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
        padding: EdgeInsets.all(10.0),
        child: _userInput(),
      ),
    ]);
  }
}
