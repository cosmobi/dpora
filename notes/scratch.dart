// // local_imports

// String stimText = '';

// var stimuliTotals;

// String randomCategory = categoryList[randomCats.nextInt(categoryList.length)];

// int randomStimulus;

// int randomAds;
// int randomDebates;

// class StimuliTotals {
//   final int ads;
//   final int debates;

//   StimuliTotals(this.ads, this.debates);

//   StimuliTotals.fromJson(Map<String, int> json)
//       : ads = json['ads'],
//         debates = json['debates'];
// }

// class Stimulus {
//   final int flagged;
//   final String author;
//   final String stimulus;
//   final String type;

//   Stimulus(this.flagged, this.author, this.stimulus, this.type);

//   Stimulus.fromJson(Map<String, dynamic> json)
//       : flagged = json['flagged'],
//         author = json['author'],
//         stimulus = json['stimulus'],
//         type = json['type'];
// }

// var categoryList = [
//   'debates',
//   'debates', // 11 times
//   '...'
// ];

// // ...extends State

//   void getStimuliTotals() {
//     firebaseRTDB.child('stimuli-totals').once().then((DataSnapshot snapshot) {
//       Map<String, int> stimuliTotalsMap =
//           new Map<String, int>.from(snapshot.value);
//       setState(() {
//         stimuliTotals = StimuliTotals.fromJson(stimuliTotalsMap);
//       });
//     });
//   }

//   // Pick a stimulus
//   void getStimulus(stimuliCategory, stimulusID) {
//     firebaseRTDB
//         .child('stimuli/$stimuliCategory/$stimulusID')
//         .once()
//         .then((DataSnapshot snapshot) {
//       Map<String, dynamic> stimulusMap =
//           new Map<String, dynamic>.from(snapshot.value);
//       var stimulusDetails = Stimulus.fromJson(stimulusMap);
//       setState(() {
//         stimText = stimulusDetails.stimulus;
//       });
//     });
//   }

//   void randomStimulus(categoryChoice) {
//     if (categoryChoice == 'ads') {
//       getStimulus(categoryChoice, randomAds);
//     } else if (categoryChoice == 'debates') {
//       getStimulus(categoryChoice, randomDebates);
//     } 
//   }

//   // BuildContext...

//       getStimuliTotals();

// if (stimuliTotals == null) {
//       randomAds = 0;
//       randomDebates = 0;
//     }

//     // Choose a random stimulus
//     randomStimulus(randomCategory);