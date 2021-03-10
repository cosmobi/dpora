// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// //import 'package:firebase_auth/firebase_auth.dart'; TODO: uncomment when ready
// import 'package:flutter/painting.dart';
// import 'dart:async';
// import 'package:share_plus/share_plus.dart';
// import 'package:flutter/foundation.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:connectivity/connectivity.dart';
// import 'dart:math';

// // wrap DporaApp widget within a MaterialApp widget
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(home: DporaApp()));
// }

// class DporaApp extends StatefulWidget {
//   @override
//   _DporaAppState createState() => _DporaAppState();
// }

// // if both mobile data or wifi is turned off then tell
// // the user (as a stimulus) to turn on one or both.
// bool airplaneMode = false;
// void checkConnectivity() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.none) {
//     airplaneMode = true;
//   }
// }

// // Will be used to hold platform identification
// String platform;

// // creating link to main website
// _dporaWebsite() async {
//   const url = 'https://dpora.com';
//   if (await canLaunch(url)) {
//     await launch(
//       url,
//       forceWebView:
//           true, // to open url in-app on android. iOS is in-app by default.
//       // enableJavaScript: true, // uncomment if dpora.com uses javascript
//     );
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// // creating link to the web-based dynamic contact form
// _contactForm() async {
//   const url = 'https://contact.dpora.com';
//   if (await canLaunch(url)) {
//     await launch(
//       url,
//       forceWebView:
//           true, // to open url in-app on android. iOS is in-app by default.
//       // enableJavaScript: true, // uncomment if dpora.com uses javascript
//     );
//   } else {
//     throw 'Could not launch $url';
//   }
// }

// // generate an UUID
// String milliseconds = DateTime.now().millisecondsSinceEpoch.toString();
// Random generateRandom = new Random();
// String randomNumber = generateRandom.nextInt(1000000).toString();
// final String uuid = randomNumber + milliseconds;

// // Make updated copyright text
// DateTime nowDate = new DateTime.now();
// String nowYear = new DateTime(nowDate.year).toString().substring(0, 4);
// final String copyright = 'Copyright © ' + nowYear + ' dpora';

// class _DporaAppState extends State<DporaApp> {
//   // Set default `_initialized` and `_error` state to false
//   bool _initialized = false;
//   bool _error = false;

//   // Define an async function to initialize FlutterFire
//   void initializeFlutterFire() async {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       // Wait for Firebase to initialize and set `_initialized` state to true
//       await Firebase.initializeApp();
//       setState(() {
//         _initialized = true;
//       });
//     } catch (e) {
//       // Set `_error` state to true if Firebase initialization fails
//       setState(() {
//         _error = true;
//       });
//     }
//   }

//   @override
//   void initState() {
//     initializeFlutterFire();
//     super.initState();
//   }

//   // create reference to firebase realtime database
//   // var retrievedCategory;
//   // var allInstructions;

//   // Firebase Realtime Database
//   final realtimeDB = FirebaseDatabase.instance.reference();
//   //final Future<FirebaseApp> _future = Firebase.initializeApp();
//   String retrievedInstructions = 'hello';

//   void getInstructions() {
//     realtimeDB
//         .orderByChild("instructions")
//         .equalTo("personal")
//         .once()
//         .then((DataSnapshot snapshot) {
//       setState(() {
//         // retrievedInstructions = '${snapshot.value}';
//         // retrievedInstructions = snapshot.value;
//         retrievedInstructions = 'goodbye';
//       });
//       //String stimText = '${snapshot.value}';
//     });
//   }

// // String stimText = realtimeDB.orderByChild("instructions").equalTo("personal").once();

//   // @override
//   // void chigachoochoo() {
//   //   FutureBuilder(
//   //       future: refFirebaseRTDB.child("instructions").once(),
//   //       builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
//   //         if (snapshot.hasData) {
//   //           allInstructions.clear();
//   //           Map<dynamic, dynamic> values = snapshot.data.value;
//   //           values.forEach((key, values) {
//   //             allInstructions.add(values);
//   //           });
//   //         }
//   //         return CircularProgressIndicator();
//   //       });
//   // }

