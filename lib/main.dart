import 'package:flutter/material.dart';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

class _DporaAppState extends State<DporaApp> {
  var someText = "yada yada yada";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dpora',
      //     appBar: AppBar(),
      home: Scaffold(
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

  // Widget _simbox() {
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Icon(
  //       Icons.account_circle,
  //       size: 100.0,
  //     ),
  //   );
  // }

  // Widget _userInput() {
  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //       child: Text(
  //         someText,
  //         style: TextStyle(fontSize: 32.0),
  //       ),
  //     );
  // }

  Widget _simbox() {
    return Text('simbox goes here');
  }

  Widget _userInput() {
    return Text('user input area');
  }

  Widget _chatTiles() {
    // get the screen width and height for responsive design
    final screenSize = MediaQuery.of(context).size;
    final double tileHeight = screenSize.height / 2;
    final double tileWidth = screenSize.width / 2;
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(8), // left & right screen edge padding
        crossAxisCount: 2, // 2 tiles per row
        crossAxisSpacing: 8, // vertical space between left & right tiles
        mainAxisSpacing: 8, // horizontal space between top & bottom tiles
        childAspectRatio: tileWidth / tileHeight,
        // responsive tile size
        physics:
            NeverScrollableScrollPhysics(), // to disable GridView's scrolling
        shrinkWrap: false, 
        /* changing shrinkWrap to true will center the tiles
        in the horizontal view (landscape mode) only.
        however, it may be computationally expensive to use
        */
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20), // padding space within tile
            child: Text("Green Tile"),
            color: Colors.green[300],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text("Red Tile"),
            color: Colors.red[300],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text("Blue Tile"),
            color: Colors.blue[300],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text("Yellow Tile"),
            color: Colors.yellow[300],
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        _simbox(),
        _chatTiles(),
        _userInput(),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Column(
          children: [
            _simbox(),
            _userInput(),
          ],
        ),
        _chatTiles(),
      ],
    );
  }
}
