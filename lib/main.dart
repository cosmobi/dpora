import 'package:flutter/material.dart';
import 'dart:async';
import 'local_import.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
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

// Default app-wide colors
Color boxBGColor = Colors.grey[900];
Color iconColor = Colors.grey[700];
Color menuColor = Colors.blueGrey;

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

  // Pick a stimulus
  void getStimulus(stimuliCategory, stimulusID) {
    firebaseRTDB
        .child('stimuli/$stimuliCategory/$stimulusID')
        .once()
        .then((DataSnapshot snapshot) {
      Map<String, dynamic> stimulusMap =
          new Map<String, dynamic>.from(snapshot.value);
      var stimulusDetails = Stimulus.fromJson(stimulusMap);
      setState(() {
        stimulusText = stimulusDetails.stimulus;
        // TODO: categoryText = ?
      });
    });
  }

  void shuffleDecks() {
    // Shuffle category selection
    stimuliDeck.shuffle();
    // Shuffle stimuli in each category
    adsDeck.shuffle();
    debatesDeck.shuffle();
    gamesDeck.shuffle();
    jokesDeck.shuffle();
    mythsDeck.shuffle();
    newsDeck.shuffle();
    passionDeck.shuffle();
    personalDeck.shuffle();
    ponderDeck.shuffle();
    proverbsDeck.shuffle();
    quotesDeck.shuffle();
    shareDeck.shuffle();
    triviaDeck.shuffle();
  }

  void chooseCategory(dieRoll) {
    int _startTotal = 0;
    int _endTotal = totalAds;
    if (dieRoll < _endTotal) {
      categoryChoice = 'ads';
    } else {
      _startTotal = _endTotal;
      _endTotal = _endTotal + totalDebates;
      if (dieRoll >= _startTotal && dieRoll < _endTotal) {
        categoryChoice = 'debates';
      } else {
        _startTotal = _endTotal;
        _endTotal = _endTotal + totalGames;
        if (dieRoll >= _startTotal && dieRoll < _endTotal) {
          categoryChoice = 'games';
        } else {
          _startTotal = _endTotal;
          _endTotal = _endTotal + totalJokes;
          if (dieRoll >= _startTotal && dieRoll < _endTotal) {
            categoryChoice = 'jokes';
          } else {
            _startTotal = _endTotal;
            _endTotal = _endTotal + totalMyths;
            if (dieRoll >= _startTotal && dieRoll < _endTotal) {
              categoryChoice = 'myths';
            } else {
              _startTotal = _endTotal;
              _endTotal = _endTotal + totalNews;
              if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                categoryChoice = 'news';
              } else {
                _startTotal = _endTotal;
                _endTotal = _endTotal + totalPassion;
                if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                  categoryChoice = 'passion';
                } else {
                  _startTotal = _endTotal;
                  _endTotal = _endTotal + totalPersonal;
                  if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                    categoryChoice = 'personal';
                  } else {
                    _startTotal = _endTotal;
                    _endTotal = _endTotal + totalPonder;
                    if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                      categoryChoice = 'ponder';
                    } else {
                      _startTotal = _endTotal;
                      _endTotal = _endTotal + totalProverbs;
                      if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                        categoryChoice = 'proverbs';
                      } else {
                        _startTotal = _endTotal;
                        _endTotal = _endTotal + totalQuotes;
                        if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                          categoryChoice = 'quotes';
                        } else {
                          _startTotal = _endTotal;
                          _endTotal = _endTotal + totalShare;
                          if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                            categoryChoice = 'share';
                          } else {
                            //if dieRoll >= _endTotal
                            categoryChoice = 'trivia';
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  void randomStimulus() {
    if (categoryChoice == 'ads') {
      getStimulus(categoryChoice, adsDeck[0]);
    } else if (categoryChoice == 'debates') {
      getStimulus(categoryChoice, debatesDeck[0]);
    } else if (categoryChoice == 'games') {
      getStimulus(categoryChoice, gamesDeck[0]);
    } else if (categoryChoice == 'jokes') {
      getStimulus(categoryChoice, jokesDeck[0]);
    } else if (categoryChoice == 'myths') {
      getStimulus(categoryChoice, mythsDeck[0]);
    } else if (categoryChoice == 'news') {
      getStimulus(categoryChoice, newsDeck[0]);
    } else if (categoryChoice == 'passion') {
      getStimulus(categoryChoice, passionDeck[0]);
    } else if (categoryChoice == 'personal') {
      getStimulus(categoryChoice, personalDeck[0]);
    } else if (categoryChoice == 'ponder') {
      getStimulus(categoryChoice, ponderDeck[0]);
    } else if (categoryChoice == 'proverbs') {
      getStimulus(categoryChoice, proverbsDeck[0]);
    } else if (categoryChoice == 'quotes') {
      getStimulus(categoryChoice, quotesDeck[0]);
    } else if (categoryChoice == 'share') {
      getStimulus(categoryChoice, shareDeck[4]);
    } else if (categoryChoice == 'trivia') {
      getStimulus(categoryChoice, triviaDeck[0]);
    } else {
      // This is the default if random choices don't work
      // "What's on your mind?"
      // It is the same as shareDeck[4] default above
      getStimulus('share', 5);
    }
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

    // Choose a category
    chooseCategory(stimuliDeck[2290]);
    // The default 2290 falls in the range of the 'share' category
    // and the default stimulus there is set to "What's on your mind?"

    // Choose a random stimulus
    randomStimulus();

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
Once a comment disappears, it's gone!

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
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      // TextSpan(
                      //   text: '\nLive Stats' + '\n\n',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.white,
                      //   ),
                      // ),
                      // TextSpan(
                      //   text: 'Over 100 devices detected' + '\n\n',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      // TextSpan(
                      //   text: 'Over 10 countries represented' + '\n\n',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      // TextSpan(
                      //   text: 'About 1000 posts per minute' + '\n\n',
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: Colors.white70,
                      //   ),
                      // ),
                      TextSpan(
                        text: platform + ' Version 0.0.1' + '\n',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white54,
                        ),
                      ),
                      // TextSpan(
                      //   text: '2021-03-14' + '\n',
                      //   style: TextStyle(
                      //     fontSize: 10,
                      //     color: Colors.white54,
                      //   ),
                      // ),
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
      // snackbar notice if no internet connection is found
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBarNoInternet);
      setState(() {
        stimulusText = 'Please turn on mobile data, WiFi or both.';
        categoryText = 'Are you in Airplane Mode?';
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
        // Menu button and other icons here
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
                    Share.share(stimulusText + ' \nΦ dpora.com', subject: categoryText);
                  },
                ),
              ),
              // TODO: Add this later, somewhere else
                // child: IconButton(
                //   icon: Icon(
                //     Icons.threesixty_rounded,
                //     color: iconColor,
                //   ),
                //   padding: EdgeInsets.zero, // need for alignment
                //   tooltip: 'New Group & Topic',
                //   onPressed: () {}, // maybe just restart app? maybe using
                //            //  https://pub.dev/packages/flutter_phoenix
                // ),
              SizedBox(
                height: 20.0,
                width: 20.0,
                child: IconButton(
                  icon: Icon(
                    Icons.not_interested_rounded,
                    color: iconColor,
                  ),
                  padding: EdgeInsets.zero, // need for alignment
                  tooltip: 'Flag As Inappropriate',
                  onPressed: () {
                   // up the flag counter for this stimulus
                  },
                ),
              ),
            ]),
        // Stimulus is displayed here
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            child: Text(
              stimulusText,
              style: TextStyle(
                fontSize: textSize,
                color: Colors.yellow, //yellowAccent is too bright
              ),
            ),
          ),
        ),
        // Instructions and Next button in this column
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.emoji_people_rounded,
                color: Colors.yellow,
              ),
              Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey[900],
                ),
                height: 70.0,
                width: 90.0,
                child: Text(
                  'All about you',
                  style: TextStyle(
                  // instructions text is 5 points smaller than stimulus text
                  fontSize: textSize - 5,
                  color: Colors.yellow, //yellowAccent is too bright
                  ),
                ),
              ),
              Row(children: [
                Text(
                  'Next', // no need for counter here, rather update from DB
                  style: TextStyle(
                    fontSize: textSize,
                    color: iconColor,
                    //letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30.0,
                  width: 30.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.forward_rounded,
                      color: Colors.yellow,
                    ),
                    padding: EdgeInsets.zero, // need for alignment
                    tooltip: 'Next Topic',
                    onPressed: () {
                      // shuffle all decks and therefore show a new stimulus
                      shuffleDecks();
                    },
                  ),
                ),
                Text(
                    '0', // no need for counter here, rather update from DB
                    //
                    style: TextStyle(
                      fontSize: textSize - 2,
                      color: iconColor,
                    ),
                  ),
              ]),
            ]),
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
              children: [
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.not_interested_rounded,
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
                // spacer box
                SizedBox(
                  height: 5.0,
                  width: 5.0,
                  ),
                Text(
                  '0', // no need for counter here, rather update from DB
                  //
                  style: TextStyle(
                    fontSize: textSize,
                    color: iconColor,
                  ),
                ),
              ],
            ),
            //]),
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
          child: _stimulus(20.0),
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
