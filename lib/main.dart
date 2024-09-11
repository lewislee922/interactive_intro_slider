import 'package:flutter/material.dart';

import 'nav_bar.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const actionStyle = TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            //Tab bar
            SizedBox.expand(
              child: Container(color: const Color.fromRGBO(105, 91, 93, 1.0)),
            ),

            Navigator(
              initialRoute: "//",
              observers: [HeroController()],
              onGenerateInitialRoutes: (navigator, initialRoute) =>
                  [MaterialPageRoute(builder: (context) => const HomePage())],
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: NavBar(
                leading: "Exchange",
                actions: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Collections", style: actionStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Lookbook", style: actionStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Magazines", style: actionStyle),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
