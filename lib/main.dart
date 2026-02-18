import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:schedule_generator_app/home/home_view.dart';
import 'package:schedule_generator_app/splash/splash_screen.dart';

const String apiKey = "AIzaSyBAkceE9UXNhdoXWFAZT5WdnWzS57zJX-c";

void main() {
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashView(),
    );
  }
}

