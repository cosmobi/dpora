// These default totals should be updated from the DB
// but since they cannot be null and need some number...
// TODO: Update all default totals before each release

int totalAds = 1;
int totalDebates = 267;
int totalGames = 33;
int totalJokes = 152;
int totalMyths = 59;
int totalNews = 4;
int totalPassion = 65;
int totalPersonal = 757;
int totalPonder = 262;
int totalProverbs = 394;
int totalQuotes = 297;
int totalShare = 34;
int totalStimuli = 2457; // Total Sum
int totalTrivia = 132;
// *******************************************************

// Will be used to hold platform identification
String platform;

int appLaunchTime = DateTime.now().millisecondsSinceEpoch;
// Make updated copyright text
DateTime nowDate = new DateTime.now();
String nowYear = new DateTime(nowDate.year).toString().substring(0, 4);
final String copyright = 'Copyright © 2020-' + nowYear + ' dpora';

// Tally gets their latest numbers from the DB
// TODO: Update minimum tally numbers
int devicesDetected = 22;
int countriesRepresented = 2;
int commentsPosted = 83;
double latestVersion = 0.0; // keep 0.0
double minReqVersion = 1.5;
// version 1.5 adds the ability to display ads
String versionStatus = '';
bool upgradeRequired;
// TODO: Update in 3 places before every app release
// 1. on the DB
// 2. in the yaml file
// (also increment number on right side of + sign)
// 3. below this line
double thisVersion = 1.5;
//TODO this, minReqVersion (above) and YAML file were already updated to 1.5!
// DELETE THESE TWO LINES before finalizing version

// Set the opacity and duration for fading text
double userOpacity = 1.0;
double chatOpacity = 1.0;
int userFadeTime = 10; // in seconds
int chatFadeTime = 10;

// dporian info
int userBoots = 0;
int userBootstamp;
String userColorString = 'black';
String groupName = 'none';
int myGroupVacancy;
String groupOfMutedUser = '';
bool registered = false; // is user in DB?

String strikedContent = '';
// Unfortunately the user may multi-strike same stimulus with app re-launch.
// This "bug" can be avoided by saving the strikedContent in the DB user info
// but it's too expensive b/c its data will have to be continuously downloaded.
// So, just keep loophole for now. Add as sharedPref later or in DB when $ can burn.

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

// Default stimulus text must be empty like this
// so transitions between reloads are smoother
String stimulusContent = '';
String nextStimulusContent = '';
int strikesNeeded = 1; // Both set at 1 for
int stimulusStrikes = 1; // Terms of service
String stimulusCategory = '';
String stimulusInstructions = '';
String noStimulus =
    'No Internet Connection! Please turn on mobile data, WiFi or both.';
String noInstructions = 'Airplane Mode?';

// Stimuli category instructions may be updated from DB
String instructAds = 'Ad or sponsor';
String instructDebates = 'Agree or disagree';
String instructGames = 'Let\'s play a game';
String instructJokes = 'Jokes or funny truths';
String instructMyths = 'Do you know?';
String instructNews = 'What\'s new?';
String instructPassion = 'Am I right or wrong?';
String instructPersonal = 'All about you';
String instructPonder = 'Food for thought';
String instructProverbs = 'Wise, wrong or weird?';
String instructQuotes = 'Was it well said?';
String instructShare = 'Friend talk';
String instructTrivia = instructMyths;
// And this will hold the currently selected category
String instructStimulus = '';

// These variables hold all the chat activity
String blueContent = '';
int blueStrikes = 0;
int blueTimestamp = appLaunchTime;
bool blueVacancy = false;
String greenContent = '';
int greenStrikes = 0;
int greenTimestamp = appLaunchTime;
bool greenVacancy = false;
String orangeContent = '';
int orangeStrikes = 0;
int orangeTimestamp = appLaunchTime;
bool orangeVacancy = false;
String purpleContent = '';
int purpleStrikes = 0;
int purpleTimestamp = appLaunchTime;
bool purpleVacancy = false;
String redContent = '';
int redStrikes = 0;
int redTimestamp = appLaunchTime;
bool redVacancy = false;

// True = user input, false = user output
bool showTextField = true;
// This is updated when user hits Return or Enter on their keyboard
String submittedText = '';

