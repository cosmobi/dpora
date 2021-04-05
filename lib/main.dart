import 'package:flutter/material.dart';
import 'dart:async';
import 'local_import.dart';
import 'package:connectivity/connectivity.dart';
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

// If mobile data and/or wifi are turned off then tell the
// user (as a stimulus and snackbar) to turn on one or both.
bool airplaneMode = false;
void checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    airplaneMode = true;
  }
}

// Default app-wide colors
Color boxBGColor = Colors.grey[900];
Color iconColor = Colors.grey[700];
Color menuColor = Colors.blueGrey;

// Empty default values for the tileText and textColor
Color userColor = Colors.black;
Color colorOfMutedUser = boxBGColor;
String tileTextLT = '';
Color textColorLT = Colors.black;
int postTimeLT = DateTime.now().millisecondsSinceEpoch;
bool tileVacancyLT = false;
int muteCountLT = 0;
String tileTextLB = '';
Color textColorLB = Colors.black;
int postTimeLB = DateTime.now().millisecondsSinceEpoch;
bool tileVacancyLB = false;
int muteCountLB = 0;
String tileTextRT = '';
Color textColorRT = Colors.black;
int postTimeRT = DateTime.now().millisecondsSinceEpoch;
bool tileVacancyRT = false;
int muteCountRT = 0;
String tileTextRB = '';
Color textColorRB = Colors.black;
int postTimeRB = DateTime.now().millisecondsSinceEpoch;
bool tileVacancyRB = false;
int muteCountRB = 0;

// Use this key to open and close drawer
// programically (in addition to swiping)
GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

