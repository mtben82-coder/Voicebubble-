import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/text_transformation_service.dart';

// ============================================================
//        AI ACTIONS MENU WIDGET
// ============================================================
//
// Elite AI-powered text transformation popup.
// Appears when user selects text - the viral feature!
//
// ============================================================

class AIActionsMenu extends StatefulWidget {
  final String selectedText;
  final TextSelection selection;
  final Offset position;
  final Function(String newText) onTextReplaced;
  final VoidCallback onDismiss;
  final String? documentContext;

  const AIActionsMenu({
    super.key,
    required this.selectedText,
    required this.selection,
    required this.position,
    required this.onTextReplaced,
    required this.onDismiss,
    this.documentContext,
  });

  @override
  State<AIActionsMenu> createState() => _AIActionsMenuState();
}

class _AIActionsMenuState extends State<AIActionsMenu>
    with TickerProviderStateMixin {
  final _transformationService = TextTransformationService();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  
  bool _isProcessing = false;
  AIAction? _processingAction;

  // Elite AI actions in priority order
  final List<AIAction> _primaryActions = [
    AIAction.rewrite,
    AIAction.expand,
    AIAction.shorten,
    AIAction.makeProfessional,
    AIAction.makeCasual,
    AIAction.fixGrammar,
  ];

  final List<AIAction> _secondaryActions = [
    AIAction.translate,
    AIAction.summarize,
    AIAction.makeCreative,
    AIAction.makePersuasive,
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animateIn();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  void _animateIn() {
    _animationController.forward();
  }

  void _animateOut() async {
    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 120, // Center the menu
      top: widget.position.dy - 60, // Position above selection
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                        blurRadius: 40,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Actions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _animateOut,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Primary Actions
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            ..._primaryActions.map((action) => _buildActionButton(action, isPrimary: true)),
                            
                            // Divider
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              height: 1,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            
                            // Secondary Actions
                            ..._secondaryActions.map((action) => _buildActionButton(action, isPrimary: false)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(AIAction action, {required bool isPrimary}) {
    final isProcessing = _isProcessing && _processingAction == action;
    final icon = TextTransformationService.getActionIcon(action);
    final name = TextTransformationService.getActionDisplayName(action);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isProcessing ? null : () => _handleAction(action),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isPrimary 
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isPrimary 
                  ? Border.all(color: Colors.white.withValues(alpha: 0.1))
                  : null,
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isPrimary 
                        ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: isProcessing
                        ? SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isPrimary ? const Color(0xFF3B82F6) : Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            icon,
                            style: const TextStyle(fontSize: 14),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Action name
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: isProcessing ? 0.5 : 1.0),
                      fontSize: 13,
                      fontWeight: isPrimary ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ),
                
                // Keyboard shortcut hint for primary actions
                if (isPrimary && !isProcessing)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getShortcutHint(action),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getShortcutHint(AIAction action) {
    switch (action) {
      case AIAction.rewrite:
        return '⌘R';
      case AIAction.expand:
        return '⌘E';
      case AIAction.shorten:
        return '⌘S';
      case AIAction.makeProfessional:
        return '⌘P';
      case AIAction.makeCasual:
        return '⌘C';
      case AIAction.fixGrammar:
        return '⌘G';
      default:
        return '';
    }
  }

  Future<void> _handleAction(AIAction action) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _processingAction = action;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Special handling for translation
      if (action == AIAction.translate) {
        await _handleTranslation();
        return;
      }

      // Transform the text
      final result = await _transformationService.transformText(
        text: widget.selectedText,
        action: action,
        context: widget.documentContext,
      );

      if (result.success) {
        // Success haptic
        HapticFeedback.mediumImpact();
        
        // Replace the text
        widget.onTextReplaced(result.transformedText);
        
        // Close menu after brief delay
        await Future.delayed(const Duration(milliseconds: 300));
        _animateOut();
      } else {
        // Error handling
        _showError(result.error ?? 'Transformation failed');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingAction = null;
        });
      }
    }
  }

  Future<void> _handleTranslation() async {
    // Show language selection dialog
    final languages = await _transformationService.getAvailableLanguages();
    
    if (!mounted) return;

    final selectedLanguage = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _LanguageSelectionDialog(languages: languages),
    );

    if (selectedLanguage != null && mounted) {
      final result = await _transformationService.transformText(
        text: widget.selectedText,
        action: AIAction.translate,
        targetLanguage: selectedLanguage['code'],
      );

      if (result.success) {
        HapticFeedback.mediumImpact();
        widget.onTextReplaced(result.transformedText);
        await Future.delayed(const Duration(milliseconds: 300));
        _animateOut();
      } else {
        _showError(result.error ?? 'Translation failed');
      }
    }
  }

  void _showError(String error) {
    HapticFeedback.heavyImpact();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI Error: $error'),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
}

class _LanguageSelectionDialog extends StatelessWidget {
  final List<Map<String, String>> languages;

  const _LanguageSelectionDialog({required this.languages});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 300,
        height: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.translate, color: Color(0xFF3B82F6)),
                const SizedBox(width: 12),
                const Text(
                  'Select Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final language = languages[index];
                  return ListTile(
                    title: Text(
                      language['name']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () => Navigator.pop(context, language),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}