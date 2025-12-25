import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:giver_receiver/presentation/screens/on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 247, 247),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Image.asset("assets/images/logo_app.jpeg", fit: BoxFit.contain)
              .animate()
              .slide(
                duration: 1000.ms,
                begin: const Offset(1, 0),
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 1000.ms)
              .scale(duration: 1000.ms)
              .then(delay: 300.ms),
        ),
      ),
    );
  }
}