// The slogan list and sMax can be updated from the DB
List<String> slogans = [
  'Have private yet meaningful chats with total strangers',
  'No registration. No tracking. No data mining. No spam.',
  'Educate and learn with others. Disagree and grow together.',
  'Be social and be private. The best of both worlds.',
  'Speak your mind and gain multiple perspectives',
  'Totally social. Totally private. Totally awesome!',
  'The road to peace and wisdom always starts with open dialog',
  'With true social media, everyone is active. There are no passive followers here.',
  'Finding the middle ground of our one world',
  'Micro chats, macro ideas',
  'Breakthrough the language barrier and talk to the world',
  'Global discussions, in your hands',
  'What you say is more important than how you say it',
];
int sNum = 0;
// TODO: Modify slogan list above and update sMax below
int sMax = 13;

// To change language
String translatedToEnglish = '';
String priorStimulus = '';
String translatedStimulus = '';
String priorInstructions = '';
String translatedInstructions = '';
String translatedLabel = '';
String translatedHint = '';
String translationTranslation = '';
String translatedTextLT = '';
String translatedTextLB = '';
String translatedTextRT = '';
String translatedTextRB = '';
String muteStatusTranslatedLT = '';
String muteStatusTranslatedLB = '';
String muteStatusTranslatedRT = '';
String muteStatusTranslatedRB = '';
bool needMuteStatusTranslatedLT = true;
bool needMuteStatusTranslatedLB = true;
bool needMuteStatusTranslatedRT = true;
bool needMuteStatusTranslatedRB = true;
String selectedLanguageCode = '';
List languageOptions = [
  'af -	Afrikaans',
  'ar	- Arabic',
  'be	- Belarusian',
  'bg -	Bulgarian',
  'bn -	Bengali',
  'ca -	Catalan',
  'cs -	Czech',
  'cy	- Welsh',
  'da	- Danish',
  'de	- German',
  'el	- Greek',
  'en	- English',
  'eo	- Esperanto',
  'es	- Spanish',
  'et	- Estonian',
  'fa	- Persian',
  'fi	- Finnish',
  'fr	- French',
  'ga	- Irish',
  'gl	- Galician',
  'gu	- Gujarati',
  'he	- Hebrew',
  'hi	- Hindi',
  'hr	- Croatian',
  'ht	- Haitian',
  'hu	- Hungarian',
  'id	- Indonesian',
  'is	- Icelandic',
  'it	- Italian',
  'ja	- Japanese',
  'ka	- Georgian',
  'kn	- Kannada',
  'ko	- Korean',
  'lt	- Lithuanian',
  'lv	- Latvian',
  'mk	- Macedonian',
  'mr	- Marathi',
  'ms	- Malay',
  'mt	- Maltese',
  'nl	- Dutch',
  'no	- Norwegian',
  'pl	- Polish',
  'pt	- Portuguese',
  'ro	- Romanian',
  'ru	- Russian',
  'sk	- Slovak',
  'sl	- Slovenian',
  'sq	- Albanian',
  'sv	- Swedish',
  'sw	- Swahili',
  'ta	- Tamil',
  'te	- Telugu',
  'th	- Thai',
  'tl	- Tagalog',
  'tr	- Turkish',
  'uk	- Ukrainian',
  'ur	- Urdu',
  'vi	- Vietnamese',
  'zh	- Chinese'
];

// To reduce database downloads, only download
// some stuff once per app launch or once per day
bool checkedUser = false;
bool gotSlogans = false;
bool deadTally = false;
bool ghostBusted = false;
bool gotInstructions = false;
bool stimuliTotaled = false;

// Classes below are for the serialization of
// json-formatted data to and from the database

class Tally {
  final int comments;
  final int countries;
  final int devices;
  final double minreq;
  final double version;

  Tally(this.comments, this.countries, this.devices, this.minreq, this.version);

  Tally.fromJson(Map<String, dynamic> json)
      : comments = json['comments'],
        countries = json['countries'],
        devices = json['devices'],
        minreq = json['minreq'],
        version = json['version'];

  Map<String, dynamic> toJson() => {
        'comments': comments,
        'countries': countries,
        'devices': devices,
        'minreq': minreq,
        'version': version
      };
}

