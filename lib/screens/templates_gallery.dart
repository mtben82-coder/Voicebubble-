import 'package:flutter/material.dart';
import '../models/template.dart';
import '../models/recording_item.dart';
import '../services/templates_service.dart';

class TemplatesGallery extends StatefulWidget {
  final Function(RecordingItem) onTemplateSelected;

  const TemplatesGallery({
    super.key,
    required this.onTemplateSelected,
  });

  @override
  State<TemplatesGallery> createState() => _TemplatesGalleryState();
}

class _TemplatesGalleryState extends State<TemplatesGallery> {
  final _templatesService = TemplatesService();
  TemplateCategory? _selectedCategory;
  String _searchQuery = '';

  List<Template> get _filteredTemplates {
    var templates = _selectedCategory == null
        ? _templatesService.getAllTemplates()
        : _templatesService.getTemplatesByCategory(_selectedCategory!);

    if (_searchQuery.isNotEmpty) {
      templates = _templatesService.searchTemplates(_searchQuery);
    }

    return templates;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);
    final primaryColor = const Color(0xFF3B82F6);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Templates',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  '${_filteredTemplates.length} templates available',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Search bar
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Search templates...',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    prefixIcon: Icon(Icons.search, color: secondaryTextColor),
                    filled: true,
                    fillColor: surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Category filters
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _CategoryChip(
                  label: 'All',
                  isSelected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                  surfaceColor: surfaceColor,
                  primaryColor: primaryColor,
                  textColor: textColor,
                ),
                ...TemplateCategory.values.map((category) {
                  return _CategoryChip(
                    label: '${category.emoji} ${category.displayName}',
                    isSelected: _selectedCategory == category,
                    onTap: () => setState(() => _selectedCategory = category),
                    surfaceColor: surfaceColor,
                    primaryColor: primaryColor,
                    textColor: textColor,
                  );
                }),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Templates grid
          Expanded(
            child: _filteredTemplates.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: secondaryTextColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No templates found',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _filteredTemplates.length,
                    itemBuilder: (context, index) {
                      final template = _filteredTemplates[index];
                      return _TemplateCard(
                        template: template,
                        onTap: () {
                          final note = template.toRecordingItem();
                          widget.onTemplateSelected(note);
                        },
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color surfaceColor;
  final Color primaryColor;
  final Color textColor;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.surfaceColor,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : surfaceColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final Template template;
  final VoidCallback onTap;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryTextColor;

  const _TemplateCard({
    required this.template,
    required this.onTap,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF000000),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Text(
                template.icon,
                style: const TextStyle(fontSize: 32),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Expanded(
                      child: Text(
                        template.description,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        template.category.displayName,
                        style: const TextStyle(
                          color: Color(0xFF3B82F6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
