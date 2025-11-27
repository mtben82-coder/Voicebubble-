import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../providers/app_state_provider.dart';
import 'preset_selection_screen.dart';
import 'result_screen.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});
  
  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _transcription = '';
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _initSpeech();
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    _speech.stop();
    super.dispose();
  }
  
  Future<void> _initSpeech() async {
    final available = await _speech.initialize();
    if (available) {
      _startListening();
    }
  }
  
  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
    });
    
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _transcription = result.recognizedWords;
        });
        context.read<AppStateProvider>().setTranscription(result.recognizedWords);
      },
    );
  }
  
  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }
  
  Future<void> _handleDone() async {
    await _stopListening();
    
    final appState = context.read<AppStateProvider>();
    
    if (_transcription.isEmpty) {
      // No transcription, go back
      if (mounted) Navigator.pop(context);
      return;
    }
    
    if (appState.selectedPreset != null) {
      // Preset already selected, process and go to result
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
        );
      }
    } else {
      // No preset, go to selection
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PresetSelectionScreen(fromRecording: true),
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F5F7);
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    
    final selectedPreset = context.watch<AppStateProvider>().selectedPreset;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 24,
              left: 24,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(48),
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: textColor,
                  ),
                ),
              ),
            ),
            
            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated microphone
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulse animation
                        if (_isListening)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 160 + (40 * _pulseController.value),
                                height: 160 + (40 * _pulseController.value),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
                                  color: const Color(0xFFEF4444).withOpacity(
                                    0.2 * (1 - _pulseController.value),
                                  ),
                                ),
                              );
                            },
                          ),
                        // Microphone button
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(160),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDC2626).withOpacity(0.5),
                                blurRadius: 40,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.mic,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    
                    // Status
                    Text(
                      _isListening ? 'Listening...' : 'Recording paused',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Speak naturally',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Selected Preset
                    if (selectedPreset != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'Using: ${selectedPreset.name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? const Color(0xFFE9D5FF) : const Color(0xFF9333EA),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),
                    
                    // Transcription
                    if (_transcription.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '"$_transcription"',
                          style: TextStyle(
                            fontSize: 16,
                            color: secondaryTextColor,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Done button
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _handleDone,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(128),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

