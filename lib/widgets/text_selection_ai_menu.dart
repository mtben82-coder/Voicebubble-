import 'package:flutter/material.dart';
import '../services/refinement_service.dart';

class TextSelectionAIMenu extends StatefulWidget {
  final String selectedText;
  final Function(String newText) onReplace;
  final VoidCallback onDismiss;

  const TextSelectionAIMenu({
    super.key,
    required this.selectedText,
    required this.onReplace,
    required this.onDismiss,
  });

  @override
  State<TextSelectionAIMenu> createState() => _TextSelectionAIMenuState();
}

class _TextSelectionAIMenuState extends State<TextSelectionAIMenu> {
  bool _isLoading = false;
  String? _activeAction;
  final _refinementService = RefinementService();

  Future<void> _handleAction(String actionId) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _activeAction = actionId;
    });

    try {
      String result;

      switch (actionId) {
        case 'rewrite':
          result = await _refinementService.refineText(
            widget.selectedText,
            RefinementType.professional,
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
            content: Text('Failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
        widget.onDismiss();
      }
    }
  }

  Widget _buildChip(String id, String label, IconData icon, Color color) {
    final isActive = _activeAction == id;
    
    return GestureDetector(
      onTap: () => _handleAction(id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.3) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive && _isLoading)
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              )
            else
              Icon(icon, size: 10, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Compact action chips
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              _buildChip('rewrite', 'Rewrite', Icons.auto_awesome, const Color(0xFF8B5CF6)),
              _buildChip('shorten', 'Shorten', Icons.compress, const Color(0xFFF59E0B)),
              _buildChip('expand', 'Expand', Icons.expand, const Color(0xFF3B82F6)),
              _buildChip('professional', 'Pro', Icons.work, const Color(0xFF0891B2)),
              _buildChip('casual', 'Casual', Icons.mood, const Color(0xFF10B981)),
              _buildChip('grammar', 'Grammar', Icons.check, const Color(0xFFEC4899)),
            ],
          ),
        ],
      ),
    );
  }
}
