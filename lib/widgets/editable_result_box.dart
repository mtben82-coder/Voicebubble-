import 'dart:async';
import 'package:flutter/material.dart';

class EditableResultBox extends StatefulWidget {
  final String initialText;
  final Function(String) onTextChanged;
  final bool isLoading;

  const EditableResultBox({
    super.key,
    required this.initialText,
    required this.onTextChanged,
    this.isLoading = false,
  });

  @override
  State<EditableResultBox> createState() => _EditableResultBoxState();
}

class _EditableResultBoxState extends State<EditableResultBox> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(EditableResultBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if text changed externally (e.g., from refinement)
    if (widget.initialText != oldWidget.initialText && 
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    // Debounce: wait 500ms after user stops typing
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onTextChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF3B82F6);
    final textColor = Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.1),
            const Color(0xFF2563EB).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: widget.isLoading
          ? Center(
              child: CircularProgressIndicator(color: primaryColor),
            )
          : TextField(
              controller: _controller,
              onChanged: _onTextChanged,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                height: 1.6,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
    );
  }
}
