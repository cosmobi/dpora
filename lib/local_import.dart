import 'package:connectivity/connectivity.dart';
import 'dart:math';

// TODO: Stimuli totals need to be updated before every app release!
final int totalAds = 1;
final int totalDebates = 266;
final int totalGames = 33;
final int totalJokes = 152;
final int totalMyths = 59;
final int totalNews = 4;
final int totalPassion = 65;
final int totalPersonal = 757;
final int totalPonder = 262;
final int totalProverbs = 394;
final int totalQuotes = 297;
final int totalShare = 34;
final int totalTrivia = 131;
final int totalStimuli = 2455; // Total Sum
// *******************************************************

// Generate an UUID
String milliseconds = DateTime.now().millisecondsSinceEpoch.toString();
Random generateRandom = new Random();
String randomNumber = generateRandom.nextInt(1000000).toString();
final String uuid = randomNumber + milliseconds;

// Random ID example: r4me6vuiRqQnJ*GoToTheMoon!

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

// Make updated copyright text
DateTime nowDate = new DateTime.now();
String nowYear = new DateTime(nowDate.year).toString().substring(0, 4);
final String copyright = 'Copyright © 2020-' + nowYear + ' dpora';

// Set the opacity and duration for fading text
double userOpacity = 1.0;
double chatOpacity = 1.0;
int userFadeTime = 10; // in seconds
int chatFadeTime = 10;

// Create lists (decks) containing all the stimuli counts
// These decks will be shuffled later to choose a random entry
List<int> adsDeck = new List<int>.generate(totalAds, (i) => i + 1);
List<int> debatesDeck = new List<int>.generate(totalDebates, (i) => i + 1);
List<int> gamesDeck = new List<int>.generate(totalGames, (i) => i + 1);
List<int> jokesDeck = new List<int>.generate(totalJokes, (i) => i + 1);
List<int> mythsDeck = new List<int>.generate(totalMyths, (i) => i + 1);
List<int> newsDeck = new List<int>.generate(totalNews, (i) => i + 1);
List<int> passionDeck = new List<int>.generate(totalPassion, (i) => i + 1);
List<int> personalDeck = new List<int>.generate(totalPersonal, (i) => i + 1);
List<int> ponderDeck = new List<int>.generate(totalPonder, (i) => i + 1);
List<int> proverbsDeck = new List<int>.generate(totalProverbs, (i) => i + 1);
List<int> quotesDeck = new List<int>.generate(totalQuotes, (i) => i + 1);
List<int> shareDeck = new List<int>.generate(totalShare, (i) => i + 1);
List<int> triviaDeck = new List<int>.generate(totalTrivia, (i) => i + 1);
List<int> stimuliDeck = new List<int>.generate(totalStimuli, (i) => i + 1);

String categoryChoice;

// Default stimulus text must be empty like this
// so transitions between reloads are smoother
String stimulusText = '';

// Displays the category instructions
String categoryText = '';

// This is updated when user hits Return or Enter on their keyboard
String submittedText = '';

// TODO: later, pull this array content from the DB
// This list order will shuffle everytime the menu drawer closes
var menuMessages = [
  'Have private yet meaningful\nchats with total strangers',
  'Speak your mind and gain\nmultiple perspectives',
  'Educate and learn with others.\nDisagree and grow together.',
  'Be social and be private.\nThe best of both worlds.'
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