class Dporian {
  final int boots;
  final int bootstamp;
  final String color;
  final String group;
  final String language;

  Dporian(this.boots, this.bootstamp, this.color, this.group, this.language);

  Dporian.fromJson(Map<String, dynamic> json)
      : boots = json['b'],
        bootstamp = json['t'],
        color = json['c'],
        group = json['g'],
        language = json['l'];

  Map<String, dynamic> toJson() =>
      {'b': boots, 't': bootstamp, 'c': color, 'g': group, 'l': language};
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
        'type': type
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
        'trivia': trivia
      };
}

class Totals {
  final int adsT;
  final int debatesT;
  final int gamesT;
  final int jokesT;
  final int mythsT;
  final int newsT;
  final int passionT;
  final int personalT;
  final int ponderT;
  final int proverbsT;
  final int quotesT;
  final int shareT;
  final int stimuliT;
  final int triviaT;

  Totals(
      this.adsT,
      this.debatesT,
      this.gamesT,
      this.jokesT,
      this.mythsT,
      this.newsT,
      this.passionT,
      this.personalT,
      this.ponderT,
      this.proverbsT,
      this.quotesT,
      this.shareT,
      this.stimuliT,
      this.triviaT);

  Totals.fromJson(Map<String, dynamic> json)
      : adsT = json['ads'],
        debatesT = json['debates'],
        gamesT = json['games'],
        jokesT = json['jokes'],
        mythsT = json['myths'],
        newsT = json['news'],
        passionT = json['passion'],
        personalT = json['personal'],
        ponderT = json['ponder'],
        proverbsT = json['proverbs'],
        quotesT = json['quotes'],
        shareT = json['share'],
        stimuliT = json['stimuli'],
        triviaT = json['trivia'];

  Map<String, dynamic> toJson() => {
        'ads': adsT,
        'debates': debatesT,
        'games': gamesT,
        'jokes': jokesT,
        'myths': mythsT,
        'news': newsT,
        'passion': passionT,
        'personal': personalT,
        'ponder': ponderT,
        'proverbs': proverbsT,
        'quotes': quotesT,
        'share': shareT,
        'stimuli': stimuliT,
        'trivia': triviaT
      };
}

class Content {
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
  final String stimulusCategory;
  final String stimulusContent;
  final String stimulusInstructions;
  final int stimulusStrikes;

  Content(
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
      this.stimulusCategory,
      this.stimulusContent,
      this.stimulusInstructions,
      this.stimulusStrikes);

  Content.fromJson(Map<String, dynamic> json)
      : blueContent = json['bc'],
        blueStrikes = json['bs'],
        blueTimestamp = json['bt'],
        blueVacancy = json['bv'],
        greenContent = json['gc'],
        greenStrikes = json['gs'],
        greenTimestamp = json['gt'],
        greenVacancy = json['gv'],
        orangeContent = json['oc'],
        orangeStrikes = json['os'],
        orangeTimestamp = json['ot'],
        orangeVacancy = json['ov'],
        purpleContent = json['pc'],
        purpleStrikes = json['ps'],
        purpleTimestamp = json['pt'],
        purpleVacancy = json['pv'],
        redContent = json['rc'],
        redStrikes = json['rs'],
        redTimestamp = json['rt'],
        redVacancy = json['rv'],
        stimulusCategory = json['scat'],
        stimulusContent = json['sc'],
        stimulusInstructions = json['si'],
        stimulusStrikes = json['ss'];

  Map<String, dynamic> toJson() => {
        'bc': blueContent,
        'bs': blueStrikes,
        'bt': blueTimestamp,
        'bv': blueVacancy,
        'gc': greenContent,
        'gs': greenStrikes,
        'gt': greenTimestamp,
        'gv': greenVacancy,
        'oc': orangeContent,
        'os': orangeStrikes,
        'ot': orangeTimestamp,
        'ov': orangeVacancy,
        'pc': purpleContent,
        'ps': purpleStrikes,
        'pt': purpleTimestamp,
        'pv': purpleVacancy,
        'rc': redContent,
        'rs': redStrikes,
        'rt': redTimestamp,
        'rv': redVacancy,
        'scat': stimulusCategory,
        'sc': stimulusContent,
        'si': stimulusInstructions,
        'ss': stimulusStrikes
      };
}
