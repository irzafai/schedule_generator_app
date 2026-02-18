import 'dart:async';
import 'package:flutter/material.dart';
import 'package:schedule_generator_app/home/home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFa659bc),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Image(image: AssetImage('assets/img/splash.png')),
            SizedBox(height: 16), 
          ],
        ),
      ),
    );
  }
}
