import 'package:flutter/material.dart';

// wrap DporaApp widget within a MaterialApp widget
void main() => runApp(MaterialApp(home: DporaApp()));

class DporaApp extends StatefulWidget {
  @override
  _DporaAppState createState() => _DporaAppState();
}

class _DporaAppState extends State<DporaApp> {
  var isWideScreen = false;

  @override
  Widget build(BuildContext context) {

// get the screen width and height for responsive design
    final screenSize = MediaQuery.of(context).size;
    //final double tileHeight = screenSize.height / 2;
    final double tileWidth = screenSize.width / 2;

    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        if (tileWidth > 300) {
          isWideScreen = true;
        } else {
          isWideScreen = false;
        }

        return Row(children: <Widget>[
          new Column(children: <Widget>[

          Text('simbox here', textAlign: TextAlign.center,),

          isWideScreen ? Text('user input', textAlign: TextAlign.center,) :
          Expanded(
            child: 
            Text('4 square narrow view', textAlign: TextAlign.center,)
          ),
          isWideScreen ? Container() : Text('user input', textAlign: TextAlign.center,),
          ]),
           // now need to put second column here
            // if large screen than add titles there
            // else put empty container.... container();
          new Column(children: <Widget>[
          isWideScreen ? 
          Expanded(
            child: 
            Text('4 square wide view', textAlign: TextAlign.center,)
          )
           : Container(),
          ]),
        ]);
      }),
    );
  }
}