//   // @override
//   // void goGetit() {
//   //   refFirebaseRTDB.child("instructions/personal").once().then((DataSnapshot data) {
//   //     setState(() {
//   //       retrievedCategory = data.key;
//   //       retrievedInstructions = data.value;
//   //     });
//   //   });
//   // }

//   // goGetit();
//   // String stimText = retrievedInstructions;

//   // String stimText =
//   //     'Mind on your money. Money on your mind. Sippin on gin and juice. West Side, yall!';

//   // default app-wide colors
//   Color boxBGColor = Colors.grey[900];
//   Color iconColor = Colors.grey[700];
//   Color menuColor = Colors.blueGrey;

//   // this is updated when user hits Return or Enter on their keyboard
//   String submittedText = '';

//   // updatable content from DB
//   var menuMessages = [
//     'Have private yet meaningful\nchats with total strangers',
//     'Speak your mind and gain\nmultiple perspectives',
//     'Educate and learn with others.\nDisagree and grow together.',
//   ];
//   // the list order will shuffle everytime the menu drawer closes

//   Color userColor = Colors.greenAccent; // userText updated in userOutput below
//   String tileTextLT = 'left top text here';
//   Color textColorLT = Colors.orangeAccent;
//   String tileTextLB = 'left bottom text here';
//   Color textColorLB = Colors.blueAccent;
//   String tileTextRT =
//       'this text is about 25 words or something maybe longer. this text is about 25 words or maybe shorter. this text is about 25 words or so.';
//   Color textColorRT = Colors.purpleAccent;
//   String tileTextRB = 'right bottom text here and not there';
//   Color textColorRB = Colors.redAccent;

//   // for fading text
//   double userOpacity = 1.0;
//   double chatOpacity = 1.0;
//   int userFadeTime = 10;
//   int chatFadeTime = 10;

//   // using this key to open and close drawer
//   // programically (in addition to swiping)
//   GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

//   // needed for snackbars
//   final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
//       GlobalKey<ScaffoldMessengerState>();
//   bool waitStatus = false;
//   final snackBarWait = SnackBar(
//     content: const Text('Wait for your last post to disappear!'),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(10),
//         topRight: Radius.circular(10),
//       ),
//     ),
//     backgroundColor: Colors.yellow,
//     duration: const Duration(seconds: 4),
//   );
//   final snackBarFlutterFireError = SnackBar(
//     content: const Text('Error: cannot initialize database. Try later.'),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(10),
//         topRight: Radius.circular(10),
//       ),
//     ),
//     backgroundColor: Colors.yellow,
//     duration: const Duration(seconds: 4),
//   );

//   // using this to handle inputted text in the textfield
//   TextEditingController inputController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // is mobile data and wifi turned off?
//     // checkConnectivity(); // TODO: uncomment and fix errors
//     // detect platform
//     if (kIsWeb) {
//       // detect if web app
//       platform = 'Web';
//     } else {
//       var os = Theme.of(context).platform;
//       // detect OS app
//       if (os == TargetPlatform.android) {
//         platform = 'Android';
//       } else if (os == TargetPlatform.iOS) {
//         platform = 'iOS';
//       } else if (os == TargetPlatform.windows) {
//         platform = 'Windows';
//       } else if (os == TargetPlatform.macOS) {
//         platform = 'Macintosh';
//       } else if (os == TargetPlatform.linux) {
//         platform = 'Linux';
//       } else if (os == TargetPlatform.fuchsia) {
//         platform = 'Fuchsia';
//       } else {
//         platform = 'Unknown';
//       }
//     }

//     // Show error message if FlutterFire initialization failed
//     if (_error) {
//       rootScaffoldMessengerKey.currentState
//           .showSnackBar(snackBarFlutterFireError);
//     }

//     // Show a loader until FlutterFire is initialized
//     if (!_initialized) {
//       return CircularProgressIndicator();
//     }

//     getInstructions();

