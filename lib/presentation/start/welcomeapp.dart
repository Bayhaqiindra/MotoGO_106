import 'package:flutter/material.dart';
import 'package:tugas_akhir/core/core.dart';
import 'package:tugas_akhir/presentation/auth/screen/login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/startwelcome.jpg', // <- Petunjuk: tambahkan file ini ke folder assets/images/ dan daftarkan di pubspec.yaml
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    Colors.black87,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/icon.png', // <- Petunjuk: tambahkan ikon carrot ke assets/icons/ dan daftarkan juga
                    width: 250,
                  ),
                  const Text(
                    'Selamat Datang\nMoto GO ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SpaceHeight(8),
                  const Text(
                    'Get your trust in dealing with your motorbike damage',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SpaceHeight(32),
                  Button.filled(
                    label: 'Get Started',
                    onPressed: () {
                      context.push(const LoginScreen());
                    },
                    color: const Color.fromARGB(255, 58, 96, 192),
                    height: 56,
                    borderRadius: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
