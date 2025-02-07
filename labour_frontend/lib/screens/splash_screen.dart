// lib/screens/splash_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 🚀 SplashScreen: Displays a branded splash screen with a rotating "work" icon.
/// After a 2-second delay (splashDuration) and a fade-out (fadeDuration),
/// it navigates to the LoginScreen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  double _opacity = 1.0;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    Future.delayed(AppDurations.splashDuration, () {
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(AppDurations.fadeDuration, () {
        setState(() {
          _visible = false;
        });
        Navigator.pushReplacementNamed(context, '/login');
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: _visible
          ? AnimatedOpacity(
              opacity: _opacity,
              duration: AppDurations.fadeDuration,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _rotationController,
                      child: const Icon(
                        Icons.work,
                        size: 60,
                        color: Colors.white,
                      ),
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationController.value * 2 * pi,
                          child: child,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Labor Marketplace',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