//     return MaterialApp(
//       scaffoldMessengerKey: rootScaffoldMessengerKey,
//       title: 'ϕ dpora', // or use Φ
//       theme: ThemeData.dark(),
//       home: Scaffold(
//         key: _drawerKey,
//         backgroundColor: Colors.black,
//         // appBar would go here
//         drawer: Drawer(
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               DrawerHeader(
//                 child: Text.rich(
//                   TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: 'Φ dpora\n \n',
//                         style: TextStyle(
//                           fontSize: 32,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextSpan(
//                         // pick the first message from list
//                         text: menuMessages.first + '\n\n',
//                         style: TextStyle(
//                           fontSize: 19,
//                           color: Colors.black,
//                         ),
//                       ),
//                       TextSpan(
//                         text: copyright,
//                         style: TextStyle(
//                           fontStyle: FontStyle.italic,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                   color: menuColor,
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.info_outline_rounded),
//                 title: Text(
//                   'About',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onTap: () {
//                   // Go to dpora.com
//                   _dporaWebsite();
//                   // shuffle order of menu messages list
//                   setState(() {
//                     menuMessages = menuMessages..shuffle();
//                   });
//                   //close the drawer
//                   _drawerKey.currentState.openEndDrawer();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.contact_support_outlined),
//                 title: Text(
//                   'Contact',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onTap: () {
//                   // Go to web-based dynamic contact form
//                   _contactForm();
//                   setState(() {
//                     menuMessages = menuMessages..shuffle();
//                   });
//                   _drawerKey.currentState.openEndDrawer();
//                 },
//               ),
//               Divider(
//                 height: 1,
//                 thickness: 1,
//               ),
//               Container(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Text.rich(
//                   TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '\nPrivacy' + '\n\n',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '''
// This app will guess your country from your
// internet address but will not save IPs.

// Every post replaces the previous post.
// No previous posts are saved.

// You were given this random number to jump in.
// ($uuid) Change it anytime.

