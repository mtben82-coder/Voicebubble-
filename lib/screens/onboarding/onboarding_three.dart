import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';

class OnboardingThree extends StatelessWidget {
  final VoidCallback onNext;
  
  const OnboardingThree({super.key, required this.onNext});
  
  @override
  Widget build(BuildContext context) {
    return EmeraldTealGradient(
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
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Title
                      const Text(
                        'Works Everywhere',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Description
                      const Text(
                        'A floating bubble appears over any app. WhatsApp, Gmail, Instagram — anywhere you type.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFA7F3D0),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      // App Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildAppIcon(Icons.chat_bubble_outline),
                          const SizedBox(width: 16),
                          _buildAppIcon(Icons.email_outlined),
                          const SizedBox(width: 16),
                          _buildAppIcon(Icons.language),
                        ],
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
                      foregroundColor: const Color(0xFF064E3B),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Enable Bubble',
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
  
  Widget _buildAppIcon(IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Icon(
        icon,
        size: 32,
        color: Colors.white,
      ),
    );
  }
}

