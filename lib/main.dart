import 'package:flutter/material.dart';
import 'package:itec_parking/scr/bottomScreen.dart';
import 'package:itec_parking/scr/homeScreen.dart';
import 'package:itec_parking/scr/login.dart';

void main() {
  runApp(
    // ChangeNotifierProvider(
    // create: (context) => AuthProvider(),
    const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        // textTheme: const TextTheme(
        //   bodyMedium:
        //       TextStyle(fontWeight: FontWeight.w400), // Regular by default
        // ),
      ),
      home: BottomNavigation(),
      // home: SplashScreen(),
    );
  }
}
