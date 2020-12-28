//
// put in these lines to view the visual layout at runtime.
// import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
// (...whcih goes in the import section on the very top)
// debugPaintSizeEnabled = true; 
// (...which goes right after void main()
//
    // Text(
    //  'Kandersteg, Switzerland',
    //   style: TextStyle(
    //   color: Colors.grey[500],
    //  ),
    //
    //  Icon(
    //    Icons.star,
    //    color: Colors.red[500],
    //  ),
//
    // Color color = Theme.of(context).primaryColor;
//
    // Widget buttonSection = Container(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       _buildButtonColumn(color, Icons.call, 'CALL'),
    //       _buildButtonColumn(color, Icons.near_me, 'ROUTE'),
    //       _buildButtonColumn(color, Icons.share, 'SHARE'),
    //     ],
    //   ),
    // );
//
    // Widget chatGridSection() => Container(
    //       decoration: BoxDecoration(
    //         color: Colors.black26,
    //       ),
    //       child: Column(
    //         children: [
    //           Text("hello"),
    //           Text("goodbye"),
    //         ],
    //       ),
    //     );
//
    // Widget chatGridSection2() => Container(
    // child:
    // GridView.count(
    //       primary: false,
    //       padding: const EdgeInsets.all(4),
    //       crossAxisSpacing: 4,
    //       mainAxisSpacing: 4,
    //       crossAxisCount: 3,
    //       children: <Widget>[
    //         Container(
    //           padding: const EdgeInsets.all(20),
    //           child: Center(
    //             child: const Text('FIRST'),
    //           ),
    //           color: Colors.red,
    //         ),
    //         Container(
    //           padding: const EdgeInsets.all(20),
    //           child: Center(
    //             child: const Text('SECOND'),
    //           ),
    //           color: Colors.indigo,
    //         ),
    //         Container(
    //           padding: const EdgeInsets.all(20),
    //           child: Center(
    //             child: const Text('THIRD'),
    //           ),
    //           color: Colors.teal,
    //         ),
    //         Container(
    //           padding: const EdgeInsets.all(20),
    //           child: Center(
    //             child: const Text('FOURTH'),
    //           ),
    //           color: Colors.cyan,
    //         ),
    //       ],
    //     ),);
        //
        //      appBar: AppBar(
        //        title: Text('dpora'),
        //      ),
        // body:
        // GridView.count(
        //   primary: false,
        //   padding: const EdgeInsets.all(4),
        //   crossAxisSpacing: 4,
        //   mainAxisSpacing: 4,
        //   crossAxisCount: 3,
        //   children: <Widget>[
        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       child: Center(
        //         child: const Text('FIRST'),
        //       ),
        //       color: Colors.red,
        //     ),
        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       child: Center(
        //         child: const Text('SECOND'),
        //       ),
        //       color: Colors.indigo,
        //     ),
        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       child: Center(
        //         child: const Text('THIRD'),
        //       ),
        //       color: Colors.teal,
        //     ),
        //     Container(
        //       padding: const EdgeInsets.all(20),
        //       child: Center(
        //         child: const Text('FOURTH'),
        //       ),
        //       color: Colors.cyan,
        //     ),
        //   ],
        // ),
//
// Column(
//   children: <Widget>[
//     Text('simbox will go here'),
//     Expanded(
//       child: FittedBox(
//         fit: BoxFit.contain, // otherwise the logo will be tiny
//       //  child: const FlutterLogo(),
//       child: chatGridSection(),
//       ),
//     ),
//     // Container(
//     //   child: chatGridSection2(),
//     // ),
//     Text('user input here'),
//   ],
// )

//Image.asset(
//  'images/favicon_bg.png',
//  width: 600,
//  height: 240,
//  fit: BoxFit.cover,
//),

// Column _buildButtonColumn(Color color, IconData icon, String label) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Icon(icon, color: color),
//       Container(
//         margin: const EdgeInsets.only(top: 8),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w400,
//             color: color,
//           ),
//         ),
//       ),
//     ],
//   );
// }
