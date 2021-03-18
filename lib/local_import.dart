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

String categoryChoice = '';
//new Icon categoryIcon = 'Icon.emoji_people_rounded';

// Default stimulus text must be empty like this
// so transitions between reloads are smoother
String stimulusText = '';

// These will hold the stimuli category instructions
String instructAds = '';
String instructDebates = '';
String instructGames = '';
String instructJokes = '';
String instructMyths = '';
String instructNews = '';
String instructPassion = '';
String instructPersonal = '';
String instructPonder = '';
String instructProverbs = '';
String instructQuotes = '';
String instructShare = '';
String instructTrivia = '';
// And this will hold the currently selected category
String instructStimulus = '';

Map<String, dynamic> categoryInstructions;

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

// Classes below are for the serialization of
// json-formatted data to and from the database

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

class Instruct {
  final String ads;
  final String debates;
  final String games;
  final String jokes;
  final String myths;
  final String news;
  final String passion;
  final String personal;
  final String ponder;
  final String proverbs;
  final String quotes;
  final String share;
  final String trivia;

  Instruct(
      this.ads,
      this.debates,
      this.games,
      this.jokes,
      this.myths,
      this.news,
      this.passion,
      this.personal,
      this.ponder,
      this.proverbs,
      this.quotes,
      this.share,
      this.trivia);

  Instruct.fromJson(Map<String, dynamic> json)
      : ads = json['ads'],
        debates = json['debates'],
        games = json['games'],
        jokes = json['jokes'],
        myths = json['myths'],
        news = json['news'],
        passion = json['passion'],
        personal = json['personal'],
        ponder = json['ponder'],
        proverbs = json['proverbs'],
        quotes = json['quotes'],
        share = json['share'],
        trivia = json['trivia'];

  Map<String, dynamic> toJson() => {
        'ads': ads,
        'debates': debates,
        'games': games,
        'jokes': jokes,
        'myths': myths,
        'news': news,
        'passion': passion,
        'personal': personal,
        'ponder': ponder,
        'proverbs': proverbs,
        'quotes': quotes,
        'share': share,
        'trivia': trivia,
      };
}
