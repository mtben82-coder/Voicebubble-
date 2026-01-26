import 'package:flutter/material.dart';
import '../constants/presets.dart';
import '../models/preset.dart';
import '../services/preset_favorites_service.dart';

class PresetFilterChips extends StatefulWidget {
  final String? selectedPresetId;
  final Function(String?) onPresetSelected;
  final bool showManageButton;

  const PresetFilterChips({
    super.key,
    required this.selectedPresetId,
    required this.onPresetSelected,
    this.showManageButton = true,
  });

  @override
  State<PresetFilterChips> createState() => _PresetFilterChipsState();
}

class _PresetFilterChipsState extends State<PresetFilterChips> {
  final PresetFavoritesService _favoritesService = PresetFavoritesService();
  List<String> _favoritePresetIds = [];
  bool _showAllPresets = false;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoritesService.getFavorites();
    setState(() {
      _favoritePresetIds = favorites;
    });
  }

  List<Preset> _getVisiblePresets() {
    final allPresets = AppPresets.allPresets;
    
    if (_showAllPresets) {
      return allPresets;
    }
    
    // If no favorites, show first 5 presets
    if (_favoritePresetIds.isEmpty) {
      return allPresets.take(5).toList();
    }
    
    // Show only favorited presets
    return allPresets.where((preset) => _favoritePresetIds.contains(preset.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visiblePresets = _getVisiblePresets();
    final backgroundColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // "All" chip
                    _buildFilterChip(
                      label: 'All',
                      icon: Icons.apps,
                      color: const Color(0xFF64748B),
                      isSelected: widget.selectedPresetId == null,
                      onTap: () => widget.onPresetSelected(null),
                    ),
                    const SizedBox(width: 8),
                    
                    // Preset chips
                    ...visiblePresets.map((preset) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterChip(
                        label: preset.name,
                        icon: preset.icon,
                        color: preset.color ?? const Color(0xFF3B82F6),
                        isSelected: widget.selectedPresetId == preset.id,
                        onTap: () => widget.onPresetSelected(preset.id),
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
            
            // Manage button
            if (widget.showManageButton)
              Container(
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  onPressed: () => _showManagePresetsDialog(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  icon: Icon(
                    _showAllPresets ? Icons.check : Icons.tune,
                    size: 20,
                    color: textColor,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final textColor = Colors.white;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withOpacity(isSelected ? 1.0 : 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? textColor : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showManagePresetsDialog() {
    showDialog(
      context: context,
      builder: (context) => _ManagePresetsDialog(
        favoritePresetIds: _favoritePresetIds,
        onFavoritesChanged: (newFavorites) {
          setState(() {
            _favoritePresetIds = newFavorites;
          });
        },
      ),
    );
  }
}

class _ManagePresetsDialog extends StatefulWidget {
  final List<String> favoritePresetIds;
  final Function(List<String>) onFavoritesChanged;

  const _ManagePresetsDialog({
    required this.favoritePresetIds,
    required this.onFavoritesChanged,
  });

  @override
  State<_ManagePresetsDialog> createState() => _ManagePresetsDialogState();
}

class _ManagePresetsDialogState extends State<_ManagePresetsDialog> {
  late List<String> _tempFavorites;
  final PresetFavoritesService _favoritesService = PresetFavoritesService();

  @override
  void initState() {
    super.initState();
    _tempFavorites = List.from(widget.favoritePresetIds);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF1A1A1A);
    final surfaceColor = const Color(0xFF2A2A2A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: const Color(0xFFFBBF24), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Manage Quick Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Star presets to show them in the quick filter bar',
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppPresets.allPresets.length,
                itemBuilder: (context, index) {
                  final preset = AppPresets.allPresets[index];
                  final isFavorited = _tempFavorites.contains(preset.id);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isFavorited) {
                            _tempFavorites.remove(preset.id);
                          } else {
                            _tempFavorites.add(preset.id);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isFavorited
                                ? const Color(0xFFFBBF24)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: (preset.color ?? const Color(0xFF3B82F6))
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                preset.icon,
                                size: 20,
                                color: preset.color ?? const Color(0xFF3B82F6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    preset.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                  if (preset.description.isNotEmpty)
                                    Text(
                                      preset.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              isFavorited ? Icons.star : Icons.star_border,
                              color: isFavorited
                                  ? const Color(0xFFFBBF24)
                                  : secondaryTextColor,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _favoritesService.saveFavorites(_tempFavorites);
                  widget.onFavoritesChanged(_tempFavorites);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
