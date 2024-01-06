import 'package:flutter/material.dart';
import 'package:jandepak/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLanding();
  }

  _navigateToLanding() async {
    await Future.delayed(Duration(milliseconds: 5000));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 135,
              ),
              // Text(
              // 'JANDEPAK',
              //textAlign: TextAlign.center,
              //style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              //),
            ],
          ),
        ),
      ),
    );
  }
}
//       body: Column(
//         children: [
//           Container(
//             width: 400,
//             height: 800,
//             padding: const EdgeInsets.only(left: 62, right: 63),
//             clipBehavior: Clip.antiAlias,
//             decoration: BoxDecoration(color: Colors.brown),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 235,
//                   height: 207,
//                   child: Stack(
//                     children: [
//                       Image.asset('assets/logo.png'),
//                       Positioned(
//                         left: 0,
//                         top: 138,
//                         child: SizedBox(
//                           width: 235,
//                           height: 69,
//                           child: Text(
//                             'JANDEPAK',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 50,
//                               fontFamily: 'Spicy Rice',
//                               fontWeight: FontWeight.w400,
//                               height: 0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }