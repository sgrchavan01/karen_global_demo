import 'package:flutter/material.dart';
import 'package:simple_flutter_challenge/src/splash_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(  
      debugShowCheckedModeBanner: false,
      title: 'Kraken Global',
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