// Tap the About button above for more info.
// ''',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(
//                 height: 1,
//                 thickness: 1,
//               ),
//               // need to tap the DB to dynamically update the stats
//               Container(
//                 padding: EdgeInsets.only(left: 20),
//                 child: Text.rich(
//                   TextSpan(
//                     children: <TextSpan>[
//                       TextSpan(
//                         text: '\nLive Stats' + '\n\n',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '100 devices detected' + '\n\n',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '10 countries represented' + '\n\n',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '1000 posts per minute' + '\n\n',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       TextSpan(
//                         text: platform + ' Version 0.0.1' + '\n',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.white54,
//                         ),
//                       ),
//                       TextSpan(
//                         text: '2021-03-14' + '\n',
//                         style: TextStyle(
//                           fontSize: 10,
//                           color: Colors.white54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(
//                 height: 1,
//                 thickness: 1,
//               ),
//               ListTile(
//                 leading: Icon(Icons.arrow_back_outlined),
//                 title: Text(
//                   'Back',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                   ),
//                 ),
//                 onTap: () {
//                   setState(() {
//                     menuMessages = menuMessages..shuffle();
//                   });
//                   _drawerKey.currentState.openEndDrawer();
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: OrientationBuilder(
//           builder: (context, orientation) {
//             return orientation == Orientation.portrait
//                 ? _buildVerticalLayout(
//                     tileTextLT,
//                     textColorLT,
//                     tileTextLB,
//                     textColorLB,
//                     tileTextRT,
//                     textColorRT,
//                     tileTextRB,
//                     textColorRB,
//                   )
//                 : _buildHorizontalLayout(
//                     tileTextLT,
//                     textColorLT,
//                     tileTextLB,
//                     textColorLB,
//                     tileTextRT,
//                     textColorRT,
//                     tileTextRB,
//                     textColorRB,
//                   );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _stimulus(textSize) {
//     if (airplaneMode == true) {
//       // stimText = TODO: Set this back!
//       retrievedInstructions =
//           'NO INTERNET CONNECTION!\nAre you in Airplane Mode? Please turn on mobile data, WiFi or both.';
//     }
//     return Container(
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.yellow),
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: boxBGColor,
//       ),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.menu_rounded,
//                     color: iconColor,
//                   ),
//                   padding: EdgeInsets.zero, // need for alignment
//                   tooltip: 'Φ Menu',
//                   onPressed: () =>
//                       _drawerKey.currentState.openDrawer(), // open drawer
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.share_rounded,
//                     color: iconColor,
//                   ),
//                   padding: EdgeInsets.zero, // need for alignment
//                   tooltip: 'Share Topic',
//                   onPressed: () {
//                     Share.share(retrievedInstructions + ' \nΦ dpora.com',
//                         subject: ''); // TODO: Set this back!
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: IconButton(
//                   icon: Icon(
//                     Icons.threesixty_rounded,
//                     color: iconColor,
//                   ),
//                   padding: EdgeInsets.zero, // need for alignment
//                   tooltip: 'New Group & Topic',
//                   onPressed: () {}, // maybe just restart app?
//                 ),
//               ),
//               Column(children: [
//                 SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.cancel_presentation_rounded,
//                       color: iconColor,
//                     ),
//                     padding: EdgeInsets.zero, // need for alignment
//                     tooltip: 'Same Group, New Topic',
//                     onPressed: () {},
//                   ),
//                 ),
//                 SizedBox(
//                   height: 4, // create some space between
//                 ),
//                 Text(
//                   '0', // no need for counter here, rather update from DB
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: iconColor,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ]),
//             ]),
//         Flexible(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
//             child: Text(
//               retrievedInstructions, // TODO: Set this back (to stimText)
//               style: TextStyle(
//                 fontSize: textSize,
//                 color: Colors.yellow, //yellowAccent is too bright
//               ),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   Widget _userInput() {
//     int _timeUntilFade = 20;
//     int _fadeDuration = 10;
//     return TextField(
//         controller: inputController,
//         style: TextStyle(color: userColor),
//         cursorColor: userColor,
//         decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: userColor),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: userColor),
//           ),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: userColor),
//           ),
//           fillColor: boxBGColor,
//           filled: true,
//           labelText:
//               'Select this box to type, then hit enter on your keyboard.',
//           labelStyle: TextStyle(color: userColor),
//           hintText: 'Responses disappear after 30 seconds. Be brief!',
//           hintStyle: TextStyle(color: iconColor),
//           // cancel text button
//           suffixIcon: IconButton(
//             onPressed: () => inputController.clear(),
//             icon: Icon(
//               Icons.clear,
//               size: 10,
//             ),
//           ),
//         ),
//         maxLength: 255,
//         // this is way more than needed but allows for ascii art or venting
//         autofocus: false,
//         onEditingComplete: () {
//           if (waitStatus == true) {
//             // snackbar reminds user to wait until previous post disappears
//             rootScaffoldMessengerKey.currentState.showSnackBar(snackBarWait);
//           } else {
//             setState(() {
//               userFadeTime = 0;
//               userOpacity = 1.0;
//               submittedText = inputController.text;
//               waitStatus = true;
//             });
//             inputController.clear(); // clear text in input box
//             Timer(Duration(seconds: _timeUntilFade), () {
//               // after 20 seconds...
//               setState(() {
//                 userFadeTime = _fadeDuration;
//                 userOpacity = 0.0;
//               });
//             });
//             Timer(Duration(seconds: _timeUntilFade + _fadeDuration), () {
//               setState(() {
//                 waitStatus = false;
//               });
//             });
//           }
//         });
//   }

//   Widget _userOutput(textSize) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(color: userColor),
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: boxBGColor,
//       ),
//       child: AnimatedOpacity(
//         duration: Duration(seconds: userFadeTime), // fade duration
//         opacity: userOpacity,
//         child: Text(
//           submittedText,
//           style: TextStyle(fontSize: textSize, color: userColor),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis, // truncates, not scrollable
//         ),
//       ),
//     );
//   }

//   Widget _chatTile(tileHeight, tileWidth, textSize, tileText, textColor) {
//     // fades out tileText
//     Timer(Duration(seconds: 20), () {
//       setState(() {
//         // just in case user just muted someone
//         if (chatFadeTime == 1) {
//           chatFadeTime = 10;
//         }
//         chatOpacity = 0.0;
//       });
//     });

