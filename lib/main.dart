import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text('firebase_core', style: TextStyle(fontSize: 22))),
          Center(child: Text('firebase_auth', style: TextStyle(fontSize: 22))),
          Center(
            child: Text('cloud_firestore', style: TextStyle(fontSize: 22)),
          ),
          Center(child: Text('flutter_bloc', style: TextStyle(fontSize: 22))),
          Center(child: Text('equatable', style: TextStyle(fontSize: 22))),
          Center(child: Text('get_it', style: TextStyle(fontSize: 22))),
          Center(child: Text('dartz', style: TextStyle(fontSize: 22))),
          Center(
            child: Text('injectable_generator', style: TextStyle(fontSize: 22)),
          ),
          Center(child: Text('build_runner', style: TextStyle(fontSize: 22))),
        ],
      ),
    );
  }
}
