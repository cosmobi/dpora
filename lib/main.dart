import 'package:flutter/material.dart';
import 'dart:async';
import 'local_import.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity/connectivity.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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

// If mobile data and/or wifi are turned off then tell the
// user (as a stimulus and snackbar) to turn on one or both.
bool airplaneMode = false;
void checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    airplaneMode = true;
  } else {
    airplaneMode = false;
  }
}

// Default app-wide colors
Color boxBGColor = Colors.grey[900];
// Hide non-essential icons from non-authenicated users
Color iconColor = Colors.grey[900];

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

// Use to update some data daily or on relaunch
int dataDownloaded = DateTime.now().millisecondsSinceEpoch;
int oneDay = 24 * 60 * 60 * 1000;
// hours * minutes * seconds * 1 second of milliseconds

// Use this key to open and close drawer
// programically (in addition to swiping)
GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

// Code needed for snackbars
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
bool waitStatus = false;
// Snackbar Notifications
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
final snackBarModelDownloading = SnackBar(
  content: const Text('Language engine loading. Please wait...'),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    ),
  ),
  backgroundColor: Colors.yellow,
  duration: const Duration(seconds: 30),
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
              'new device',
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

  // For on-device translation using Google's ML Kit
  final _languageModelManager = GoogleMlKit.nlp.translateLanguageModelManager();
  var _onDeviceToEnglishTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: TranslateLanguage.ENGLISH,
      targetLanguage: TranslateLanguage.ENGLISH);
  var _onDeviceFromEnglishTranslator = GoogleMlKit.nlp.onDeviceTranslator(
      sourceLanguage: TranslateLanguage.ENGLISH,
      targetLanguage: TranslateLanguage.ENGLISH);

  Future<void> downloadModel() async {
    var result = await _languageModelManager.downloadModel('en');
    print('Model downloaded: $result');
    result = await _languageModelManager.downloadModel(selectedLanguageCode);
    print('Model downloaded: $result');
  }

  Future<void> isModelDownloaded() async {
    var result = await _languageModelManager.isModelDownloaded('en');
    print('Is model downloaded: $result');
    if (result == false) {
      rootScaffoldMessengerKey.currentState
          .showSnackBar(snackBarModelDownloading);
    }
    result =
        await _languageModelManager.isModelDownloaded(selectedLanguageCode);
    print('Is model downloaded: $result');
    if (result == false) {
      rootScaffoldMessengerKey.currentState
          .showSnackBar(snackBarModelDownloading);
    }
  }

  Future<void> translateToEnglish() async {
    var result =
        await _onDeviceToEnglishTranslator.translateText(submittedText);
    setState(() {
      translatedToEnglish = result;
    });
  }

  Future<void> translateFromEnglish(textContent) async {
    if (textContent == 'stimulus') {
      var result =
          await _onDeviceFromEnglishTranslator.translateText(stimulusContent);
      setState(() {
        translatedStimulus = result;
      });
    }
    if (textContent == 'instructions') {
      var result = await _onDeviceFromEnglishTranslator
          .translateText(stimulusInstructions);
      setState(() {
        translatedInstructions = result;
      });
    }
  }

  // Get slogans to display in the menu drawer
  void getSlogans() {
    if (gotSlogans == false) {
      firebaseRTDB.child('slogans').once().then((DataSnapshot snapshot) {
        List<String> sloganList = new List<String>.from(snapshot.value);
        setState(() {
          slogans = sloganList;
          sMax = sloganList.length;
          gotSlogans = true;
        });
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  // Update the tally in the menu drawer
  void liveTally() {
    if (deadTally == false) {
      firebaseRTDB.child('tally').once().then((DataSnapshot snapshot) {
        Map<String, dynamic> statMap =
            new Map<String, dynamic>.from(snapshot.value);
        var liveStatistics = Tally.fromJson(statMap);
        setState(() {
          commentsPosted = liveStatistics.comments;
          countriesRepresented = liveStatistics.countries;
          devicesDetected = liveStatistics.devices;
          latestVersion = liveStatistics.version;
          minReqVersion = liveStatistics.minreq;
          deadTally = true;
        });
      });
    }
  }

  // Find or create a group that has a vacancy
  void findVacantGroup() {
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
        assignVacantColor(key4);
      } else if (key3 != null) {
        assignVacantColor(key3);
      } else if (key2 != null) {
        assignVacantColor(key2);
      } else if (key1 != null) {
        assignVacantColor(key1);
      } else if (key5 != null) {
        // empty group, assign first person there
        assignVacantColor(key5);
      } else {
        // new group is needed, first create a new group name/uid
        var newGroupName = firebaseRTDB.child('groups').push().key;
        // Now use this to add the key/value pairs
        firebaseRTDB.child('groups').child('$newGroupName').set({
          'bc': '',
          'bs': 0,
          'bt': ServerValue.timestamp,
          'bv': true,
          'gc': '',
          'gs': 0,
          'gt': ServerValue.timestamp,
          'gv': true,
          'oc': '',
          'os': 0,
          'ot': ServerValue.timestamp,
          'ov': true,
          'pc': '',
          'ps': 0,
          'pt': ServerValue.timestamp,
          'pv': true,
          'rc': '',
          'rs': 0,
          'rt': ServerValue.timestamp,
          'rv': true,
          'scat': 'personal',
          'sc': 'What would you like to talk about?',
          'si': 'All about you',
          'ss': 0
        }).then((_) {
          // add the new group to the vacancies node
          firebaseRTDB
              .child('vacancies')
              .set({'$newGroupName': 5}).catchError((onError) {
            print(onError);
          });
        });
        // And now assign a vacant seat in the new group
        assignVacantColor(newGroupName);
      }
    });
  }

  void assignVacantColor(grouper) {
    // Looking for a vacant color (an open seat)
    var seatColor = ''; // The color in that group
    firebaseRTDB
        .child('groups')
        .child('$grouper')
        .once()
        .then((DataSnapshot snapshotColors) {
      var colorVacancies = new Map<String, dynamic>.from(snapshotColors.value);
      var blueSeat = colorVacancies['bv'];
      var greenSeat = colorVacancies['gv'];
      var orangeSeat = colorVacancies['ov'];
      var purpleSeat = colorVacancies['pv'];
      var redSeat = colorVacancies['rv'];
      if (blueSeat == true) {
        seatColor = 'blue';
      } else {
        if (greenSeat == true) {
          seatColor = 'green';
        } else {
          if (orangeSeat == true) {
            seatColor = 'orange';
          } else {
            if (redSeat == true) {
              seatColor = 'red';
            } else {
              if (purpleSeat == true) {
                seatColor = 'purple';
              }
            }
          }
        }
      }
      // double-check this user still (definately) needs a seat
      if (userColorString == 'black' || groupName == 'none') {
        // Then assign the open seat (group and color) to the user
        firebaseRTDB
            .child('dporians')
            .child(auth.currentUser.uid)
            .update({'c': '$seatColor', 'g': '$grouper'}).then((_) {
          // update group vacancy status
          updateVacancy(seatColor, false);
        }).catchError((onAssignError) {
          print(onAssignError);
        });
      }
    }).catchError((onCheckError) {
      print(onCheckError);
    });
  }

  void updateVacancy(seatColor, v) {
    // prep the variables
    String sC = '';
    if (seatColor == 'blue') {
      sC = 'b';
    }
    if (seatColor == 'green') {
      sC = 'g';
    }
    if (seatColor == 'orange') {
      sC = 'o';
    }
    if (seatColor == 'purple') {
      sC = 'p';
    }
    if (seatColor == 'red') {
      sC = 'r';
    }
    String colorContent = sC + 'c';
    String colorStrikes = sC + 's';
    String colorTimestamp = sC + 't';
    String seatKey = sC + 'v';
    String userStatus = '';
    if (v == false) {
      userStatus = '[ new ' + seatColor + ' ]';
    } else {
      // A user unassigns someone else from group
      updateUser(groupName, seatColor, 'group');
    }
    // Update the vacancy in groups node
    firebaseRTDB.child('groups').child('$groupName').update({
      '$colorContent': '$userStatus',
      '$colorStrikes': 0, // reset
      '$colorTimestamp': ServerValue.timestamp,
      '$seatKey': v
    }).then((_) {
      if (v == false) {
        // decrement group vacancy total immediately
        firebaseRTDB.child('vacancies').update(
            {'$groupName': ServerValue.increment(-1)}).catchError((onErrorSit) {
          print(onErrorSit);
        });
      }
    }).catchError((onErrorUpdateGroups) {
      print(onErrorUpdateGroups);
    });
  }

  void vacancyCount(groupie) {
    firebaseRTDB
        .child('dporians')
        .orderByChild('g')
        .equalTo('$groupie')
        .once()
        .then((DataSnapshot snapshot) {
      int memberCount = 0;
      var myGroupMembers = new Map<String, dynamic>.from(snapshot.value);
      for (var entry in myGroupMembers.entries) {
        if (entry.value['c'] != 'black') {
          memberCount++;
        }
      }
      int vacancyCount = 5 - memberCount;
      // Update group's vacancy count
      firebaseRTDB.child('vacancies').update(
          {'$groupie': vacancyCount}).catchError((onErrorUpdateVacancies) {
        print(onErrorUpdateVacancies);
      });
    }).catchError((onErrorCheckGroups) {
      print(onErrorCheckGroups);
    });
  }

  // Seek and destroy ghosts occupying vacancies
  void ghostBusters(myGroup) {
    if (ghostBusted == false) {
      // Seek all real group members
      bool blueMember = false;
      bool greenMember = false;
      bool orangeMember = false;
      bool purpleMember = false;
      bool redMember = false;
      firebaseRTDB
          .child('dporians')
          .orderByChild('g')
          .equalTo('$myGroup')
          .once()
          .then((DataSnapshot snapshot) {
        var myGroupMembers = new Map<String, dynamic>.from(snapshot.value);
        for (var entry in myGroupMembers.entries) {
          if (entry.value['c'] == 'blue') {
            blueMember = true;
          }
          if (entry.value['c'] == 'green') {
            greenMember = true;
          }
          if (entry.value['c'] == 'orange') {
            orangeMember = true;
          }
          if (entry.value['c'] == 'purple') {
            purpleMember = true;
          }
          if (entry.value['c'] == 'red') {
            redMember = true;
          }
        }
        // Destroy all ghost group members
        if (blueMember == false) {
          firebaseRTDB
              .child('groups')
              .child('$myGroup')
              .update({'bv': true}).catchError((onDestroyError) {
            print(onDestroyError);
          });
        }
        if (greenMember == false) {
          firebaseRTDB
              .child('groups')
              .child('$myGroup')
              .update({'gv': true}).catchError((onDestroyError) {
            print(onDestroyError);
          });
        }
        if (orangeMember == false) {
          firebaseRTDB
              .child('groups')
              .child('$myGroup')
              .update({'ov': true}).catchError((onDestroyError) {
            print(onDestroyError);
          });
        }
        if (purpleMember == false) {
          firebaseRTDB
              .child('groups')
              .child('$myGroup')
              .update({'pv': true}).catchError((onDestroyError) {
            print(onDestroyError);
          });
        }
        if (redMember == false) {
          firebaseRTDB
              .child('groups')
              .child('$myGroup')
              .update({'rv': true}).catchError((onDestroyError) {
            print(onDestroyError);
          });
        }
      }).catchError((onSeekError) {
        print(onSeekError);
      });
      // delete colorless entities
      firebaseRTDB.child('groups').child('$myGroup').child('c').remove();
      firebaseRTDB.child('groups').child('$myGroup').child('s').remove();
      firebaseRTDB.child('groups').child('$myGroup').child('t').remove();
      firebaseRTDB.child('groups').child('$myGroup').child('v').remove();
      // delete group called 'none'
      firebaseRTDB.child('groups').child('none').remove();
      // don't continuously do this
      setState(() {
        ghostBusted = true;
      });
    }
  }

  // Create new user data
  void createUser(uuid) {
    firebaseRTDB.child('dporians').child('$uuid').set({
      'b': 0,
      't': ServerValue.timestamp,
      'c': 'black',
      'g': 'none',
      's': 'never'
    }).then((_) {
      firebaseRTDB.child('tally').update(
          {'devices': ServerValue.increment(1)}).catchError((onNewError) {
        print(onNewError);
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  // Check if user exists in DB or create one
  void checkUser(dporian) {
    if (checkedUser == false) {
      firebaseRTDB
          .child('dporians')
          .child('$dporian')
          .once()
          .then((DataSnapshot snappy) {
        Map<String, dynamic> userChecker =
            new Map<String, dynamic>.from(snappy.value);
        var gotUser = Dporian.fromJson(userChecker);
        if (gotUser.boots != null) {
          // User exists
          setState(() {
            checkedUser = true;
            registered = true;
          });
        }
      }).catchError((onError) {
        // User does not exist
        print(onError);
        // Add user, if not already
        createUser(dporian);
      });
    }
  }

  // Get user info
  void getUser(dporian) {
    firebaseRTDB.child('dporians').child('$dporian').onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<String, dynamic> userMap =
          new Map<String, dynamic>.from(snapshot.value);
      var userDetails = Dporian.fromJson(userMap);
      setState(() {
        userBoots = userDetails.boots;
        userBootstamp = userDetails.bootstamp;
        userColorString = userDetails.color;
        groupName = userDetails.group;
        strikedContent = userDetails.striked;
      });
    });
  }

  // Update the mutee's strike count and possibly boot count too
  void muteButtonPress(groupOfMutedUser, colorOfMutedUser, muteCount, crement) {
    // Convert Color to String
    String _colorString = '';
    String _cS = '';
    if (colorOfMutedUser == Colors.blueAccent) {
      _colorString = 'blue';
      _cS = 'b';
    } else if (colorOfMutedUser == Colors.greenAccent) {
      _colorString = 'green';
      _cS = 'g';
    } else if (colorOfMutedUser == Colors.orangeAccent) {
      _colorString = 'orange';
      _cS = 'o';
    } else if (colorOfMutedUser == Colors.purpleAccent) {
      _colorString = 'purple';
      _cS = 'p';
    } else if (colorOfMutedUser == Colors.redAccent) {
      _colorString = 'red';
      _cS = 'r';
    }
    String _colorStriked = _cS + 's';
    // Increment mute/strike counter for group member
    if (crement == 'increment') {
      firebaseRTDB
          .child('groups')
          .child('$groupOfMutedUser')
          .child('$_colorStriked')
          .set(ServerValue.increment(1))
          .then((_) {
        // show snackbar about muting action
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBarMutedUser);
        // if whole group muted user, increment their boot count
        if (muteCount == 3 && myGroupVacancy == 0) {
          updateUser(groupOfMutedUser, _colorString, 'boots');
        }
      }).catchError((onIncrementError) {
        print(onIncrementError);
      });
    } else {
      firebaseRTDB
          .child('groups')
          .child('$groupOfMutedUser')
          .child('$_colorStriked')
          .set(ServerValue.increment(-1))
          .then((_) {
        // Show snackbar about unmuting action
        rootScaffoldMessengerKey.currentState.showSnackBar(snackBarUnmutedUser);
      }).catchError((onDecrementError) {
        print(onDecrementError);
      });
    }
  }

  void updateUser(groupOf, colorString, updateWhat) {
    // Find all group members
    firebaseRTDB
        .child('dporians')
        .orderByChild('g')
        .equalTo('$groupOf')
        .once()
        .then((DataSnapshot snapshot) {
      var mapMembers = new Map<String, dynamic>.from(snapshot.value);
      for (var entry in mapMembers.entries) {
        // Find bootee (the one getting booted or unassigned)
        if (entry.value['c'] == colorString) {
          var bootee = entry.key;
          if (updateWhat == 'boots') {
            // Increment boot count
            firebaseRTDB.child('dporians').child('$bootee').update({
              'b': ServerValue.increment(1),
              't': ServerValue.timestamp
            }).catchError((onBootError) {
              print(onBootError);
            });
          }
          if (updateWhat == 'group') {
            // Another user unassign someone else from group
            firebaseRTDB
                .child('dporians')
                .child('$bootee')
                .update({'c': 'black', 'g': 'none'}).catchError((onGroupError) {
              print(onGroupError);
            });
          }
        }
      }
    }).catchError((onFindError) {
      print(onFindError);
    });
  }

  // Pick a new stimulus
  void getStimulus(stimuliCategory, stimulusID) {
    // only if one more strike is needed and
    // if the user needs a new stimulus queued
    if (strikesNeeded - stimulusStrikes < 2 &&
        nextStimulusContent == sentStimulusContent) {
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
  }

  // Get the stimuli catetory instructions
  void getInstructions() {
    if (gotInstructions == false) {
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
          gotInstructions = true;
        });
      });
    }
  }

  // Get the stimuli totals
  void stimuliTotals() {
    if (stimuliTotaled == false) {
      firebaseRTDB.child('totals').once().then((DataSnapshot snapshot) {
        Map<String, dynamic> totalsMap =
            new Map<String, dynamic>.from(snapshot.value);
        var categoryTotals = Totals.fromJson(totalsMap);
        setState(() {
          totalAds = categoryTotals.adsT;
          totalDebates = categoryTotals.debatesT;
          totalGames = categoryTotals.gamesT;
          totalJokes = categoryTotals.jokesT;
          totalMyths = categoryTotals.mythsT;
          totalNews = categoryTotals.newsT;
          totalPassion = categoryTotals.passionT;
          totalPersonal = categoryTotals.personalT;
          totalPonder = categoryTotals.ponderT;
          totalProverbs = categoryTotals.proverbsT;
          totalQuotes = categoryTotals.quotesT;
          totalShare = categoryTotals.shareT;
          totalStimuli = categoryTotals.stimuliT;
          totalTrivia = categoryTotals.triviaT;
          stimuliTotaled = true;
        });
      });
    }
  }

  void strikedStimulus(uuid, neededStrikes) {
    // Show next if 3 strikes in a full group
    if (stimulusStrikes > 1 && myGroupVacancy == 0) {
      firebaseRTDB.child('groups').child('$groupName').update({
        'scat': '$categoryChoice',
        'sc': '$nextStimulusContent',
        'si': '$instructStimulus',
        'ss': 0
      }).then((_) {
        setState(() {
          sentStimulusContent = nextStimulusContent;
        });
        // show success
        rootScaffoldMessengerKey.currentState
            .showSnackBar(snackBarNextStimulus);
      }).catchError((onErrorNext) {
        print(onErrorNext);
      });
      // Show next if 2 strikes in not a full group
    } else if (stimulusStrikes > 0 && myGroupVacancy != 0) {
      firebaseRTDB.child('groups').child('$groupName').update({
        'scat': '$categoryChoice',
        'sc': '$nextStimulusContent',
        'si': '$instructStimulus',
        'ss': 0
      }).then((_) {
        setState(() {
          sentStimulusContent = nextStimulusContent;
        });
        // show success
        rootScaffoldMessengerKey.currentState
            .showSnackBar(snackBarNextStimulus);
      }).catchError((onErrorNext) {
        print(onErrorNext);
      });
    } else {
      // Increment the counter
      firebaseRTDB
          .child('groups')
          .child('$groupName')
          .update({'ss': ServerValue.increment(1)}).then((_) {
        // Note this user striked that content to prevent
        // multiple strikes on same content by same user
        firebaseRTDB
            .child('dporians')
            .child('$uuid')
            .update({'s': stimulusContent}).catchError((onErrorGroups) {
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
      getStimulus('share', 5);
    }
  }

// Relay all the group value changes
  void getContent(groupID) {
    firebaseRTDB.child('groups').child('$groupID').onValue.listen((event) {
      var snapshot = event.snapshot;
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
    firebaseRTDB.child('vacancies').child('$groupName').onValue.listen((event) {
      var pinpoint = event.snapshot;
      setState(() {
        myGroupVacancy = pinpoint.value;
      });
    });
  }

  // Users can roll of a boot once a week
  // if they haven't got one for a week
  void rollBoot() {
    firebaseRTDB.child('dporians').child(auth.currentUser.uid).update({
      'b': ServerValue.increment(-1),
      't': ServerValue.timestamp
    }).catchError((onError) {
      print(onError);
    });
  }

  void postComment(submitted, milli) {
    String uCS = '';
    if (userColorString == 'blue') {
      uCS = 'b';
    }
    if (userColorString == 'green') {
      uCS = 'g';
    }
    if (userColorString == 'orange') {
      uCS = 'o';
    }
    if (userColorString == 'purple') {
      uCS = 'p';
    }
    if (userColorString == 'red') {
      uCS = 'r';
    }
    String colorContent = uCS + 'c';
    String colorTimestamp = uCS + 't';
    firebaseRTDB.child('groups').child('$groupName').update({
      '$colorContent': '$submitted',
      '$colorTimestamp': ServerValue.timestamp
    }).then((_) {
      // update tally
      firebaseRTDB
          .child('tally')
          .update({'comments': ServerValue.increment(1)}).then((_) {
        // unassign inactive users of the group
        var tenMinutes = 10 * 60 * 1000;
        var beingActive = milli - tenMinutes;
        if (blueTimestamp < beingActive &&
            userColorString != 'blue' &&
            blueVacancy == false) {
          updateVacancy('blue', true);
        }
        if (greenTimestamp < beingActive &&
            userColorString != 'green' &&
            greenVacancy == false) {
          updateVacancy('green', true);
        }
        if (orangeTimestamp < beingActive &&
            userColorString != 'orange' &&
            orangeVacancy == false) {
          updateVacancy('orange', true);
        }
        if (purpleTimestamp < beingActive &&
            userColorString != 'purple' &&
            purpleVacancy == false) {
          updateVacancy('purple', true);
        }
        if (redTimestamp < beingActive &&
            userColorString != 'red' &&
            redVacancy == false) {
          updateVacancy('red', true);
        }
        // wait a bit, then update group vacancy total
        // once. timer may prevent user from switching
        // into the same group, or color of same group
        Timer(Duration(seconds: 20), () {
          vacancyCount(groupName);
        });
      }).catchError((onErrorStats) {
        print(onErrorStats);
      });
    }).catchError((onErrorNext) {
      print(onErrorNext);
    });
  }

  @override
  Widget build(BuildContext context) {
    // is mobile data and wifi turned off?
    checkConnectivity();
    if (airplaneMode == true) {
      // check for connectivity every 10 seconds...
      Timer(Duration(seconds: 10), () {
        checkConnectivity();
      });
    }
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

    // Multiple fonts sizes in menu by this to fit different screen sizes
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;

    // Use to update some data daily or on relaunch
    if (DateTime.now().millisecondsSinceEpoch - dataDownloaded > oneDay) {
      setState(() {
        gotSlogans = false;
        deadTally = false;
        ghostBusted = false;
        gotInstructions = false;
        stimuliTotaled = false;
        checkedUser = false;
        // and update dataDownloaded
        dataDownloaded = DateTime.now().millisecondsSinceEpoch;
      });
    }

    // Get the latest tally to show in menu drawer
    liveTally();
    String liveCountries = 'Over ' +
        countriesRepresented.toString() +
        ' countries represented' +
        '\n';
    String liveTopics =
        'Over ' + totalStimuli.toString() + ' topics available' + '\n';
    String liveDevices =
        'Over ' + devicesDetected.toString() + ' devices detected' + '\n';
    String liveComments =
        'Over ' + commentsPosted.toString() + ' comments posted' + '\n\n';
    if (latestVersion > thisVersion) {
      versionStatus = '(Please update to ' + latestVersion.toString() + ')\n';
    } else {
      versionStatus = '(You are up to date)\n';
    }
    String deviceID = 'No dpora ID yet';
    if (auth.currentUser != null) {
      setState(() {
        // The last 10 digits of auth id
        deviceID = 'dpora ID: ' + auth.currentUser.uid.substring(18);
      });
    }

    // Check if they have the minimal required app version
    // This can also be used as an off switch for DB use
    if (thisVersion < minReqVersion) {
      // shut the front door
      setState(() {
        translatedInstructions = 'See web page';
        translatedStimulus = 'https://dpora.com/update';
        // Either the dpora service or app needs to be updated
        upgradeRequired = true;
        iconColor = boxBGColor;
        userColor = boxBGColor;
      });
    } else {
      // open the front door
      setState(() {
        upgradeRequired = false;
        userColor = Colors.black; // reset to reassign
      });

      // If this is an old version, update some data
      // during app launch or daily (whatever's first)
      if (thisVersion < latestVersion) {
        // Get slogans to show in menu drawer
        getSlogans();
        // Update totals of each stimuli category & sum total
        stimuliTotals();
        // Load all stimuli category instructions
        getInstructions();
      }

      // If already signed in...
      if (auth.currentUser != null) {
        // See if user data exists
        checkUser(auth.currentUser.uid);

        if (registered == true) {
          getUser(auth.currentUser.uid);

          // If not in group (nor have color)...
          if (userColorString == 'black' || groupName == 'none') {
            // User needs to be assigned to a group
            findVacantGroup();
          } else {
            getContent(groupName);
            // Assign comments to appropriate color boxes
            assignChatBoxes(userColorString);
            // To keep the myGroupVacancy integer updated
            myGroupVacancyStatus();
            // Seek and destroy ghosts occupying vacancies
            ghostBusters(groupName);
            // Roll off a boot if not booted for a week
            if (dataDownloaded - userBootstamp > oneDay * 7 && userBoots > 0) {
              rollBoot();
            }
          }

          // Choose a category
          chooseCategory(stimuliDeck[0]);
          // The default stimulus is "DO NOT DELETE THIS ENTRY"
          // which serves as a placeholder for...
          if (nextStimulusContent == 'DO NOT DELETE THIS ENTRY') {
            sentStimulusContent = nextStimulusContent;
            shuffleDecks();
          }

          // Choose a random stimulus
          randomStimulus();
          if (nextStimulusContent == stimulusContent) {
            // That's not a topic change, try again
            sentStimulusContent = nextStimulusContent;
            randomStimulus();
          }

          // Show icons
          iconColor = Colors.grey[700];
        }
      } else {
        // Show Terms of service to first time users of this app installation
        translatedStimulus = 'Welcome!';
        translatedInstructions = 'This is dpora';
        // Show the How to and Terms of service screen before login
        userColor = Colors.grey[700];
        tileTextLT =
            'HOW TO DPORA: Push the text up using your finger or cursor to view all the content in each colored squircle. If the text does not scroll, you are already viewing all the content. The blue or purple squircles should have enough text for you to test scrolling.';
        textColorLT = Colors.orangeAccent;
        tileTextLB =
            'The topic is always on top in yellow. You will be randomly matched with other people, who may be anywhere in the world, to discuss the topic. All comments start vanishing after 30 seconds! So talk openly, but be respectful. You may mute a person\'s comment stream by tapping the icon under their text. The next topic will appear after enough of your group taps the little yellow arrow.';
        textColorLB = Colors.blueAccent;
        tileTextRT =
            'TERMS OF SERVICE: You must be at least 18 years old to use this app (dpora). dpora is not responsible for, and does not save a history of, user-created chat content. dpora is also not liable for any consequences attributed to the use of this app. Nonetheless, objectionable content or abusive users will not be tolerated. dpora reserves the right to make changes to these terms of service at any time. Any policy updates will be announced at news.dpora.com and its RSS feed can be subscribed to at dpora.noticeable.news/policy.rss to be personally and immediately notified of any policy updates.';
        textColorRT = Colors.purpleAccent;
        tileTextRB =
            'Now tap that little yellow arrow to accept these terms of service and to start using dpora!';
        textColorRB = Colors.redAccent;
        iconColor = Colors.black;
      }
    }

    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'ϕ dpora', // or use Φ
      theme: ThemeData.dark(),
      home: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.black,
        // Commented out b/c takes up too much space
        // appBar: new AppBar(
        //       backgroundColor: Colors.transparent,
        //       elevation: 0.0,
        //     ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // DrawerHeader() made too much empty space
              Container(
                padding: EdgeInsets.only(left: 20.0 * screenSizeUnit),
                child: Text.rich(
                  TextSpan(
                    text: '\n\nΦ dpora\n',
                    style: TextStyle(
                      fontSize: 32 * screenSizeUnit,
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.arrow_back_outlined),
                title: Text(
                  slogans[sNum] + '\n',
                  style: TextStyle(
                    fontSize: 16 * screenSizeUnit,
                    color: Colors.white70,
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
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    'Language: ',
                    style: TextStyle(
                      fontSize: 18 * screenSizeUnit,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    selectedLanguageName,
                    style: TextStyle(
                      fontSize: 16 * screenSizeUnit,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Center(
                child: PopupMenuButton(
                  child: Text(
                    '\nTap here to change',
                    style: TextStyle(
                      fontSize: 16 * screenSizeUnit,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  itemBuilder: (BuildContext bc) {
                    return languageOptions
                        .map((langs) => PopupMenuItem(
                              child: Text(langs),
                              value: langs,
                            ))
                        .toList();
                  },
                  onSelected: (value) {
                    setState(() {
                      selectedLanguageName = value.substring(5);
                      selectedLanguageCode = value.substring(0, 2);
                    });
                    // show snackbar if download is needed
                    isModelDownloaded();
                    // download language model
                    downloadModel();
                    // close menu drawer so snackbar is visable
                    _drawerKey.currentState.openEndDrawer();
                    // set user's preferred language
                    if (selectedLanguageCode == 'af') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.AFRIKAANS,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.AFRIKAANS);
                    }
                    if (selectedLanguageCode == 'sq') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ALBANIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ALBANIAN);
                    }
                    if (selectedLanguageCode == 'ar') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ARABIC,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ARABIC);
                    }
                    if (selectedLanguageCode == 'be') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.BELARUSIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.BELARUSIAN);
                    }
                    if (selectedLanguageCode == 'bn') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.BENGALI,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.BENGALI);
                    }
                    if (selectedLanguageCode == 'bg') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.BULGARIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.BULGARIAN);
                    }
                    if (selectedLanguageCode == 'ca') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.CATALAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.CATALAN);
                    }
                    if (selectedLanguageCode == 'zh') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.CHINESE,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.CHINESE);
                    }
                    if (selectedLanguageCode == 'hr') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.CROATIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.CROATIAN);
                    }
                    if (selectedLanguageCode == 'cs') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.CZECH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.CZECH);
                    }
                    if (selectedLanguageCode == 'da') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.DANISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.DANISH);
                    }
                    if (selectedLanguageCode == 'nl') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.DUTCH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.DUTCH);
                    }
                    // the default
                    if (selectedLanguageCode == 'en') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                    }
                    if (selectedLanguageCode == 'eo') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ESPERANTO,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ESPERANTO);
                    }
                    if (selectedLanguageCode == 'et') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ESTONIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ESTONIAN);
                    }
                    if (selectedLanguageCode == 'fi') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.FINNISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.FINNISH);
                    }
                    if (selectedLanguageCode == 'fr') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.FRENCH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.FRENCH);
                    }
                    if (selectedLanguageCode == 'gl') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.GALICIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.GALICIAN);
                    }
                    if (selectedLanguageCode == 'ka') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.GEORGIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.GEORGIAN);
                    }
                    if (selectedLanguageCode == 'de') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.GERMAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.GERMAN);
                    }
                    if (selectedLanguageCode == 'el') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.GREEK,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.GREEK);
                    }
                    if (selectedLanguageCode == 'gu') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.GUJARATI,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.GUJARATI);
                    }
                    if (selectedLanguageCode == 'ht') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.HAITIAN_CREOLE,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.HAITIAN_CREOLE);
                    }
                    if (selectedLanguageCode == 'he') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.HEBREW,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.HEBREW);
                    }
                    if (selectedLanguageCode == 'hi') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.HINDI,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.HINDI);
                    }
                    if (selectedLanguageCode == 'hu') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.HUNGARIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.HUNGARIAN);
                    }
                    if (selectedLanguageCode == 'is') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ICELANDIC,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ICELANDIC);
                    }
                    if (selectedLanguageCode == 'id') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.INDONESIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.INDONESIAN);
                    }
                    if (selectedLanguageCode == 'ga') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.IRISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.IRISH);
                    }
                    if (selectedLanguageCode == 'it') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ITALIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ITALIAN);
                    }
                    if (selectedLanguageCode == 'ja') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.JAPANESE,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.JAPANESE);
                    }
                    if (selectedLanguageCode == 'kn') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.KANNADA,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.KANNADA);
                    }
                    if (selectedLanguageCode == 'ko') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.KOREAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.KOREAN);
                    }
                    if (selectedLanguageCode == 'lv') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.LATVIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.LATVIAN);
                    }
                    if (selectedLanguageCode == 'lt') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.LITHUANIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.LITHUANIAN);
                    }
                    if (selectedLanguageCode == 'mk') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.MACEDONIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.MACEDONIAN);
                    }
                    if (selectedLanguageCode == 'ms') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.MALAY,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.MALAY);
                    }
                    if (selectedLanguageCode == 'mt') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.MALTESE,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.MALTESE);
                    }
                    if (selectedLanguageCode == 'mr') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.MARATHI,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.MARATHI);
                    }
                    if (selectedLanguageCode == 'no') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.NORWEGIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.NORWEGIAN);
                    }
                    if (selectedLanguageCode == 'fa') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.PERSIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.PERSIAN);
                    }
                    if (selectedLanguageCode == 'pl') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.POLISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.POLISH);
                    }
                    if (selectedLanguageCode == 'pt') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.PORTUGUESE,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.PORTUGUESE);
                    }
                    if (selectedLanguageCode == 'ro') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ROMANIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.ROMANIAN);
                    }
                    if (selectedLanguageCode == 'ru') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.RUSSIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.RUSSIAN);
                    }
                    if (selectedLanguageCode == 'sk') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.SLOVAK,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.SLOVAK);
                    }
                    if (selectedLanguageCode == 'sl') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.SLOVENIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.SLOVENIAN);
                    }
                    if (selectedLanguageCode == 'es') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.SPANISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.SPANISH);
                    }
                    if (selectedLanguageCode == 'sw') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.SWAHILI,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.SWAHILI);
                    }
                    if (selectedLanguageCode == 'sv') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.SWEDISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.SWEDISH);
                    }
                    if (selectedLanguageCode == 'tl') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.TAGALOG,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.TAGALOG);
                    }
                    if (selectedLanguageCode == 'ta') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.TAMIL,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.TAMIL);
                    }
                    if (selectedLanguageCode == 'te') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.TELUGU,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.TELUGU);
                    }
                    if (selectedLanguageCode == 'th') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.THAI,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.THAI);
                    }
                    if (selectedLanguageCode == 'tr') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.TURKISH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.TURKISH);
                    }
                    if (selectedLanguageCode == 'uk') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.UKRAINIAN,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.UKRAINIAN);
                    }
                    if (selectedLanguageCode == 'ur') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.URDU,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.URDU);
                    }
                    if (selectedLanguageCode == 'vi') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.VIETNAMESE,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.VIETNAMESE);
                    }
                    if (selectedLanguageCode == 'cy') {
                      _onDeviceToEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.WELSH,
                              targetLanguage: TranslateLanguage.ENGLISH);
                      _onDeviceFromEnglishTranslator = GoogleMlKit.nlp
                          .onDeviceTranslator(
                              sourceLanguage: TranslateLanguage.ENGLISH,
                              targetLanguage: TranslateLanguage.WELSH);
                    }
                  },
                ),
              ),
              Center(
                child: Text(
                  'On-device translations',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'powered by',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[600],
                    ),
                  ),
                  Image.asset('assets/images/greyscale-regular.png'),
                ],
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0 * screenSizeUnit),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '\nContact' + '\n\n',
                        style: TextStyle(
                          fontSize: 18 * screenSizeUnit,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'If you discover a software bug or have a problem with dpora, please email chat+bug@dpora.com\n\n' +
                            'If something is wrong with a topic (misspelled, offensive, outdated, dumb or incorrect in some way), email chat+topic@dpora.com\n\n' +
                            'If you want a new feature, have suggestions, comments or concerns  email chat+feedback@dpora.com\n\n' +
                            'If you have any questions or anything else, email chat@dpora.com\n',
                        style: TextStyle(
                          fontSize: 16 * screenSizeUnit,
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
                padding: EdgeInsets.only(left: 20.0 * screenSizeUnit),
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '\nTally',
                        style: TextStyle(
                          fontSize: 18 * screenSizeUnit,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: '\n\n' + liveCountries + '\n',
                        style: TextStyle(
                          fontSize: 16 * screenSizeUnit,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: liveTopics + '\n',
                        style: TextStyle(
                          fontSize: 16 * screenSizeUnit,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: liveDevices + '\n',
                        style: TextStyle(
                          fontSize: 16 * screenSizeUnit,
                          color: Colors.white70,
                        ),
                      ),
                      TextSpan(
                        text: liveComments,
                        style: TextStyle(
                          fontSize: 16 * screenSizeUnit,
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
              Center(
                child: Text(
                  '\n' +
                      platform +
                      ' Version ' +
                      thisVersion.toString() +
                      '\n ' +
                      versionStatus,
                  style: TextStyle(
                    fontSize: 14 * screenSizeUnit,
                    color: Colors.white38,
                  ),
                ),
              ),
              Center(
                child: Text(
                  deviceID + '\n',
                  style: TextStyle(
                    fontSize: 14 * screenSizeUnit,
                    color: Colors.white38,
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                thickness: 1.0,
              ),
              Center(
                child: Text(
                  '\nAvailable on Google Play* (QR code shortcut)',
                  style: TextStyle(
                    fontSize: 12 * screenSizeUnit,
                    color: Colors.white38,
                  ),
                ),
              ),
              Image.asset('assets/images/qrcode_googleplay.png'),
              Center(
                child: Text(
                  '*Google Play is a trademark of Google LLC. \n',
                  style: TextStyle(
                    fontSize: 12 * screenSizeUnit,
                    color: Colors.white38,
                  ),
                ),
              ),
              Center(
                child: Text(
                  copyright,
                  style: TextStyle(
                    fontSize: 14 * screenSizeUnit,
                    color: Colors.white38,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.arrow_back_outlined),
                title: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16 * screenSizeUnit,
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
        resizeToAvoidBottomInset: false,
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
  Widget _icon(stimulusCategory, textSize) {
    // Multiple icon sizes by this to fit different screen sizes
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;
    double categoryIconSize = 24.0 * screenSizeUnit; // normal size
    if (textSize > 25.0 * screenSizeUnit) {
      // Show larger icons for horizontal view.
      // "double the double" value
      categoryIconSize = 48.0 * screenSizeUnit;
    }
    if (stimulusCategory == 'ads') {
      return Icon(
        Icons.local_offer_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'debates') {
      return Icon(
        Icons.gavel_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'games') {
      return Icon(
        Icons.casino_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'jokes') {
      return Icon(
        Icons.emoji_emotions_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'news') {
      return Icon(
        Icons.speaker_notes_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'passion') {
      return Icon(
        Icons.thumbs_up_down_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'personal') {
      return Icon(
        Icons.emoji_people_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'ponder') {
      return Icon(
        Icons.psychology_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'proverbs') {
      return Icon(
        Icons.history_edu_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'quotes') {
      return Icon(
        Icons.format_quote_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else if (stimulusCategory == 'share') {
      return Icon(
        Icons.group_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    } else {
      // Trivia or Myths
      // Terms of service
      // No Internet Connection
      return Icon(
        Icons.fact_check_rounded,
        color: Colors.yellow,
        size: categoryIconSize,
      );
    }
  }

  Widget _stimulus(textSize) {
    if (airplaneMode == true) {
      // Shows only when no internet connection
      setState(() {
        translatedStimulus =
            'No Internet Connection! Please turn on mobile data, WiFi or both.';
        translatedInstructions = 'Airplane Mode?';
      });
    }

    // Multiply object sizes by this to fit different screen sizes
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;
    // vertical view
    double instructionSize = 14 * screenSizeUnit;
    double _iconSize = 24.0 * screenSizeUnit;
    if (textSize > 25.0 * screenSizeUnit) {
      // horizontal view
      instructionSize = 12 * screenSizeUnit;
      _iconSize = 28.0 * screenSizeUnit;
      // prepend a space to give spacer from border
      stimulusInstructions = '  ' + stimulusInstructions;
    }

    // Calculute how many strikes are needed to show next stimulus
    if (myGroupVacancy != 0) {
      // No group or not a full group
      strikesNeeded = 2;
    } else {
      // It's a full group
      strikesNeeded = 3;
    }

    // Translate stimulus content and instructions, if needed
    if (selectedLanguageCode == 'en') {
      // No translation needed
      translatedStimulus = stimulusContent;
      translatedInstructions = stimulusInstructions;
    } else {
      // Translate stimulus content
      if (priorStimulus != stimulusContent) {
        translateFromEnglish('stimulus');
        // Using timer to set priorStimulus once, not continuously
        Timer.run(() {
          priorStimulus = stimulusContent;
        });
      }
      // Translate stimulus instructions
      if (priorInstructions != stimulusInstructions) {
        translateFromEnglish('instructions');
        // Using timer to set priorInstructions once, not continuously
        Timer.run(() {
          priorInstructions = stimulusInstructions;
        });
      }      
    }

    return GestureDetector(
        // Provide place to tap to hide keyboard, if needed
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(10.0 * screenSizeUnit),
          margin: EdgeInsets.all(10.0 * screenSizeUnit),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: boxBGColor,
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Menu button and other icons here
            Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 30.0 * screenSizeUnit,
                    width: 30.0 * screenSizeUnit,
                    child: IconButton(
                      icon: Icon(
                        Icons.menu_rounded,
                        color: iconColor,
                        size: _iconSize,
                      ),
                      padding: EdgeInsets.zero, // need for alignment
                      tooltip: 'Φ Menu',
                      onPressed: () =>
                          _drawerKey.currentState.openDrawer(), // open drawer
                    ),
                  ),
                  SizedBox(
                    height: 30.0 * screenSizeUnit,
                    width: 30.0 * screenSizeUnit,
                    child: IconButton(
                      icon: Icon(
                        Icons.share_rounded,
                        color: iconColor,
                        size: _iconSize,
                      ),
                      padding: EdgeInsets.zero, // need for alignment
                      tooltip: 'Share Topic',
                      onPressed: () {
                        Share.share(translatedStimulus + ' \nΦ dpora.com',
                            subject: translatedInstructions);
                      },
                    ),
                  ),
                  // TODO: add Change Group feature later, when
                  // there are always a few live groups to switch to
                  // child: IconButton(
                  //   icon: Icon(
                  //     Icons.threesixty_rounded,
                  //     color: iconColor,
                  //     size: _iconSize,
                  //   ),
                  //   padding: EdgeInsets.zero, // need for alignment
                  //   tooltip: 'New Group & Topic',
                  //   onPressed: () {},
                  // //set dporian groupName to 'none' and update vacancies and group data
                  // ),
                ]),

            // Stimulus is displayed here
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    15.0 * screenSizeUnit,
                    5.0 * screenSizeUnit,
                    10.0 * screenSizeUnit,
                    5.0 * screenSizeUnit),
                child: Text(
                  translatedStimulus,
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
                  // Shows the appropriate icon & size
                  _icon(stimulusCategory, textSize),
                  Container(
                    padding: EdgeInsets.all(7.0 * screenSizeUnit),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey[900],
                    ),
                    height: 70.0 * screenSizeUnit,
                    width: 90.0 * screenSizeUnit,
                    child: Text(
                      translatedInstructions,
                      overflow: TextOverflow.clip, // just in case
                      style: TextStyle(
                        fontSize: instructionSize,
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  Row(children: [
                    Text(
                      'Next',
                      style: TextStyle(
                        fontSize: textSize,
                        color: iconColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30.0 * screenSizeUnit,
                      width: 30.0 * screenSizeUnit,
                      child: IconButton(
                        icon: Icon(
                          Icons.forward_rounded,
                          color: Colors.yellow,
                          size: _iconSize,
                        ),
                        padding: EdgeInsets.zero, // need for alignment
                        tooltip: 'Next Topic',
                        onPressed: () {
                          if (upgradeRequired == false) {
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
                                strikedStimulus(
                                    auth.currentUser.uid, strikesNeeded);
                              }
                            } else {
                              // Otherwise, sign the user in anonymously
                              signInAnonymously();
                              Timer(Duration(seconds: 3), () {
                                if (auth.currentUser != null) {
                                  setState(() {
                                    checkedUser = false;
                                    translatedStimulus =
                                        'You can scroll this area too. You have been assigned the private and random ID: ' +
                                            auth.currentUser.uid.substring(18) +
                                            ' (accessible from the menu icon). Now tap the arrow once more to join a group!';
                                    translatedInstructions =
                                        'Topic theme goes here';
                                    iconColor = Colors.grey[
                                        700]; //TODO test this when convenient, no rush
                                  });
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Text(
                      ' ' +
                          stimulusStrikes.toString() +
                          '/' +
                          strikesNeeded.toString(),
                      style: TextStyle(
                        fontSize: textSize * 0.8,
                        color: iconColor,
                      ),
                    ),
                  ]),
                ]),
          ]),
        ));
  }

  Widget _userInput(userColor) {
    int _timeUntilFade = 20;
    int _fadeDuration = 10;
    double clearIconSize = 14.0;
    int maxCharacters = 250;
    String _labelText = 'Tap here, type, hit Enter key';
    Color _labelColor = userColor;
    String _hintText = 'You are ' + userColorString;
    Color _hintColor = iconColor;
    if (auth.currentUser == null) {
      boxBGColor = Colors.black;
      clearIconSize = 0.0;
      maxCharacters = 1;
      _labelText = 'a stranger kind of chat app';
      _labelColor = Colors.grey[700];
      _hintText = 'a stranger kind of chat app';
      _hintColor = Colors.grey[700];
      // That slogan is also on top of yaml file
    }
    return TextField(
        controller: inputController,
        style: TextStyle(color: userColor),
        cursorColor: userColor,
        // show Send instead of Enter on virtual keyboards
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
          labelText: _labelText,
          labelStyle: TextStyle(color: _labelColor),
          hintText: _hintText,
          hintStyle: TextStyle(color: _hintColor),
          // cancel text button
          suffixIcon: IconButton(
            onPressed: () {
              inputController.clear();
            },
            icon: Icon(
              Icons.clear,
              size: clearIconSize,
              color: userColor,
            ),
          ),
        ),
        maxLength: maxCharacters,
        // this is way more than needed but allows for ascii art or venting
        autofocus: false,
        onEditingComplete: () {
          if (auth.currentUser != null && upgradeRequired == false) {
            if (waitStatus == true) {
              // snackbar reminds user to wait until previous post disappears
              rootScaffoldMessengerKey.currentState
                  .showSnackBar(snackBarWait2Post);
            } else {
              setState(() {
                submittedText = inputController.text;
                userFadeTime = 0;
                userOpacity = 1.0;
                waitStatus = true;
                showTextField = false; // show user comment
              });
              if (selectedLanguageCode != 'en') {
                // translate text
                translateToEnglish();
                Timer(Duration(seconds: 5), () {
                  // allow time for translation before posting to group
                  // and this might take a while on sub-par phones
                  postComment(translatedToEnglish,
                      DateTime.now().millisecondsSinceEpoch);
                });
              } else {
                // no translation needed, post immediately
                postComment(inputController.text,
                    DateTime.now().millisecondsSinceEpoch);
              }
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
                  // user can post again
                  waitStatus = false;
                  showTextField = true;
                });
              });
            }
            // close virtual keyboard
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          }
        });
  }

  Widget _userOutput(textSize, verticalView) {
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;
    double marginSpace = screenSizeUnit * 19;
    double outputWidth = 0.98; // 98%
    int outputLines = 2;
    if (verticalView == false) {
      marginSpace = 0;
      outputWidth = 0.48; // 48%
      outputLines = 5;
    }
    return Container(
      width: MediaQuery.of(context).size.width * outputWidth,
      margin: EdgeInsets.fromLTRB(0.0, marginSpace, 0.0, marginSpace),
      padding: EdgeInsets.all(10.0 * screenSizeUnit),
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
          maxLines: outputLines,
          overflow: TextOverflow.ellipsis, // truncates, not scrollable
        ),
      ),
    );
  }

  Widget _chatTile(tileHeight, tileWidth, textSize, tileText, textColor,
      postTime, tileVacancy, muteCount) {
    // Multiple object sizes by this to fit different screen sizes
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;
    String muteStatusText = '';
    // If tile is vacant, don't show its color
    Color _iconColor = iconColor;
    // If tile is muted or vacant,
    // hide its contents or box border
    Color _textColor = textColor;
    double iconSize = 22.0 * screenSizeUnit; // vertical view
    double muteStatusSize = 10.0 * screenSizeUnit; // vertical
    if (platform == 'iOS' && textSize <= 20.0 * screenSizeUnit) {
      muteStatusSize = 8.0 * screenSizeUnit;
    }
    if (textSize > 20.0 * screenSizeUnit) {
      // make iconSize larger for horizontal
      iconSize = 26.0 * screenSizeUnit;
      muteStatusSize = 17.0 * screenSizeUnit;
    }
    if (tileVacancy == true) {
      if (registered == true) {
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
        int thirtySeconds = 30 * 1000;
        // Fade action only occurs to chat text, not Terms of service
        if (timeElapsed > thirtySeconds && auth.currentUser != null) {
          chatFadeTime = 10; // slow fade out
          chatOpacity = 0.0;
        } else if (timeElapsed <= thirtySeconds) {
          chatFadeTime = 1; // quick fade in
          chatOpacity = 1.0;
        }
        // Show literal mute status
        if (muteCount == 0) {
          muteStatusText = ' Tap icon to mute';
        } else if (muteCount == 1) {
          muteStatusText = ' Group muted once';
        } else if (muteCount == 2) {
          muteStatusText = ' Group muted twice';
        } else if (muteCount == 3) {
          muteStatusText = ' Group muted thrice';
        } else if (muteCount == 4) {
          muteStatusText = ' Whole group muted';
        }
        // Unmute new member if assigned to a muted color tile
        if (muteCount == 0 && _iconColor == Colors.grey) {
          muteStatusText = ' Unmute new user!';
          _textColor = textColor; // unmuted
        }
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * tileHeight,
      width: MediaQuery.of(context).size.width * tileWidth,
      padding: EdgeInsets.all(10.0 * screenSizeUnit),
      margin: EdgeInsets.all(10.0 * screenSizeUnit),
      decoration: BoxDecoration(
        border: Border.all(color: _textColor),
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
              height: 20.0 * screenSizeUnit,
              width: 20.0 * screenSizeUnit,
              child: IconButton(
                icon: Icon(
                  Icons.not_interested_rounded,
                  color: _iconColor,
                  size: iconSize,
                ),
                padding: EdgeInsets.zero, // need for alignment
                tooltip: 'Toggle Mute Status',
                onPressed: () {
                  if (auth.currentUser != null) {
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
                  }
                },
              ),
            ),
            // spacer box
            SizedBox(
              height: 5.0 * screenSizeUnit,
              width: 8.0 * screenSizeUnit,
            ),
            Text(
              muteStatusText,
              overflow: TextOverflow.clip, // just in case
              style: TextStyle(
                fontSize: muteStatusSize,
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
    // Multiple fonts sizes by this to fit different screen sizes
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;
    double outerspace = screenSizeUnit * 10;
    final allTileHeight = 0.25; // 25% screen height
    final allTileWidth = 0.43; // 43% screen width
    double allTextSize = 17.0 * screenSizeUnit; // font size for chatters
    double _stimulusTextSize = 19.0;
    if (platform == 'iOS') {
      allTextSize = 14 * screenSizeUnit;
      _stimulusTextSize = 16.0;
    }
    bool verticalView = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.26, //26%
          width: MediaQuery.of(context).size.width * 0.98, //98%
          child: _stimulus(
              _stimulusTextSize * screenSizeUnit), // stimulus text size
        ),
        Container(
          padding: EdgeInsets.fromLTRB(outerspace, 0.0, outerspace, 0.0),
          width: MediaQuery.of(context).size.width * 0.98, //98%,
          // TODO: Decide whether or not to take out, to reduce task load
          // child: AnimatedSwitcher(
          //   duration: const Duration(milliseconds: 1500),
          //   transitionBuilder: (Widget child, Animation<double> animation) {
          //     return RotationTransition(child: child, turns: animation);
          //   },
          child: showTextField
              ? _userInput(userColor)
              : _userOutput(allTextSize, verticalView),
          //),
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
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'On-device translations powered by',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Image.asset('assets/images/greyscale-regular.png'),
            ]),
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
    // Multiple fonts sizes by this to fit different screen sizes
    double screenSizeUnit = MediaQuery.of(context).size.height * 0.0015;
    double outerspace = screenSizeUnit * 10;
    final allTileHeight = 0.6; // 60% screen height
    final allTileWidth = 0.22; // 22% screen width
    final allTextSize = 24.0 * screenSizeUnit; // font size for chatters
    bool verticalView = false;
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3, // third
              width: MediaQuery.of(context).size.width * 0.48,
              child: _stimulus(30.0 * screenSizeUnit), // stimulus text size
            ),
            Container(
              padding: EdgeInsets.fromLTRB(outerspace, 0.0, outerspace, 0.0),
              width: MediaQuery.of(context).size.width * 0.47,
              // TODO: Decide whether or not to take out, to reduce task load
              // child: AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 500),
              //   transitionBuilder: (Widget child, Animation<double> animation) {
              //     return RotationTransition(child: child, turns: animation);
              //   },
              child: showTextField
                  ? _userInput(userColor)
                  : _userOutput(allTextSize, verticalView),
              // ),
            ),
          ]),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextLT,
                textColorLT, postTimeLT, tileVacancyLT, muteCountLT),
            _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextLB,
                textColorLB, postTimeLB, tileVacancyLB, muteCountLB),
            _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextRT,
                textColorRT, postTimeRT, tileVacancyRT, muteCountRT),
            _chatTile(allTileHeight, allTileWidth, allTextSize, tileTextRB,
                textColorRB, postTimeRB, tileVacancyRB, muteCountRB),
          ]),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'On-device translations powered by',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
            Image.asset('assets/images/greyscale-regular.png'),
          ])
    ]);
  }
}
