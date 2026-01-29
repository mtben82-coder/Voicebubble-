import 'package:flutter/material.dart';
import '../services/refinement_service.dart';

/// AI Actions that appear when user selects text
class TextSelectionAIMenu extends StatefulWidget {
  final String selectedText;
  final Offset position;
  final Function(String newText) onReplace;
  final VoidCallback onDismiss;

  const TextSelectionAIMenu({
    super.key,
    required this.selectedText,
    required this.position,
    required this.onReplace,
    required this.onDismiss,
  });

  @override
  State<TextSelectionAIMenu> createState() => _TextSelectionAIMenuState();
}

class _TextSelectionAIMenuState extends State<TextSelectionAIMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _isLoading = false;
  String? _activeAction;
  final _refinementService = RefinementService();

  final List<_AIAction> _actions = [
    _AIAction(
      id: 'rewrite',
      icon: Icons.auto_awesome,
      label: 'Rewrite',
      color: Color(0xFF8B5CF6),
    ),
    _AIAction(
      id: 'shorten',
      icon: Icons.compress,
      label: 'Shorten',
      color: Color(0xFFF59E0B),
    ),
    _AIAction(
      id: 'expand',
      icon: Icons.expand,
      label: 'Expand',
      color: Color(0xFF3B82F6),
    ),
    _AIAction(
      id: 'professional',
      icon: Icons.business_center,
      label: 'Professional',
      color: Color(0xFF0891B2),
    ),
    _AIAction(
      id: 'casual',
      icon: Icons.emoji_emotions,
      label: 'Casual',
      color: Color(0xFF10B981),
    ),
    _AIAction(
      id: 'grammar',
      icon: Icons.spellcheck,
      label: 'Fix Grammar',
      color: Color(0xFFEC4899),
    ),
    _AIAction(
      id: 'translate',
      icon: Icons.translate,
      label: 'Translate',
      color: Color(0xFF6366F1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleAction(_AIAction action) async {
    if (_isLoading) return;

    // Special case: translate needs language picker
    if (action.id == 'translate') {
      _showLanguagePicker();
      return;
    }

    setState(() {
      _isLoading = true;
      _activeAction = action.id;
    });

    try {
      String result;
      
      switch (action.id) {
        case 'rewrite':
          // Use magic preset for general rewrite
          result = await _refinementService.refineText(
            widget.selectedText,
            RefinementType.professional, // Default rewrite
          );
          break;
        case 'shorten':
          result = await _refinementService.shorten(widget.selectedText);
          break;
        case 'expand':
          result = await _refinementService.expand(widget.selectedText);
          break;
        case 'professional':
          result = await _refinementService.makeProfessional(widget.selectedText);
          break;
        case 'casual':
          result = await _refinementService.makeCasual(widget.selectedText);
          break;
        case 'grammar':
          result = await _refinementService.fixGrammar(widget.selectedText);
          break;
        default:
          result = widget.selectedText;
      }

      widget.onReplace(result);
    } catch (e) {
      debugPrint('AI action error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _activeAction = null;
        });
      }
    }
  }

  void _showLanguagePicker() {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
      {'code': 'fr', 'name': 'French', 'flag': '🇫🇷'},
      {'code': 'de', 'name': 'German', 'flag': '🇩🇪'},
      {'code': 'it', 'name': 'Italian', 'flag': '🇮🇹'},
      {'code': 'pt', 'name': 'Portuguese', 'flag': '🇵🇹'},
      {'code': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
      {'code': 'ja', 'name': 'Japanese', 'flag': '🇯🇵'},
      {'code': 'ko', 'name': 'Korean', 'flag': '🇰🇷'},
      {'code': 'ar', 'name': 'Arabic', 'flag': '🇸🇦'},
      {'code': 'hi', 'name': 'Hindi', 'flag': '🇮🇳'},
      {'code': 'ru', 'name': 'Russian', 'flag': '🇷🇺'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Translate to...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: languages.map((lang) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _translateTo(lang['code']!);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          lang['name']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _translateTo(String langCode) async {
    setState(() {
      _isLoading = true;
      _activeAction = 'translate';
    });

    try {
      final result = await _refinementService.translate(
        widget.selectedText,
        langCode,
      );
      widget.onReplace(result);
    } catch (e) {
      debugPrint('Translation error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _activeAction = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: ScaleTransition(
          scale: _scaleAnim,
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF8B5CF6),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'AI Actions',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onDismiss,
                          child: Icon(
                            Icons.close,
                            color: Colors.white.withOpacity(0.5),
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Actions Grid
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _actions.map((action) {
                        final isActive = _activeAction == action.id;
                        return GestureDetector(
                          onTap: () => _handleAction(action),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? action.color.withOpacity(0.2)
                                  : const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isActive
                                    ? action.color
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isActive && _isLoading)
                                  SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        action.color,
                                      ),
                                    ),
                                  )
                                else
                                  Icon(
                                    action.icon,
                                    size: 14,
                                    color: action.color,
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  action.label,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Selected text preview
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.selectedText.length > 100
                          ? '${widget.selectedText.substring(0, 100)}...'
                          : widget.selectedText,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AIAction {
  final String id;
  final IconData icon;
  final String label;
  final Color color;

  const _AIAction({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
  });
}

// ============================================================
// HELPER: Show AI Menu on text selection
// ============================================================

/// Call this when user selects text to show the AI menu
void showTextSelectionAIMenu({
  required BuildContext context,
  required String selectedText,
  required Offset globalPosition,
  required Function(String newText) onReplace,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  // Adjust position to stay on screen
  final screenSize = MediaQuery.of(context).size;
  double left = globalPosition.dx - 140; // Center the menu
  double top = globalPosition.dy + 10;

  // Keep within screen bounds
  if (left < 16) left = 16;
  if (left + 280 > screenSize.width - 16) {
    left = screenSize.width - 280 - 16;
  }
  if (top + 300 > screenSize.height - 100) {
    top = globalPosition.dy - 310; // Show above selection
  }

  entry = OverlayEntry(
    builder: (context) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => entry.remove(),
      child: Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: Container(color: Colors.transparent),
          ),
          // Menu
          TextSelectionAIMenu(
            selectedText: selectedText,
            position: Offset(left, top),
            onReplace: (newText) {
              entry.remove();
              onReplace(newText);
            },
            onDismiss: () => entry.remove(),
          ),
        ],
      ),
    ),
  );

  overlay.insert(entry);
}
