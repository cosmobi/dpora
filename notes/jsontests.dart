// For json serializations (encoding and decoding)
// class Category {
//   Stimuli stimuli;
//   Category({this.stimuli});
//   factory Category.fromJson(Map<String, dynamic> parsedJson) {
//     return Category(stimuli: Stimuli.fromJson(parsedJson[Key]));
//   }
// }

// class Category {
//   final List<String> stimuli;
//   Category({this.stimuli});
//   factory Category.fromJson(Map<String, dynamic> parsedJson) {
//     var jsonKey = parsedJson[Key];
//     // List<String> keyList = new List<String>.from(jsonKey); //this or next line
//     List<String> keyList = jsonKey.cast<String>();
//     return new Category(stimuli: keyList,);
//   }
// }

// class Stimuli {
//   int flagged;
//   String author;
//   String stimulus;
//   String type;

//   Stimuli({this.flagged, this.author, this.stimulus, this.type});

//   factory Stimuli.fromJson(Map<String, dynamic> json) {
//     return Stimuli(flagged: json['flagged'], author: json['author'], stimulus: json['stimulus'], type: json['type']);
//   }
// }

// try this also as a list
// class CategoryStimuli {
//   final List<Stimulus> stimuli;

//   CategoryStimuli({
//     this.stimuli,
// });

//   factory CategoryStimuli.fromJson(List<dynamic> parsedJson) {

//     List<Stimulus> stimuli = new List<Stimulus>;
//     stimuli = parsedJson.map((i)=>Stimulus.fromJson(i)).toList();

//     return new CategoryStimuli(
//       stimuli: stimuli
//     );
//   }
// }

// class CategoryStimuli {
//   Stimulus stimulus;

//   CategoryStimuli({
//     this.stimulus,
// });

//   factory CategoryStimuli.fromJson(Map<String, dynamic> parsedJson) {

//     return CategoryStimuli(
//       stimulus: Stimulus.fromJson(parsedJson[Key]) // or ['stimulus']
//     );
//   }
// }

// class Stimulus{
//   String flagged;
//   String author;
//   String stimulus;
//   String type;

//   Stimulus({
//     this.flagged,
//     this.author,
//     this.stimulus,
//     this.type
// }) ;

//   factory Stimulus.fromJson(Map<String, dynamic> json){
//     return Stimulus(
//       flagged: json['flagged'].toString(),
//       author: json['author'],
//       stimulus: json['stimulus'],
//       type: json['type'],
//     );
//   }
// }

// class StimulusCategory {
//   final Stimulus stimulusID;
//   StimulusCategory({this.stimulusID});
//   factory StimulusCategory.fromJson(Map<String, dynamic> parsedJson) {
//     // List<Stimulus> stimuli = new List<Stimulus>;
//     // keyList = parsedJson.map((i)=>Stimulus.fromJson(i)).toList();
// //
//   //  var jsonKey = parsedJson[Key];
//   //   List<String> keyList = new List<String>.from(jsonKey); //this or next line
//  //  List<String> keyList = jsonKey.cast<String>();
//     return StimulusCategory(
//      stimulusID: Stimulus.fromJson(parsedJson[Key]) // or ['stimulus']
//   //   stimulusID: keyList,) // or ['stimulus']
//     );
//   }
// }
      //
      //
      //
      // Map<String, dynamic> stimulusMap = new Map<String, dynamic>.from(snapshot.value);
      //
      // var stimulusDetails = Stimulus.fromJson(stimulusMap);
      // print(stimulusDetails.author);
      // setState(() {
      //   stimText = stimulusDetails.stimulus;
      // });
      //
      // var stimulusKey = json.decode(snapshot.value);
      // var stimulusDetails = Stimulus.fromJson(stimulusKey);
      // //print('Howdy, ${user['name']}!');
      // print(stimulusDetails);
      //
      //print('Value : ${snapshot.value}'); // TODO: for testing, uncomment later
      //
      //final jsonResponse = json.decode(snapshot.value);
      //
      //
      // setState(() {
      //   stimText = snapshot.value.toString();
      // });
      //
      //new Map<String, dynamic> stimMap = jsonDecode(snapshot.value);
      // Map<String, dynamic> map = json.decode(response.body);
      // List<dynamic> data = map["dataKey"];
      // print(data[0]["name"]);

      //print(stimulusDetails);
      //
      //
      // final jsonResponse = json.decode(snapshot.value);
      // Category games = new Category.fromJson(jsonResponse);
      // print(games.stimuli.stimulus);
      //
      // final jsonResponse = json.decode(snapshot.value);
      // CategoryStimuli games = new CategoryStimuli.fromJson(jsonResponse);
      // print(games.toString());
      // //
      // A really long way to pick a random stimulus from a category
      //   String stringy = snapshot.value.toString();
      //   String theNumAsString = stringy.substring(1, 3);
      //   int theNumAsInt = int.parse(theNumAsString);
      //   dieRoll = Random().nextInt(theNumAsInt) + 1;
      //   print(dieRoll);
      // });
      // firebaseRTDB
      //     .child('stimuli/games')
      //     .orderByKey()
      //     .equalTo(dieRoll)
      //     .once()
      //     .then((DataSnapshot data) {
      //   Map<String, dynamic> mapOfGame = jsonDecode(data.value);
      //   print(mapOfGame['stimulus']);
      // setState(() {
      //   stimText = mapOfGame['stimulus'];
      // });