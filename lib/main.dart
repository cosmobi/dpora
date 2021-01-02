import 'package:flutter/material.dart';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

class _DporaAppState extends State<DporaApp> {
  // updatable content from DB
  String stimText =
      'Mind on your money, or money on your mind? And would you rather sip on gin or juice, or both?';
  Color userColor = Colors.greenAccent; // userText updated in userOutput below
  String tileTextLT = 'left top text here';
  Color textColorLT = Colors.orangeAccent;
  String tileTextLB = 'left bottom text here';
  Color textColorLB = Colors.blueAccent;
  String tileTextRT =
      'this text is about 25 words or something maybe longer. this text is about 25 words or maybe shorter. this text is about 25 words or so.';
  Color textColorRT = Colors.purpleAccent;
  String tileTextRB = 'right bottom text here';
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
      child: Text(
        stimText,
        style: TextStyle(
            fontSize: textSize,
            color: Colors.yellow), // yellowAccent is too bright
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.black,
      ),
    );
  }

  Widget _userInput() {
    return TextField(
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
        labelStyle: TextStyle(color: userColor),
        labelText: 'You\'re anonymous & responses are erased after 30 seconds.',
        hintText: 'Type here and hit enter on the keyboard.',
      ),
      autofocus: true,
    );
  }

  Widget _userOutput(textSize) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: userColor),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.black,
      ),
      child: Text('what the user wrote goes here',
          style: TextStyle(fontSize: textSize, color: userColor)),
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
        color: Colors.black,
      ),
      child: SingleChildScrollView(
        child: Text(
          tileText,
          style: TextStyle(fontSize: textSize, color: textColor),
        ),
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
      children: [
        Expanded(
          child: Container(),
        ), // spacer
        Container(
          height: MediaQuery.of(context).size.height * 0.23, //23%
          width: MediaQuery.of(context).size.width, //100%
          child: _stimulus(24),
        ),
        Expanded(
          child: Container(),
        ), // spacer
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
        Expanded(
          child: Container(),
        ), // spacer
        Container(
          width: MediaQuery.of(context).size.width,
          child: _userOutput(18), // font size 18
        ),
        Expanded(
          child: Container(),
        ), // spacer
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: _userInput(),
        ),
        Expanded(
          child: Container(),
        ), // spacer
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
    return Column(children: [
      Expanded(
        child: Container(),
      ), // spacer
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
      Expanded(
        child: Container(),
      ), // spacer
      Container(
        width: MediaQuery.of(context).size.width * 0.95, //95%
        padding: EdgeInsets.all(10),
        child: _userInput(),
      ),
      Expanded(
        child: Container(),
      ), // spacer
    ]);
  }
}
