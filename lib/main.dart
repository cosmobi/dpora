import 'package:flutter/material.dart';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

class _DporaAppState extends State<DporaApp> {
//  var someText = "yada yada yada";

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
                ? _buildVerticalLayout()
                : _buildHorizontalLayout();
          },
        ),
      ),
    );
  }

  Widget _stimulus() {
    var stimText = 'And you are?';
//        'Mind on your money, or money on your mind? And would you rather sip on gin or juice, or both?';
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Text(
        stimText,
        style: TextStyle(
            fontSize: 24.0, color: Colors.yellow), // yellowAccent is too bright
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellow),
        color: Colors.black,
      ),
    );
  }

  Widget _userInput(userColor) {
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

  Widget _userOutput(userColor) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: userColor),
        color: Colors.black,
      ),
      child:
          Text('text here', style: TextStyle(fontSize: 18.0, color: userColor)),
    );
  }

  Widget _chatTiles(tileHeight, tileWidth) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / tileHeight,
              width: (MediaQuery.of(context).size.width / tileWidth) - 10,
              // the -10 takes off 10% to leave room for the margin
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orangeAccent),
                color: Colors.black,
              ),
              child: Text(
                'text here for about this much space.',
                style: TextStyle(fontSize: 18.0, color: Colors.orangeAccent),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / tileHeight,
              width: (MediaQuery.of(context).size.width / tileWidth) - 10,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent),
                color: Colors.black,
              ),
              child: Text(
                'text goes here.',
                style: TextStyle(fontSize: 18.0, color: Colors.purpleAccent),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / tileHeight,
              width: (MediaQuery.of(context).size.width / tileWidth) - 10,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent),
                color: Colors.black,
              ),
              child: Text(
                'text here',
                style: TextStyle(fontSize: 18.0, color: Colors.redAccent),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / tileHeight,
              width: (MediaQuery.of(context).size.width / tileWidth) - 10,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                color: Colors.black,
              ),
              child: Text(
                'B: text goes here for about this much space. text goes here for about this much space',
                style: TextStyle(fontSize: 18.0, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 4, //20%
          width: MediaQuery.of(context).size.width, //100%
          child: _stimulus(),
        ),
        _chatTiles(5, 2),
        Container(
          width: MediaQuery.of(context).size.width,
          child: _userOutput(Colors.greenAccent),
        ),
        Expanded(
          // this will push the userInput to the bottom
          child: Container(
            color: Colors.black,
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: _userInput(Colors.greenAccent),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3, //33%
              width: MediaQuery.of(context).size.width / 2,
              child: _stimulus(),
            ),
            Expanded(
              // spacer
              child: Container(
                color: Colors.black,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 4, //25%
              width: MediaQuery.of(context).size.width / 2,
              child: _userOutput(Colors.greenAccent),
            ),
            Expanded(
              // this will push the userInput to the bottom
              child: Container(
                color: Colors.black,
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width / 2,
              child: _userInput(Colors.greenAccent),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 8, //12.5%
              width: MediaQuery.of(context).size.width / 2,
              child: Container(
                color: Colors.black,
              ),
            ),
            Container(
              child: _chatTiles(3, 4),
            ),
          ],
        )
      ],
    );
  }
}
