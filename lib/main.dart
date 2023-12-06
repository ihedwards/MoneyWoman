import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        bottomNavigationBar: GNav(
      tabs: [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(icon: Icons.home, text: 'Home'),
        GButton(
          icon: Icons.search,
          text: 'Search',
        ),
        GButton(icon: Icons.home),
      ],
    ));
  }
}
