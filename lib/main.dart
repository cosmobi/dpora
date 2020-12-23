import 'package:flutter/material.dart';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// get the screen width and height for responsive design
    final screenSize = MediaQuery.of(context).size;
    final double tileHeight = screenSize.height / 2;
    final double tileWidth = screenSize.width / 2;

    return MaterialApp(
      title: 'dpora',
      home: Scaffold(
        body: Column(
          children: <Widget>[
            // top simbox
            Text('simbox will go here'),
            // middle chat tiles
            Expanded(
              child: GridView.count(
                padding:
                    const EdgeInsets.all(8), // left & right screen edge padding
                crossAxisCount: 2, // 2 tiles per row
                crossAxisSpacing:
                    8, // vertical space between left & right tiles
                mainAxisSpacing:
                    8, // horizontal space between top & bottom tiles
                childAspectRatio: tileWidth / tileHeight, // responsive tile size
                physics:
                    NeverScrollableScrollPhysics(), // to disable GridView's scrolling
                //shrinkWrap: true, // uncomment if you get infinite size error
                children: <Widget>[
                  Container(
                    padding:
                        const EdgeInsets.all(20), // padding space within tile
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
            ),
            // bottom user input
            Text('user input will go here'),
          ],
        ),
      ),
    );
  }
}
