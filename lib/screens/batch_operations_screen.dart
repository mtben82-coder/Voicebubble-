import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recording_item.dart';
import '../services/batch_operations_service.dart';
import '../providers/app_state_provider.dart';

class BatchOperationsScreen extends StatefulWidget {
  final List<RecordingItem> allNotes;
  final Function(List<RecordingItem>) onComplete;

  const BatchOperationsScreen({
    super.key,
    required this.allNotes,
    required this.onComplete,
  });

  @override
  State<BatchOperationsScreen> createState() => _BatchOperationsScreenState();
}

class _BatchOperationsScreenState extends State<BatchOperationsScreen> {
  final Set<String> _selectedIds = {};
  final _batchService = BatchOperationsService();

  bool get _hasSelection => _selectedIds.isNotEmpty;
  bool get _allSelected => _selectedIds.length == widget.allNotes.length;

  List<RecordingItem> get _selectedNotes {
    return widget.allNotes.where((n) => _selectedIds.contains(n.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);
    final primaryColor = const Color(0xFF3B82F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            widget.onComplete(_selectedNotes);
            Navigator.pop(context);
          },
        ),
        title: Text(
          _hasSelection
              ? '${_selectedIds.length} selected'
              : 'Select Notes',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _toggleSelectAll,
            child: Text(
              _allSelected ? 'Deselect All' : 'Select All',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Notes list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.allNotes.length,
              itemBuilder: (context, index) {
                final note = widget.allNotes[index];
                final isSelected = _selectedIds.contains(note.id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _toggleSelection(note.id),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Colors.white.withOpacity(0.1),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Checkbox
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isSelected ? primaryColor : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? primaryColor : secondaryTextColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),

                          const SizedBox(width: 16),

                          // Note info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.customTitle ?? _getPreviewText(note.finalText),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  note.formattedDate,
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Action bar
          if (_hasSelection)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    _ActionButton(
                      icon: Icons.delete,
                      label: 'Delete',
                      color: const Color(0xFFEF4444),
                      onTap: _showDeleteConfirmation,
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.local_offer,
                      label: 'Tag',
                      color: primaryColor,
                      onTap: _showTagOptions,
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.download,
                      label: 'Export',
                      color: const Color(0xFF10B981),
                      onTap: _exportSelected,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        _selectedIds.clear();
      } else {
        _selectedIds.addAll(widget.allNotes.map((n) => n.id));
      }
    });
  }

  String _getPreviewText(String text) {
    if (text.isEmpty) return 'Untitled';
    final firstLine = text.split('\n').first.trim();
    return firstLine.length > 50 ? '${firstLine.substring(0, 47)}...' : firstLine;
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Delete Notes?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${_selectedIds.length} note(s)? This cannot be undone.',
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteSelected();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteSelected() async {
    final appState = context.read<AppStateProvider>();
    await _batchService.deleteNotes(_selectedNotes, appState);

    setState(() {
      _selectedIds.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes deleted'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      widget.onComplete([]);
      Navigator.pop(context);
    }
  }

  void _showTagOptions() {
    // Show tag selection - simplified for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add tags to ${_selectedIds.length} notes'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  Future<void> _exportSelected() async {
    if (_selectedNotes.length == 1) {
      // Single note - use existing export dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Use the export option in the note menu'),
          backgroundColor: Color(0xFF3B82F6),
        ),
      );
    } else {
      // Multiple notes - export as text with all content
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exporting ${_selectedNotes.length} notes...'),
          backgroundColor: const Color(0xFF3B82F6),
        ),
      );
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
