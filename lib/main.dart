import 'package:flutter/material.dart';
import 'package:flutter_bloc_crypto_app_with_api/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: Colors.tealAccent,
          brightness: Brightness.dark),
      home: HomeScreen(),
    );
  }
}
