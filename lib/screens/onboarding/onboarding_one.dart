import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';

class OnboardingOne extends StatelessWidget {
  final VoidCallback onNext;
  
  const OnboardingOne({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return PurplePinkGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(32, 48, 32, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      // Icon
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFA855F7), Color(0xFFEC4899)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFA855F7).withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Title
                      const Text(
                        'Speak. Write. Done.',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'Stop typing. Just talk, and get perfectly written messages instantly.',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xFFE9D5FF),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Fixed button at bottom
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF581C87),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

