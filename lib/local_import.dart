
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
final int totalTrivia = 132;
final int totalStimuli = 2456; // Total Sum
// *******************************************************

// To generate an UID (eg, r4me6vuiRqQnJ*GoToTheMoon), if needed...
// then import 'dart:math'; at the top and uncomment these lines...
// String milliseconds = DateTime.now().millisecondsSinceEpoch.toString();
// Random generateRandom = new Random();
// String randomNumber = generateRandom.nextInt(1000000).toString();
// final String uid = randomNumber + milliseconds;

// Will be used to hold platform identification
String platform;

// Make updated copyright text
DateTime nowDate = new DateTime.now();
String nowYear = new DateTime(nowDate.year).toString().substring(0, 4);
final String copyright = 'Copyright © 2020-' + nowYear + ' dpora';
// And use this as default timestamp
int milliEpoch = nowDate.millisecondsSinceEpoch;

// Set the opacity and duration for fading text
double userOpacity = 1.0;
double chatOpacity = 1.0;
int userFadeTime = 10; // in seconds
int chatFadeTime = 10;

// dporian info
int userBoots = 0;
int userBootstamp = milliEpoch;
String userColorString = '';
String userGroup = '';

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

// These variables hold all the chat activity
String blueContent = '';
int blueStrikes = 0;
int blueTimestamp = milliEpoch;
bool blueVacancy = false;
String greenContent = '';
int greenStrikes = 0;
int greenTimestamp = milliEpoch;
bool greenVacancy = false;
String orangeContent = '';
int orangeStrikes = 0;
int orangeTimestamp = milliEpoch;
bool orangeVacancy = false;
String purpleContent = '';
int purpleStrikes = 0;
int purpleTimestamp = milliEpoch;
bool purpleVacancy = false;
String redContent = '';
int redStrikes = 0;
int redTimestamp = milliEpoch;
bool redVacancy = false;
int groupSize = 0;

// This is updated when user hits Return or Enter on their keyboard
String submittedText = '';

// TODO: later, pull this array content from the DB
// This list order will shuffle everytime the menu drawer closes
var menuMessages = [
  'Have private yet meaningful\nchats with total strangers',
  'Speak your mind and gain\nmultiple perspectives',
  'Educate and learn with others.\nDisagree and grow together.',
  'Be social and be private.\nThe best of both worlds.',
  'Totally social. Totally private.\nTotally awesome!'
];

// Classes below are for the serialization of
// json-formatted data to and from the database

class Dporian {
  final int boots;
  final int bootstamp;
  final String color;
  final String group;

  Dporian(this.boots, this.bootstamp, this.color, this.group);

  Dporian.fromJson(Map<String, dynamic> json)
      : boots = json['boots'],
        bootstamp = json['bootstamp'],
        color = json['color'],
        group = json['group'];

  Map<String, dynamic> toJson() => {
        'boots': boots,
        'bootstamp': bootstamp,
        'color': color,
        'group': group,
      };
}

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

class Comments {
  final String blueContent;
  final int blueStrikes;
  final int blueTimestamp;
  final bool blueVacancy;
  final String greenContent;
  final int greenStrikes;
  final int greenTimestamp;
  final bool greenVacancy;
  final String orangeContent;
  final int orangeStrikes;
  final int orangeTimestamp;
  final bool orangeVacancy;
  final String purpleContent;
  final int purpleStrikes;
  final int purpleTimestamp;
  final bool purpleVacancy;
  final String redContent;
  final int redStrikes;
  final int redTimestamp;
  final bool redVacancy;
  final int groupSize;

  Comments(
      this.blueContent,
      this.blueStrikes,
      this.blueTimestamp,
      this.blueVacancy,
      this.greenContent,
      this.greenStrikes,
      this.greenTimestamp,
      this.greenVacancy,
      this.orangeContent,
      this.orangeStrikes,
      this.orangeTimestamp,
      this.orangeVacancy,
      this.purpleContent,
      this.purpleStrikes,
      this.purpleTimestamp,
      this.purpleVacancy,
      this.redContent,
      this.redStrikes,
      this.redTimestamp,
      this.redVacancy,
      this.groupSize);

  Comments.fromJson(Map<String, dynamic> json)
      : blueContent = json['blue-content'],
        blueStrikes = json['blue-strikes'],
        blueTimestamp = json['blue-timestamp'],
        blueVacancy = json['blue-vacancy'],
        greenContent = json['green-content'],
        greenStrikes = json['green-strikes'],
        greenTimestamp = json['green-timestamp'],
        greenVacancy = json['green-vacancy'],
        orangeContent = json['orange-content'],
        orangeStrikes = json['orange-strikes'],
        orangeTimestamp = json['orange-timestamp'],
        orangeVacancy = json['orange-vacancy'],
        purpleContent = json['purple-content'],
        purpleStrikes = json['purple-strikes'],
        purpleTimestamp = json['purple-timestamp'],
        purpleVacancy = json['purple-vacancy'],
        redContent = json['red-content'],
        redStrikes = json['red-strikes'],
        redTimestamp = json['red-timestamp'],
        redVacancy = json['red-vacancy'],
        groupSize = json['occupancy'];

  Map<String, dynamic> toJson() => {
        'blue-content': blueContent,
        'blue-strikes': blueStrikes,
        'blue-timestamp': blueTimestamp,
        'blue-vacancy': blueVacancy,
        'green-content': greenContent,
        'green-strikes': greenStrikes,
        'green-timestamp': greenTimestamp,
        'green-vacancy': greenVacancy,
        'orange-content': orangeContent,
        'orange-strikes': orangeStrikes,
        'orange-timestamp': orangeTimestamp,
        'orange-vacancy': orangeVacancy,
        'purple-content': purpleContent,
        'purple-strikes': purpleStrikes,
        'purple-timestamp': purpleTimestamp,
        'purple-vacancy': purpleVacancy,
        'red-content': redContent,
        'red-strikes': redStrikes,
        'red-timestamp': redTimestamp,
        'red-vacancy': redVacancy,
        'occupancy': groupSize,
      };
}
