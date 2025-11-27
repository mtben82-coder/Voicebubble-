import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state_provider.dart';
import '../../constants/presets.dart';
import '../../models/preset.dart';
import 'recording_screen.dart';
import 'result_screen.dart';

class PresetSelectionScreen extends StatelessWidget {
  final bool fromRecording;
  
  const PresetSelectionScreen({
    super.key,
    this.fromRecording = false,
  });
  
  void _handlePresetSelection(BuildContext context, Preset preset) {
    final appState = context.read<AppStateProvider>();
    appState.setSelectedPreset(preset);
    
    if (fromRecording && appState.transcription.isNotEmpty) {
      // Coming from recording with transcription, go to result
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResultScreen(),
        ),
      );
    } else {
      // Go to recording
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RecordingScreen(),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F5F7);
    final surfaceColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280);
    final primaryColor = isDark ? const Color(0xFFA855F7) : const Color(0xFF9333EA);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: textColor, size: 20),
                    ),
                  ),
                  Text(
                    'Choose Style',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Custom preset creation
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'Custom',
                          style: TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Preset Categories List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: AppPresets.categories.length,
                itemBuilder: (context, categoryIndex) {
                  final category = AppPresets.categories[categoryIndex];
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Header
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, top: 16),
                        child: Text(
                          category.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: secondaryTextColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      
                      // Presets in Category
                      ...category.presets.map((preset) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildPresetCard(
                            context,
                            preset,
                            surfaceColor,
                            textColor,
                            secondaryTextColor,
                            primaryColor,
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPresetCard(
    BuildContext context,
    Preset preset,
    Color surfaceColor,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
  ) {
    return GestureDetector(
      onTap: () => _handlePresetSelection(context, preset),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              preset.icon,
              size: 24,
              color: primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preset.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preset.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: secondaryTextColor,
            ),
          ],
        ),
      ),
    );
  }
}

