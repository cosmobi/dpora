import 'package:connectivity/connectivity.dart';
import 'dart:math';

// Random ID: 4me6vuiRqQnJ*GoToTheMoon!

// TODO: Stimuli totals need to be updated before every app release!
final int totalAds = 1;
final int totalDebates = 266;
final int totalGames = 33;
final int totalJokes = 152;
final int totalMyths = 59;
final int totalNews = 1;
final int totalPassion = 65;
final int totalPersonal = 757;
final int totalPonder = 262;
final int totalProverbs = 394;
final int totalQuotes = 297;
final int totalShare = 34;
final int totalTrivia = 131;
final int totalStimuli = 2452; // Total Sum
// *******************************************************

// Used to select a random stimuli category
int dieRoll = Random().nextInt(totalStimuli); // starts at zero
String categoryChoice;

// // To choose a random stimulus number from each category (includes zero IDs)
int randomAds = Random().nextInt(totalAds);
int randomDebates = Random().nextInt(totalDebates);
int randomGames = Random().nextInt(totalGames);
int randomJokes = Random().nextInt(totalJokes);
int randomMyths = Random().nextInt(totalMyths);
int randomNews = Random().nextInt(totalNews);
int randomPassion = Random().nextInt(totalPassion);
int randomPersonal = Random().nextInt(totalPersonal);
int randomPonder = Random().nextInt(totalPonder);
int randomProverbs = Random().nextInt(totalProverbs);
int randomQuotes = Random().nextInt(totalQuotes);
int randomShare = Random().nextInt(totalShare);
int randomTrivia = Random().nextInt(totalTrivia);

// If mobile data and/or wifi are turned off then tell the
// user (as a stimulus and snackbar) to turn on one or both.
bool airplaneMode = false;
void checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    airplaneMode = true;
  }
}

// Will be used to hold platform identification
String platform;

// Generate an UUID
String milliseconds = DateTime.now().millisecondsSinceEpoch.toString();
Random generateRandom = new Random();
String randomNumber = generateRandom.nextInt(1000000).toString();
final String uuid = randomNumber + milliseconds;

// Make updated copyright text
DateTime nowDate = new DateTime.now();
String nowYear = new DateTime(nowDate.year).toString().substring(0, 4);
final String copyright = 'Copyright © 2020-' + nowYear + ' dpora';

// Set the opacity and duration for fading text
double userOpacity = 1.0;
double chatOpacity = 1.0;
int userFadeTime = 10; // in seconds
int chatFadeTime = 10;

// Default stimulus text must be empty like this
// so transitions between reloads are smoother
String stimText = '';

// This is updated when user hits Return or Enter on their keyboard
String submittedText = '';

// TODO: later, pull this array content from the DB
// This list order will shuffle everytime the menu drawer closes
var menuMessages = [
  'Have private yet meaningful\nchats with total strangers',
  'Speak your mind and gain\nmultiple perspectives',
  'Educate and learn with others.\nDisagree and grow together.',
];

// Used for serialization of json-formatted stimuli to and from the database
class Stimulus {
  final int flagged;
  final String author;
  final String stimulus;
  final String type;

  Stimulus(this.flagged, this.author, this.stimulus, this.type);

  Stimulus.fromJson(Map<String, dynamic> json)
      : flagged = json['flagged'],
        author = json['author'],
        stimulus = json['stimulus'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'flagged': flagged,
        'author': author,
        'stimulus': stimulus,
        'type': type,
      };
}
