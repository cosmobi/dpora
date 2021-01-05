import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

class _DporaAppState extends State<DporaApp> {
  // updatable content from DB
  String stimText = 'Mind on your money. Money on your mind. Sippin on gin and juice. West Side, yall!';
  Color userColor = Colors.greenAccent; // userText updated in userOutput below
  String tileTextLT = 'left top text here';
  Color textColorLT = Colors.orangeAccent;
  String tileTextLB = 'left bottom text here';
  Color textColorLB = Colors.blueAccent;
  String tileTextRT =
      'this text is about 25 words or something maybe longer. this text is about 25 words or maybe shorter. this text is about 25 words or so.';
  Color textColorRT = Colors.purpleAccent;
  String tileTextRB = 'right bottom text here and not there';
  Color textColorRB = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dpora',
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        // appBar would go here
        body: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait
                ? _buildVerticalLayout(
                    tileTextLT,
                    textColorLT,
                    tileTextLB,
                    textColorLB,
                    tileTextRT,
                    textColorRT,
                    tileTextRB,
                    textColorRB,
                  )
                : _buildHorizontalLayout(
                    tileTextLT,
                    textColorLT,
                    tileTextLB,
                    textColorLB,
                    tileTextRT,
                    textColorRT,
                    tileTextRB,
                    textColorRB,
                  );
          },
        ),
      ),
    );
  }

  Widget _stimulus(textSize) {
    return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[900],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      icon: Icon(Icons.menu_rounded, color: Colors.grey[700],),
                      padding: EdgeInsets.zero, // need for alignment
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      icon: Icon(Icons.share_rounded, color: Colors.grey[700],),
                      padding: EdgeInsets.zero, // need for alignment
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      icon: Icon(Icons.threesixty_rounded, color: Colors.grey[700],),
                      padding: EdgeInsets.zero, // need for alignment
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: IconButton(
                      icon: Icon(Icons.cancel_presentation_rounded, color: Colors.grey[700],),
                      padding: EdgeInsets.zero, // need for alignment
                      onPressed: () {},
                    ),
                  ),
                ]
            ),
            Flexible(
              child: 
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                child: Text(
                  stimText,
                  style: TextStyle(
                      fontSize: textSize,
                      color: Colors.yellow, //yellowAccent is too bright
                      ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _userInput() {
    return TextField(
      style: TextStyle(color: userColor),
      cursorColor: userColor,
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
        fillColor: Colors.grey[900], filled: true,
        labelText: 'Responses disappear after 30 seconds. Be brief. Be respectful.',
        labelStyle: TextStyle(color: userColor),
        hintText: 'Type here and hit enter on the keyboard.',
        hintStyle: TextStyle(color: Colors.grey[700]),
      ),
      maxLength: 255, // this is way more than needed but allows for ascii art
      //
      autofocus: true, // SET TO FALSE IF IT DOESNT GO AWAY AFTER A SUBMISSION
    //
    );
  }

  Widget _userOutput(textSize) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: userColor),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[900],
      ),
      child: 
        Text(
          'what the user wrote goes directly here',
          style: TextStyle(fontSize: textSize, color: userColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // truncates, not scrollable
        ),
    );
  }

  Widget _chatTile(tileHeight, tileWidth, textSize, tileText, textColor) {
    return Container(
      height: MediaQuery.of(context).size.height * tileHeight,
      width: MediaQuery.of(context).size.width * tileWidth,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.grey[900],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Text(
                tileText,
                style: TextStyle(fontSize: textSize, color: textColor),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible( 
                child: Text('From USA',
                  style: TextStyle(
                    fontSize: 12, 
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                  ),
                  overflow: TextOverflow.ellipsis, // truncates, not scrollable
                ),
              ),
            Row(children: [
              //
              Text('0', // NEED TO PUT A COUNTER HERE
                //
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.grey[700],
                  ),
                ),
              SizedBox(
                height: 20,
                width: 20,
                child: IconButton(
                  icon: Icon(Icons.person_remove_outlined, color: Colors.grey[700],),
                  padding: EdgeInsets.zero, // need for alignment
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ]
      ),
    ]
  ),
);
}

  Widget _buildVerticalLayout(
    tileTextLT,
    textColorLT,
    tileTextLB,
    textColorLB,
    tileTextRT,
    textColorRT,
    tileTextRB,
    textColorRB,
  ) {
    final allTileHeight = 0.2; // 20% screen height
    final allTileWidth = 0.46; // 46% screen width
    final allTextSize = 18; // 18 font size
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.23, //23%
          width: MediaQuery.of(context).size.width, //100%
          child: _stimulus(24),
        ),
        // build the chat titles, the left column (top & bottom) and right
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
                ),
                _chatTile(
                  allTileHeight,
                  allTileWidth,
                  allTextSize,
                  tileTextLB,
                  textColorLB,
                ),
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
                ),
                _chatTile(
                  allTileHeight,
                  allTileWidth,
                  allTextSize,
                  tileTextRB,
                  textColorRB,
                ),
              ],
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: _userOutput(18), // font size 18
        ),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: _userInput(),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout(
    tileTextLT,
    textColorLT,
    tileTextLB,
    textColorLB,
    tileTextRT,
    textColorRT,
    tileTextRB,
    textColorRB,
  ) {
    final allTileHeight = 0.33; // 33% screen height
    final allTileWidth = 0.21; // 21% screen width
    final allTextSize = 26; // 26 font size
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.355, //35.5%
                width: MediaQuery.of(context).size.width / 2,
                child: _stimulus(32),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.355,
                width: MediaQuery.of(context).size.width / 2,
                child: _userOutput(26), // font size 26
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
                      ),
                      _chatTile(
                        allTileHeight,
                        allTileWidth,
                        allTextSize,
                        tileTextLB,
                        textColorLB,
                      ),
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
                      ),
                      _chatTile(
                        allTileHeight,
                        allTileWidth,
                        allTextSize,
                        tileTextRB,
                        textColorRB,
                      ),
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
        padding: EdgeInsets.all(10),
        child: _userInput(),
      ),
    ]);
  }
  }