//     return Container(
//       height: MediaQuery.of(context).size.height * tileHeight,
//       width: MediaQuery.of(context).size.width * tileWidth,
//       padding: EdgeInsets.all(10),
//       margin: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         border: Border.all(color: textColor),
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         color: boxBGColor,
//       ),
//       child:
//           Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Flexible(
//           child: SingleChildScrollView(
//             child: AnimatedOpacity(
//               duration: Duration(seconds: chatFadeTime), // fade duration
//               opacity: chatOpacity,
//               child: Text(
//                 tileText,
//                 style: TextStyle(fontSize: textSize, color: textColor),
//               ),
//             ),
//           ),
//         ),
//         Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Flexible(
//                 child: Text(
//                   'USA',
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontStyle: FontStyle.italic,
//                     color: iconColor,
//                   ),
//                   overflow: TextOverflow.ellipsis, // truncates, not scrollable
//                 ),
//               ),
//               Row(
//                 children: [
//                   //
//                   Text(
//                     '0', // no need for counter here, rather update from DB
//                     //
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: iconColor,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.person_remove_outlined,
//                         color: iconColor,
//                       ),
//                       padding: EdgeInsets.zero, // need for alignment
//                       tooltip: 'Mute Person',
//                       onPressed: () {
//                         setState(() {
//                           chatFadeTime = 1; // set to quick fade
//                           chatOpacity = 0.0;
//                           // reset fade duration
//                         });
//                         Timer(Duration(seconds: 1), () {
//                           setState(() {
//                             chatFadeTime = 10;
//                           });
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ]),
//       ]),
//     );
//   }

//   Widget _buildVerticalLayout(
//     tileTextLT,
//     textColorLT,
//     tileTextLB,
//     textColorLB,
//     tileTextRT,
//     textColorRT,
//     tileTextRB,
//     textColorRB,
//   ) {
//     final allTileHeight = 0.2; // 20% screen height
//     final allTileWidth = 0.45; // 45% screen width
//     final allTextSize = 18; // 18 font size
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.23, //23%
//           width: MediaQuery.of(context).size.width, //100%
//           child: _stimulus(24),
//         ),
//         // build the chat titles, the left column (top & bottom) and right
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 _chatTile(
//                   allTileHeight,
//                   allTileWidth,
//                   allTextSize,
//                   tileTextLT,
//                   textColorLT,
//                 ),
//                 _chatTile(
//                   allTileHeight,
//                   allTileWidth,
//                   allTextSize,
//                   tileTextLB,
//                   textColorLB,
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 _chatTile(
//                   allTileHeight,
//                   allTileWidth,
//                   allTextSize,
//                   tileTextRT,
//                   textColorRT,
//                 ),
//                 _chatTile(
//                   allTileHeight,
//                   allTileWidth,
//                   allTextSize,
//                   tileTextRB,
//                   textColorRB,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width,
//           child: _userOutput(18), // font size 18
//         ),
//         Container(
//           padding: EdgeInsets.all(10),
//           width: MediaQuery.of(context).size.width,
//           child: _userInput(),
//         ),
//       ],
//     );
//   }

//   Widget _buildHorizontalLayout(
//     tileTextLT,
//     textColorLT,
//     tileTextLB,
//     textColorLB,
//     tileTextRT,
//     textColorRT,
//     tileTextRB,
//     textColorRB,
//   ) {
//     final allTileHeight = 0.33; // 33% screen height
//     final allTileWidth = 0.21; // 21% screen width
//     final allTextSize = 26; // 26 font size
//     return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.355, //35.5%
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: _stimulus(32),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.355,
//                 width: MediaQuery.of(context).size.width / 2,
//                 child: _userOutput(26), // font size 26
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Column(
//                     children: [
//                       _chatTile(
//                         allTileHeight,
//                         allTileWidth,
//                         allTextSize,
//                         tileTextLT,
//                         textColorLT,
//                       ),
//                       _chatTile(
//                         allTileHeight,
//                         allTileWidth,
//                         allTextSize,
//                         tileTextLB,
//                         textColorLB,
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       _chatTile(
//                         allTileHeight,
//                         allTileWidth,
//                         allTextSize,
//                         tileTextRT,
//                         textColorRT,
//                       ),
//                       _chatTile(
//                         allTileHeight,
//                         allTileWidth,
//                         allTextSize,
//                         tileTextRB,
//                         textColorRB,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           )
//         ],
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width * 0.95, //95%
//         padding: EdgeInsets.all(10),
//         child: _userInput(),
//       ),
//     ]);
//   }
// }