// Code needed for snackbars
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
bool waitStatus = false;
// Snackbar Notifications
final snackBarNewGroup = SnackBar(
  content: const Text('Successfully entered a new group'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
final snackBarWait2Post = SnackBar(
  content: const Text('Wait for your last post to disappear'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
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
final snackBarNeeds2Strikes = SnackBar(
  content: const Text('Topic changes after 2 people hit Next'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
final snackBarNeeds3Strikes = SnackBar(
  content: const Text('Topic changes after 3 people hit Next'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
final snackBarNextStimulus = SnackBar(
  content: const Text('We have a new topic!'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
final snackBarMutedUser = SnackBar(
  content: const Text('Color muted! Hit again to unmute.'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);
final snackBarUnmutedUser = SnackBar(
  content: const Text('Unmuted previously muted color.'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 4),
);

// Circular process indicator while registering users
showAlertDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(
          strokeWidth: 10,
          valueColor:
              new AlwaysStoppedAnimation<Color>(Colors.greenAccent[700]),
        ),
        SizedBox(
          height: 1.0,
          width: 10.0,
        ),
        Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              'Welcome to dpora!',
              style: TextStyle(
                fontSize: 20,
              ),
            )),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _DporaAppState extends State<DporaApp> {
  // Using this to handle inputted text in the textfield
  final inputController = TextEditingController();
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  // Firebase realtime database reference
  final firebaseRTDB = FirebaseDatabase.instance.reference();

  // Anonymously authenticate user
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future signInAnonymously() async {
    try {
      showAlertDialog(context); // start standby msg
      UserCredential userCredential = await auth.signInAnonymously();
      User user = userCredential.user;
      Navigator.pop(context); // end standby msg
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get slogans to display in the menu drawer
  void getSlogans() {
    firebaseRTDB.child('slogans').once().then((DataSnapshot snapshot) {
      List<String> sloganList = new List<String>.from(snapshot.value);
      setState(() {
        slogans = sloganList;
        sMax = sloganList.length;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  // Keep the stats in the menu updated in realtime
  void liveStats() {
    firebaseRTDB.child('statistics').once().then((DataSnapshot snapshot) {
      Map<String, dynamic> statMap =
          new Map<String, dynamic>.from(snapshot.value);
      var liveStatistics = Stats.fromJson(statMap);
      setState(() {
        commentsPosted = liveStatistics.comments;
        countriesRepresented = liveStatistics.countries;
        devicesDetected = liveStatistics.devices;
        version = liveStatistics.version;
      });
    });
  }

  // Find or create a group that has a vacancy
  void findVacantGroup() {
    String groupName = '';
    int openSeats = 0;
    int milliEpoch = DateTime.now().millisecondsSinceEpoch;
    firebaseRTDB.child('vacancies').once().then((DataSnapshot snapshotGroups) {
      var vacancyCheck = new Map<String, dynamic>.from(snapshotGroups.value);
      // First gather some keys before assigning one in priority order
      var key4 = vacancyCheck.keys
          .firstWhere((k4) => vacancyCheck[k4] == 4, orElse: () => null);
      var key3 = vacancyCheck.keys
          .firstWhere((k3) => vacancyCheck[k3] == 3, orElse: () => null);
      var key2 = vacancyCheck.keys
          .firstWhere((k2) => vacancyCheck[k2] == 2, orElse: () => null);
      var key1 = vacancyCheck.keys
          .firstWhere((k1) => vacancyCheck[k1] == 1, orElse: () => null);
      var key5 = vacancyCheck.keys
          .firstWhere((k5) => vacancyCheck[k5] == 5, orElse: () => null);
      if (key4 != null) {
        // only 1 other person in group, so priority assignment is here
        groupName = key4;
        openSeats = 4;
      } else if (key3 != null) {
        groupName = key3;
        openSeats = 3;
      } else if (key2 != null) {
        groupName = key2;
        openSeats = 2;
      } else if (key1 != null) {
        groupName = key1;
        openSeats = 1;
      } else if (key5 != null) {
        // empty group, assign first person there
        groupName = key5;
        openSeats = 5;
      } else {
        // new group is needed, first create a new group name/uid
        groupName = firebaseRTDB.child('groups').push().key;
        // Now use this to add the key/value pairs
        firebaseRTDB.child('groups').child('$groupName').set({
          'blue-content': '',
          'blue-strikes': 0,
          'blue-timestamp': milliEpoch,
          'blue-vacancy': true,
          'green-content': '',
          'green-strikes': 0,
          'green-timestamp': milliEpoch,
          'green-vacancy': true,
          'orange-content': '',
          'orange-strikes': 0,
          'orange-timestamp': milliEpoch,
          'orange-vacancy': true,
          'purple-content': '',
          'purple-strikes': 0,
          'purple-timestamp': milliEpoch,
          'purple-vacancy': true,
          'red-content': '',
          'red-strikes': 0,
          'red-timestamp': milliEpoch,
          'red-vacancy': true,
          'stimulus-category': '',
          'stimulus-content': 'What would you like to talk about?',
          'stimulus-instructions': 'All about you',
          'stimulus-strikes': 0
        }).then((_) {
          // update the vacancy status in vacancies node
          firebaseRTDB
              .child('vacancies')
              .update({'$groupName': 5}).catchError((onError) {
            print(onError);
          });
        });
      }
      // And now assign a vacant seat in that group
      assignVacantColor(groupName, openSeats);
    });
  }

  void assignVacantColor(groupName, openSeats) {
    // Looking for a vacant color (an open seat)
    var seatColor = ''; // The color in that group
    firebaseRTDB
        .child('groups')
        .child('$groupName')
        .once()
        .then((DataSnapshot snapshotColors) {
      var colorVacancies = new Map<String, dynamic>.from(snapshotColors.value);
      var blueSeat = colorVacancies['blue-vacancy'];
      // if blueSeat gives error, try = colorVacancies[groupName]['blue-vacancy']
      // because the json result might be nested (as it happened before)
      if (blueSeat == true) {
        seatColor = 'blue';
      } else {
        var greenSeat = colorVacancies['green-vacancy'];
        if (greenSeat == true) {
          seatColor = 'green';
        } else {
          var orangeSeat = colorVacancies['orange-vacancy'];
          if (orangeSeat == true) {
            seatColor = 'orange';
          } else {
            var purpleSeat = colorVacancies['purple-vacancy'];
            if (purpleSeat == true) {
              seatColor = 'purple';
            } else {
              var redSeat = colorVacancies['red-vacancy'];
              if (redSeat == true) {
                seatColor = 'red';
              }
            }
          }
        }
      }
      // just in case someone snatched the last seat as it was being assigned
      if (seatColor == '') {
        Timer(Duration(seconds: 2), () {
          // wait a couple secs and see if a new position opens somewhere else
        });
      } else {
        // Then assign the open seat (group and color) to the user
        firebaseRTDB
            .child('dporians')
            .child(auth.currentUser.uid)
            .update({'color': '$seatColor', 'group': '$groupName'}).then((_) {
          // update group vacancy status
          updateVacancy(groupName, seatColor, openSeats, false);
        }).catchError((onError) {
          print(onError);
        });
      }
    });
    // show success
    rootScaffoldMessengerKey.currentState.showSnackBar(snackBarNewGroup);
  }

  void updateVacancy(groupName, seatColor, seatCount, v) {
    // prep the variables
    String colorContent = seatColor + '-content';
    String colorStrikes = seatColor + '-strikes';
    String userStatus = '[ ' + seatColor;
    String colorTimestamp = seatColor + '-timestamp';
    String seatKey = seatColor + '-vacancy';
    if (v == false) {
      seatCount--; // decrement
      userStatus = userStatus + ' entered ]';
    } else {
      seatCount++; // increment
      userStatus = userStatus + ' exited ]';
    }
    // update the vacancy in vacancies node
    firebaseRTDB.child('vacancies').update({'$groupName': seatCount}).then((_) {
      // update the vacancy in groups node
      firebaseRTDB.child('groups').child('$groupName').update({
        '$colorContent': '$userStatus',
        '$colorStrikes': 0, // reset
        '$colorTimestamp': DateTime.now().millisecondsSinceEpoch,
        '$seatKey': v
      }).catchError((onErrorGroups) {
        print(onErrorGroups);
      });
    }).catchError((onErrorVacancies) {
      print(onErrorVacancies);
    });
  }

  // Create new user data
  void createUser(uuid) {
    // Create user data that links to that group and color
    firebaseRTDB.child('dporians').child('$uuid').set({
      'boots': 0,
      'bootstamp': DateTime.now().millisecondsSinceEpoch,
      'color': 'black',
      'group': 'none',
      'striked': 'never have i ever'
    }).then((_) {
      // update the live stats for devices detected
      firebaseRTDB
          .child('statistics')
          .update({'devices': devicesDetected + 1}).catchError((onErrorGroups) {
        print(onErrorGroups);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  // Get user info
  void getUser(dporian) {
    firebaseRTDB
        .child('dporians')
        .child('$dporian')
        .once()
        .then((DataSnapshot snapshot) {
      Map<String, dynamic> userMap =
          new Map<String, dynamic>.from(snapshot.value);
      var userDetails = Dporian.fromJson(userMap);
      setState(() {
        userBoots = userDetails.boots;
        userBootstamp = userDetails.bootstamp;
        userColorString = userDetails.color;
        groupName = userDetails.group;
        strikedContent = userDetails.striked;
        registered = true;
      });
    }).catchError((onError) {
      print(onError);
      setState(() {
        registered = false;
      });
    });
  }

  // Update the mutee's strike count and possibly boot count too
  void muteButtonPress(groupOfMutedUser, colorOfMutedUser, muteCount, crement) {
    // Convert Color to String
    String _colorStriked = '';
    if (colorOfMutedUser == Colors.blueAccent) {
      _colorStriked = 'blue-strikes';
    } else if (colorOfMutedUser == Colors.greenAccent) {
      _colorStriked = 'green-strikes';
    } else if (colorOfMutedUser == Colors.orangeAccent) {
      _colorStriked = 'orange-strikes';
    } else if (colorOfMutedUser == Colors.purpleAccent) {
      _colorStriked = 'purple-strikes';
    } else if (colorOfMutedUser == Colors.redAccent) {
      _colorStriked = 'red-strikes';
    }
    // Increment mute/strike counter for group member
    if (crement == 'increment') {
      firebaseRTDB
          .child('groups/$groupOfMutedUser/$_colorStriked')
          //.update({something:somethingElse})
          .set(ServerValue.increment(1))
          .then((_) {
        // show snackbar about muting action
        rootScaffoldMessengerKey.currentState
            .showSnackBar(snackBarMutedUser);
      }).catchError((onIncrementError) {
        print(onIncrementError);
      });
    } else {
      firebaseRTDB
          .child('groups/$groupOfMutedUser/$_colorStriked')
          //.update({something:somethingElse})
          .set(ServerValue.increment(-1))
          .then((_) {
        // Show snackbar about unmuting action
        rootScaffoldMessengerKey.currentState
            .showSnackBar(snackBarUnmutedUser);
      }).catchError((onIncrementError) {
        print(onIncrementError);
      });
    }

    // Also increment boot count
    //if (muteCount == 4) {
    // find mutee in dporian list using groupOfMutedUser
    // and _colorString and increment their boot count
    // based on relative number of myGroupVacancies
    //}
  }

  // Pick a stimulus
  void getStimulus(stimuliCategory, stimulusID) {
    firebaseRTDB
        .child('stimuli')
        .child('$stimuliCategory')
        .child('$stimulusID')
        .once()
        .then((DataSnapshot snapshot) {
      Map<String, dynamic> stimulusMap =
          new Map<String, dynamic>.from(snapshot.value);
      var stimulusDetails = Stimulus.fromJson(stimulusMap);
      setState(() {
        nextStimulusContent = stimulusDetails.stimulus;
      });
    });
  }

  // Ge the stimuli catetory instructions
  void getInstructions() {
    firebaseRTDB.child('instructions').once().then((DataSnapshot snapshot) {
      Map<String, dynamic> instructMap =
          new Map<String, dynamic>.from(snapshot.value);
      var categoryInstructions = Instruct.fromJson(instructMap);
      setState(() {
        instructAds = categoryInstructions.ads;
        instructDebates = categoryInstructions.debates;
        instructGames = categoryInstructions.games;
        instructJokes = categoryInstructions.jokes;
        instructMyths = categoryInstructions.myths;
        instructNews = categoryInstructions.news;
        instructPassion = categoryInstructions.passion;
        instructPersonal = categoryInstructions.personal;
        instructPonder = categoryInstructions.ponder;
        instructProverbs = categoryInstructions.proverbs;
        instructQuotes = categoryInstructions.quotes;
        instructShare = categoryInstructions.share;
        instructTrivia = categoryInstructions.trivia;
      });
    });
  }

  void strikedStimulus(uuid, neededStrikes) {
    // Show next if 3 strikes in a full group
    if (stimulusStrikes > 1 && myGroupVacancy == 0) {
      firebaseRTDB.child('groups').child('$groupName').update({
        'stimulus-category': '$categoryChoice',
        'stimulus-content': '$nextStimulusContent',
        'stimulus-instructions': '$instructStimulus',
        'stimulus-strikes': 0
      }).then((_) {
        // show success
        rootScaffoldMessengerKey.currentState
            .showSnackBar(snackBarNextStimulus);
      }).catchError((onErrorNext) {
        print(onErrorNext);
      });
      // Show next if 2 strikes in not a full group
    } else if (stimulusStrikes > 0 && myGroupVacancy != 0) {
      firebaseRTDB.child('groups').child('$groupName').update({
        'stimulus-category': '$categoryChoice',
        'stimulus-content': '$nextStimulusContent',
        'stimulus-instructions': '$instructStimulus',
        'stimulus-strikes': 0
      }).then((_) {
        // show success
        rootScaffoldMessengerKey.currentState
            .showSnackBar(snackBarNextStimulus);
      }).catchError((onErrorNext) {
        print(onErrorNext);
      });
    } else {
      // Increment the counter
      int striked = stimulusStrikes + 1;
      // Update DB
      firebaseRTDB
          .child('groups')
          .child('$groupName')
          .update({'stimulus-strikes': striked}).then((_) {
        // Note this user striked that content to prevent
        // multiple strikes on same content by same user
        firebaseRTDB
            .child('dporians')
            .child('$uuid')
            .update({'striked': stimulusContent}).catchError((onErrorGroups) {
          print(onErrorGroups);
        });
        // Inform that more strikes are needed
        if (neededStrikes == 2) {
          rootScaffoldMessengerKey.currentState
              .showSnackBar(snackBarNeeds2Strikes);
        } else {
          rootScaffoldMessengerKey.currentState
              .showSnackBar(snackBarNeeds3Strikes);
        }
      }).catchError((onErrorStriked) {
        print(onErrorStriked);
      });
    }
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
      instructStimulus = instructAds;
    } else {
      _startTotal = _endTotal;
      _endTotal = _endTotal + totalDebates;
      if (dieRoll >= _startTotal && dieRoll < _endTotal) {
        categoryChoice = 'debates';
        instructStimulus = instructDebates;
      } else {
        _startTotal = _endTotal;
        _endTotal = _endTotal + totalGames;
        if (dieRoll >= _startTotal && dieRoll < _endTotal) {
          categoryChoice = 'games';
          instructStimulus = instructGames;
        } else {
          _startTotal = _endTotal;
          _endTotal = _endTotal + totalJokes;
          if (dieRoll >= _startTotal && dieRoll < _endTotal) {
            categoryChoice = 'jokes';
            instructStimulus = instructJokes;
          } else {
            _startTotal = _endTotal;
            _endTotal = _endTotal + totalMyths;
            if (dieRoll >= _startTotal && dieRoll < _endTotal) {
              categoryChoice = 'myths';
              instructStimulus = instructMyths;
            } else {
              _startTotal = _endTotal;
              _endTotal = _endTotal + totalNews;
              if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                categoryChoice = 'news';
                instructStimulus = instructNews;
              } else {
                _startTotal = _endTotal;
                _endTotal = _endTotal + totalPassion;
                if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                  categoryChoice = 'passion';
                  instructStimulus = instructPassion;
                } else {
                  _startTotal = _endTotal;
                  _endTotal = _endTotal + totalPersonal;
                  if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                    categoryChoice = 'personal';
                    instructStimulus = instructPersonal;
                  } else {
                    _startTotal = _endTotal;
                    _endTotal = _endTotal + totalPonder;
                    if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                      categoryChoice = 'ponder';
                      instructStimulus = instructPonder;
                    } else {
                      _startTotal = _endTotal;
                      _endTotal = _endTotal + totalProverbs;
                      if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                        categoryChoice = 'proverbs';
                        instructStimulus = instructProverbs;
                      } else {
                        _startTotal = _endTotal;
                        _endTotal = _endTotal + totalQuotes;
                        if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                          categoryChoice = 'quotes';
                          instructStimulus = instructQuotes;
                        } else {
                          _startTotal = _endTotal;
                          _endTotal = _endTotal + totalShare;
                          if (dieRoll >= _startTotal && dieRoll < _endTotal) {
                            categoryChoice = 'share';
                            instructStimulus = instructShare;
                          } else {
                            //if dieRoll >= _endTotal
                            categoryChoice = 'trivia';
                            instructStimulus = instructTrivia;
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

// Relay all the group content
  void getContent(groupID) {
    firebaseRTDB
        .child('groups')
        .child('$groupID')
        .once()
        .then((DataSnapshot snapshot) {
      Map<String, dynamic> groupMap =
          new Map<String, dynamic>.from(snapshot.value);
      var groupDetails = Content.fromJson(groupMap);
      setState(() {
        blueContent = groupDetails.blueContent;
        blueStrikes = groupDetails.blueStrikes;
        blueTimestamp = groupDetails.blueTimestamp;
        blueVacancy = groupDetails.blueVacancy;
        greenContent = groupDetails.greenContent;
        greenStrikes = groupDetails.greenStrikes;
        greenTimestamp = groupDetails.greenTimestamp;
        greenVacancy = groupDetails.greenVacancy;
        orangeContent = groupDetails.orangeContent;
        orangeStrikes = groupDetails.orangeStrikes;
        orangeTimestamp = groupDetails.orangeTimestamp;
        orangeVacancy = groupDetails.orangeVacancy;
        purpleContent = groupDetails.purpleContent;
        purpleStrikes = groupDetails.purpleStrikes;
        purpleTimestamp = groupDetails.purpleTimestamp;
        purpleVacancy = groupDetails.purpleVacancy;
        redContent = groupDetails.redContent;
        redStrikes = groupDetails.redStrikes;
        redTimestamp = groupDetails.redTimestamp;
        redVacancy = groupDetails.redVacancy;
        stimulusCategory = groupDetails.stimulusCategory;
        stimulusContent = groupDetails.stimulusContent;
        stimulusInstructions = groupDetails.stimulusInstructions;
        stimulusStrikes = groupDetails.stimulusStrikes;
      });
    });
  }

  // Assign chat content and colors to their boxes
  void assignChatBoxes(userColorString) {
    if (userColorString == 'blue') {
      setState(() {
        userColor = Colors.blueAccent;
        tileTextLT = orangeContent;
        textColorLT = Colors.orangeAccent;
        postTimeLT = orangeTimestamp;
        tileVacancyLT = orangeVacancy;
        muteCountLT = orangeStrikes;
        tileTextLB = greenContent;
        textColorLB = Colors.greenAccent;
        postTimeLB = greenTimestamp;
        tileVacancyLB = greenVacancy;
        muteCountLB = greenStrikes;
        tileTextRT = purpleContent;
        textColorRT = Colors.purpleAccent;
        postTimeRT = purpleTimestamp;
        tileVacancyRT = purpleVacancy;
        muteCountRT = purpleStrikes;
        tileTextRB = redContent;
        textColorRB = Colors.redAccent;
        postTimeRB = redTimestamp;
        tileVacancyRB = redVacancy;
        muteCountRB = redStrikes;
      });
    } else if (userColorString == 'green') {
      setState(() {
        userColor = Colors.greenAccent;
        tileTextLT = orangeContent;
        textColorLT = Colors.orangeAccent;
        postTimeLT = orangeTimestamp;
        tileVacancyLT = orangeVacancy;
        muteCountLT = orangeStrikes;
        tileTextLB = blueContent;
        textColorLB = Colors.blueAccent;
        postTimeLB = blueTimestamp;
        tileVacancyLB = blueVacancy;
        muteCountLB = blueStrikes;
        tileTextRT = purpleContent;
        textColorRT = Colors.purpleAccent;
        postTimeRT = purpleTimestamp;
        tileVacancyRT = purpleVacancy;
        muteCountRT = purpleStrikes;
        tileTextRB = redContent;
        textColorRB = Colors.redAccent;
        postTimeRB = redTimestamp;
        tileVacancyRB = redVacancy;
        muteCountRB = redStrikes;
      });
    } else if (userColorString == 'orange') {
      setState(() {
        userColor = Colors.orangeAccent;
        tileTextLT = greenContent;
        textColorLT = Colors.greenAccent;
        postTimeLT = greenTimestamp;
        tileVacancyLT = greenVacancy;
        muteCountLT = greenStrikes;
        tileTextLB = blueContent;
        textColorLB = Colors.blueAccent;
        postTimeLB = blueTimestamp;
        tileVacancyLB = blueVacancy;
        muteCountLB = blueStrikes;
        tileTextRT = purpleContent;
        textColorRT = Colors.purpleAccent;
        postTimeRT = purpleTimestamp;
        tileVacancyRT = purpleVacancy;
        muteCountRT = purpleStrikes;
        tileTextRB = redContent;
        textColorRB = Colors.redAccent;
        postTimeRB = redTimestamp;
        tileVacancyRB = redVacancy;
        muteCountRB = redStrikes;
      });
    } else if (userColorString == 'purple') {
      setState(() {
        userColor = Colors.purpleAccent;
        tileTextLT = orangeContent;
        textColorLT = Colors.orangeAccent;
        postTimeLT = orangeTimestamp;
        tileVacancyLT = orangeVacancy;
        muteCountLT = orangeStrikes;
        tileTextLB = blueContent;
        textColorLB = Colors.blueAccent;
        postTimeLB = blueTimestamp;
        tileVacancyLB = blueVacancy;
        muteCountLB = blueStrikes;
        tileTextRT = greenContent;
        textColorRT = Colors.greenAccent;
        postTimeRT = greenTimestamp;
        tileVacancyRT = greenVacancy;
        muteCountRT = greenStrikes;
        tileTextRB = redContent;
        textColorRB = Colors.redAccent;
        postTimeRB = redTimestamp;
        tileVacancyRB = redVacancy;
        muteCountRB = redStrikes;
      });
    } else if (userColorString == 'red') {
      setState(() {
        userColor = Colors.redAccent;
        tileTextLT = orangeContent;
        textColorLT = Colors.orangeAccent;
        postTimeLT = orangeTimestamp;
        tileVacancyLT = orangeVacancy;
        muteCountLT = orangeStrikes;
        tileTextLB = blueContent;
        textColorLB = Colors.blueAccent;
        postTimeLB = blueTimestamp;
        tileVacancyLB = blueVacancy;
        muteCountLB = blueStrikes;
        tileTextRT = purpleContent;
        textColorRT = Colors.purpleAccent;
        postTimeRT = purpleTimestamp;
        tileVacancyRT = purpleVacancy;
        muteCountRT = purpleStrikes;
        tileTextRB = greenContent;
        textColorRB = Colors.greenAccent;
        postTimeRB = greenTimestamp;
        tileVacancyRB = greenVacancy;
        muteCountRB = greenStrikes;
      });
    }
  }

  // Keep track of current total vacancies in group
  void myGroupVacancyStatus() {
    firebaseRTDB
        .child('vacancies')
        .child('$groupName')
        .once()
        .then((DataSnapshot pinpoint) {
      setState(() {
        myGroupVacancy = pinpoint.value;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void postComment(submitted, milli) {
    //var milli = DateTime.now().millisecondsSinceEpoch;
    String colorContent = userColorString + '-content';
    String colorTimestamp = userColorString + '-timestamp';
    firebaseRTDB.child('groups').child('$groupName').update(
        {'$colorContent': '$submitted', '$colorTimestamp': milli}).then((_) {
      // update live stats
      firebaseRTDB
          .child('statistics')
          .update({'comments': commentsPosted + 1}).then((_) {
        // unassign inactive users of the group
        var tenMinutes = 10 * 60 * 1000;
        var beingActive = milli - tenMinutes;
        if (blueTimestamp < beingActive &&
            userColorString != 'blue' &&
            blueVacancy == false) {
          updateVacancy(groupName, 'blue', myGroupVacancy, true);
        }
        if (greenTimestamp < beingActive &&
            userColorString != 'green' &&
            greenVacancy == false) {
          updateVacancy(groupName, 'green', myGroupVacancy, true);
        }
        if (orangeTimestamp < beingActive &&
            userColorString != 'orange' &&
            orangeVacancy == false) {
          updateVacancy(groupName, 'orange', myGroupVacancy, true);
        }
        if (purpleTimestamp < beingActive &&
            userColorString != 'purple' &&
            purpleVacancy == false) {
          updateVacancy(groupName, 'purple', myGroupVacancy, true);
        }
        if (redTimestamp < beingActive &&
            userColorString != 'red' &&
            redVacancy == false) {
          updateVacancy(groupName, 'red', myGroupVacancy, true);
        }
      }).catchError((onErrorStats) {
        print(onErrorStats);
      });
    }).catchError((onErrorNext) {
      print(onErrorNext);
    });
  }

  // void deleteData() {
  //   // only use if needed to surgically delete erroneous data
  //   firebaseRTDB.child('dporians/rMW_ogUVuBS14jAk_jy1').remove();
  // }

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

    // Get slogans to show in menu drawer
    getSlogans();

    // Get the latest stats to show in menu drawer
    liveStats();
    // Show live stats in menu drawer
    String liveCountries = 'Over ' +
        countriesRepresented.toString() +
        ' countries represented' +
        '\n';
    String liveDevices =
        'Over ' + devicesDetected.toString() + ' devices detected' + '\n';
    String liveComments =
        'Over ' + commentsPosted.toString() + ' comments posted' + '\n\n';
    if (version > versionHardcoded) {
      versionStatus = '(Please update to ' + version.toString() + ')\n';
    } else {
      versionStatus = '(You are up to date)\n';
    }

    // if already signed in...
    if (auth.currentUser != null) {
      // When users anonymously sign-in, here is some data captured:
      // print(auth.currentUser.uid);
      // print(auth.languageCode); null
      // print(auth.currentUser.isAnonymous); true
      // print(auth.currentUser.displayName); null if anonymous
      // print(auth.currentUser.metadata.creationTime);
      // To sign out a user, use...
      //FirebaseAuth.instance.signOut();

      // Fetch user info
      getUser(auth.currentUser.uid);

      if (registered == false) {
        createUser(auth.currentUser.uid);
      }

      if (userColorString == 'black' || groupName == 'none') {
        // User needs to be assigned to a group
        findVacantGroup();
      }

      if (groupName != '' && groupName != 'none') {
        getContent(groupName);
        // Assign comments to appropriate color boxes
        assignChatBoxes(userColorString);
        // To keep the myGroupVacancy integer updated
        myGroupVacancyStatus();
      }

      // Load all stimlui category instructions
      getInstructions();

      // Choose a category
      chooseCategory(stimuliDeck[2295]);
      // The default 2295 falls in the range of the 'share' category
      // and the default stimulus there is set to "What's on your mind?"

      // Choose a random stimulus
      randomStimulus();
    } else {
      // Show Terms of service to first time users of this app installation
      stimulusContent =
          'Tap the little yellow arrow on the right to continue, and to accept these terms of service.';
      stimulusInstructions = 'Terms of service';
      // This sets up the basic Terms and Conditions screen before login
      userColor = Colors.black; // to hide it
      tileTextLT = 'You must be 13 years old to use this app (dpora).';
      textColorLT = Colors.orangeAccent;
      tileTextLB = 'dpora does not save user-created chat content.';
      textColorLB = Colors.blueAccent;
      tileTextRT = 'dpora is not responsible for user-created chat content.';
      textColorRT = Colors.purpleAccent;
      tileTextRB =
          'dpora is not liable for any consequences attributed to the use of this app.';
      textColorRB = Colors.redAccent;
    }

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
                        // pick a slogan from the list
                        text: slogans[sNum] + '\n\n',
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
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Go to dpora.com
                  _dporaWebsite();
                  // Prep the next slogan to show
                  sNum++;
                  if (sNum == sMax) {
                    // Start over, don't exceed range
                    sNum = 0;
                  }
                  //close the drawer
                  _drawerKey.currentState.openEndDrawer();
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_support_outlined),
                title: Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Go to web-based dynamic contact form
                  _contactForm();
                  sNum++;
                  if (sNum == sMax) {
                    sNum = 0;
                  }
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
                        text: '\nHow To' + '\n\n',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '''
The topic is in yellow.

You are randomly matched with 
other people who may be anywhere  
in the world. Once a comment 
disappears, it's gone! So talk 
openly, but be respectful.

When 3 people tap the yellow arrow,
the next topic will appear. Tap the 
About link above for more info.
''',
                        style: TextStyle(
                          fontSize: 16,
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
                      TextSpan(
                        text: '\nLive Stats' + '\n\n',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: liveCountries,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: liveDevices,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: liveComments,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: platform +
                            ' Version ' +
                            versionHardcoded.toString() +
                            '\n' +
                            versionStatus,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white38,
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
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  sNum++;
                  if (sNum == sMax) {
                    sNum = 0;
                  }
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
                    userColor,
                    tileTextLT,
                    textColorLT,
                    postTimeLT,
                    tileVacancyLT,
                    muteCountLT,
                    tileTextLB,
                    textColorLB,
                    postTimeLB,
                    tileVacancyLB,
                    muteCountLB,
                    tileTextRT,
                    textColorRT,
                    postTimeRT,
                    tileVacancyRT,
                    muteCountRT,
                    tileTextRB,
                    textColorRB,
                    postTimeRB,
                    tileVacancyRB,
                    muteCountRB)
                : _buildHorizontalLayout(
                    userColor,
                    tileTextLT,
                    textColorLT,
                    postTimeLT,
                    tileVacancyLT,
                    muteCountLT,
                    tileTextLB,
                    textColorLB,
                    postTimeLB,
                    tileVacancyLB,
                    muteCountLB,
                    tileTextRT,
                    textColorRT,
                    postTimeRT,
                    tileVacancyRT,
                    muteCountRT,
                    tileTextRB,
                    textColorRB,
                    postTimeRB,
                    tileVacancyRB,
                    muteCountRB);
          },
        ),
      ),
    );
  }

  // Show the appropriate icon for each stimuli category
  Widget _icon(stimulusCategory) {
    if (stimulusCategory == 'ads') {
      return Icon(
        Icons.local_offer_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'debates') {
      return Icon(
        Icons.gavel_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'games') {
      return Icon(
        Icons.casino_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'jokes') {
      return Icon(
        Icons.emoji_emotions_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'news') {
      return Icon(
        Icons.speaker_notes_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'passion') {
      return Icon(
        Icons.thumbs_up_down_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'personal') {
      return Icon(
        Icons.emoji_people_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'ponder') {
      return Icon(
        Icons.psychology_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'proverbs') {
      return Icon(
        Icons.history_edu_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'quotes') {
      return Icon(
        Icons.format_quote_rounded,
        color: Colors.yellow,
      );
    } else if (stimulusCategory == 'share') {
      return Icon(
        Icons.group_rounded,
        color: Colors.yellow,
      );
    } else {
      // Trivia or Myths
      // Terms and Conditions
      // No Internet Connection
      return Icon(
        Icons.fact_check_rounded,
        color: Colors.yellow,
      );
    }
  }

  Widget _stimulus(textSize) {
    if (airplaneMode == true) {
      // snackbar notice if no internet connection is found
      rootScaffoldMessengerKey.currentState.showSnackBar(snackBarNoInternet);
      setState(() {
        stimulusContent = 'Please turn on mobile data, WiFi or both.';
        stimulusInstructions = 'Are you in Airplane Mode?';
      });
    }
    // instructions text is 5 points smaller than stimulus text
    double instructionSize;
    if (textSize < 30) {
      // probably vertical view
      instructionSize = textSize - 4;
    } else {
      // probably horizontal view
      instructionSize = textSize / 2;
    }
    // Hide non-essential icons from non-authenicated users
    if (auth.currentUser == null) {
      iconColor = boxBGColor;
    }
    // Calculute how many strikes are needed to show next stimulus
    if (myGroupVacancy != 0) {
      // No group or not a full group
      strikesNeeded = 2;
    } else {
      // It's a full group
      strikesNeeded = 3;
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
                    Share.share(stimulusContent + ' \nΦ dpora.com',
                        subject: stimulusInstructions);
                  },
                ),
              ),
              // TODO: add Change Group feature later, when
              // there are always a few live groups to switch to
              // child: IconButton(
              //   icon: Icon(
              //     Icons.threesixty_rounded,
              //     color: iconColor,
              //   ),
              //   padding: EdgeInsets.zero, // need for alignment
              //   tooltip: 'New Group & Topic',
              //   onPressed: () {},
              // //set dporian groupName to 'none' and update vacancies and group data
              // ),
              // SizedBox(
              //   height: 20.0,
              //   width: 20.0,
              //   child: IconButton(
              //     icon: Icon(
              //       Icons.not_interested_rounded,
              //       color: iconColor,
              //     ),
              //     padding: EdgeInsets.zero, // need for alignment
              //     tooltip: 'Something is wrong!',
              //     onPressed: () {
              //       // TODO: stimulus is offensive, misspelled, incorrect, outdated,
              //       // dumb, etc. The simpliest solution is to url over to a web form
              //     },
              //   ),
              // ),
            ]),
        // Stimulus is displayed here
        Flexible(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
            child: Text(
              stimulusContent,
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
              _icon(stimulusCategory), // Shows the appropriate icon
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
                  stimulusInstructions,
                  style: TextStyle(
                    fontSize: instructionSize,
                    color: Colors.yellow, //yellowAccent is too bright
                  ),
                ),
              ),
              Row(children: [
                Text(
                  'Next',
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
                      if (auth.currentUser != null) {
                        if (strikedContent == stimulusContent) {
                          if (strikesNeeded == 2) {
                            rootScaffoldMessengerKey.currentState
                                .showSnackBar(snackBarNeeds2Strikes);
                          } else {
                            rootScaffoldMessengerKey.currentState
                                .showSnackBar(snackBarNeeds3Strikes);
                          }
                        } else {
                          // shuffle category and stimulus decks
                          shuffleDecks();
                          // update stimulus strike count or stimulus
                          strikedStimulus(auth.currentUser.uid, strikesNeeded);
                        }
                      } else {
                        // Otherwise, sign the user in anonymously
                        signInAnonymously();
                        if (registered == false) {
                          createUser(auth.currentUser.uid);
                        }
                      }
                    },
                  ),
                ),
                Text(
                  stimulusStrikes.toString() + '/' + strikesNeeded.toString(),
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

  Widget _userInput(userColor) {
    int _timeUntilFade = 20;
    int _fadeDuration = 10;
    double clearIconSize = 14.0;
    int maxCharacters = 100;
    if (auth.currentUser == null) {
      boxBGColor = Colors.black;
      clearIconSize = 0.0;
      maxCharacters = 1;
    }
    return TextField(
        controller: inputController,
        // TODO: Verify backspace works in real android app
        // because it doesn't work on Chromebook test build.
        style: TextStyle(color: userColor),
        cursorColor: userColor,
        // show Send instead of Enter with onscreen keyboards
        textInputAction: TextInputAction.send,
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
            onPressed: () {
              inputController.clear();
            },
            icon: Icon(
              Icons.clear,
              size: clearIconSize,
            ),
          ),
        ),
        maxLength: maxCharacters,
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
            // post to group
            int milli = DateTime.now().millisecondsSinceEpoch;
            postComment(submittedText, milli);
            // clear text in input box
            inputController.clear();
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

  Widget _chatTile(tileHeight, tileWidth, textSize, tileText, textColor,
      postTime, tileVacancy, muteCount) {
    String muteStatus = '';
    // If tile is vacant, don't show its color
    Color _iconColor = iconColor;
    // If tile is muted, don't show its contents
    Color _textColor = textColor;
    if (tileVacancy == true) {
      if (auth.currentUser != null) {
        // hide chat text but not Terms of service
        _textColor = boxBGColor;
      }
      _iconColor = boxBGColor;
    } else {
      // Make icons visable again, if user not muted
      if (colorOfMutedUser != textColor) {
        _iconColor = iconColor;
        _textColor = textColor; // unmute
      } else {
        _iconColor = Colors.grey;
        _textColor = boxBGColor; // mute
      }
      if (postTime != null) {
        chatOpacity = 1.0;
        int timeElapsed = DateTime.now().millisecondsSinceEpoch - postTime;
        // Start fading text if it was posted more than 30 seconds ago
        int twentySeconds = 20 * 1000;
        // Fade action only occurs to chat text, not Terms of service
        if (timeElapsed > twentySeconds && auth.currentUser != null) {
          chatFadeTime = 10; // show fade out
          chatOpacity = 0.0;
        } else {
          chatFadeTime = 1; // quick fade in
          chatOpacity = 1.0;
        }
        // Show literal mute status
        if (muteCount == 0) {
          muteStatus = 'Group never muted';
        } else if (muteCount == 1) {
          muteStatus = 'Group muted once';
        } else if (muteCount == 2) {
          muteStatus = 'Group muted twice';
        } else if (muteCount == 3) {
          muteStatus = 'Group muted thrice';
        } else if (muteCount == 4) {
          muteStatus = 'Whole group muted';
        }
        // Unmute new member if assigned to a muted color tile
        if (muteCount == 0 && _iconColor == Colors.grey) {
          muteStatus = 'Unmute new user!';
          _textColor = textColor; // unmuted
        }
      }
    }

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
                style: TextStyle(fontSize: textSize, color: _textColor),
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
                  color: _iconColor,
                ),
                padding: EdgeInsets.zero, // need for alignment
                tooltip: 'Toggle Mute Status',
                onPressed: () {
                  if (groupName == groupOfMutedUser) {
                    // Decrement, if possible
                    if (muteCount > 0) {
                      muteButtonPress(groupOfMutedUser, colorOfMutedUser,
                          muteCount, 'decrement');
                    }
                    // Make content visable but update the DB
                    // first before the variables are reset
                    setState(() {
                      groupOfMutedUser = ''; // reset
                      colorOfMutedUser = boxBGColor; // reset
                    });
                  } else {
                    // set the variables before updating the DB
                    setState(() {
                      groupOfMutedUser = groupName;
                      colorOfMutedUser = textColor;
                    });
                    // Increment, if possible
                    if (muteCount < 4) {
                      muteButtonPress(groupOfMutedUser, colorOfMutedUser,
                          muteCount, 'increment');
                    }
                  }
                },
              ),
            ),
            // spacer box
            SizedBox(
              height: 5.0,
              width: 8.0,
            ),
            Text(
              muteStatus,
              style: TextStyle(
                fontSize: textSize - 4,
                color: _iconColor,
              ),
            ),
          ],
        ),
        //]),
      ]),
    );
  }

  Widget _buildVerticalLayout(
      userColor,
      tileTextLT,
      textColorLT,
      postTimeLT,
      tileVacancyLT,
      muteCountLT,
      tileTextLB,
      textColorLB,
      postTimeLB,
      tileVacancyLB,
      muteCountLB,
      tileTextRT,
      textColorRT,
      postTimeRT,
      tileVacancyRT,
      muteCountRT,
      tileTextRB,
      textColorRB,
      postTimeRB,
      tileVacancyRB,
      muteCountRB) {
    final allTileHeight = 0.2; // 20% screen height
    final allTileWidth = 0.45; // 45% screen width
    final allTextSize = 18.0; // 18 font size for chatters
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.23, //23%
          width: MediaQuery.of(context).size.width, //100%
          child: _stimulus(20.0), // stimulus text size
        ),
        // build the chat titles, the left column (top & bottom) and right
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextLT,
                    textColorLT, postTimeLT, tileVacancyLT, muteCountLT),
                _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextLB,
                    textColorLB, postTimeLB, tileVacancyLB, muteCountLB),
              ],
            ),
            Column(
              children: [
                _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextRT,
                    textColorRT, postTimeRT, tileVacancyRT, muteCountRT),
                _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextRB,
                    textColorRB, postTimeRB, tileVacancyRB, muteCountRB),
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
          child: _userInput(userColor),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(
      userColor,
      tileTextLT,
      textColorLT,
      postTimeLT,
      tileVacancyLT,
      muteCountLT,
      tileTextLB,
      textColorLB,
      postTimeLB,
      tileVacancyLB,
      muteCountLB,
      tileTextRT,
      textColorRT,
      postTimeRT,
      tileVacancyRT,
      muteCountRT,
      tileTextRB,
      textColorRB,
      postTimeRB,
      tileVacancyRB,
      muteCountRB) {
    final allTileHeight = 0.33; // 33% screen height
    final allTileWidth = 0.21; // 21% screen width
    final allTextSize = 26.0; // 26 font size for chatters
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
                child: _stimulus(32.0), // stimulus text size
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
                          postTimeLT,
                          tileVacancyLT,
                          muteCountLT),
                      _chatTile(
                          allTileHeight,
                          allTileWidth,
                          allTextSize,
                          tileTextLB,
                          textColorLB,
                          postTimeLB,
                          tileVacancyLB,
                          muteCountLB),
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
                          postTimeRT,
                          tileVacancyRT,
                          muteCountRT),
                      _chatTile(
                          allTileHeight,
                          allTileWidth,
                          allTextSize,
                          tileTextRB,
                          textColorRB,
                          postTimeRB,
                          tileVacancyRB,
                          muteCountRB),
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
        child: _userInput(userColor),
      ),
    ]);
  }
}
