import '../models/template.dart';
import '../constants/built_in_templates.dart';

class TemplatesService {
  // Get all templates
  List<Template> getAllTemplates() {
    return BuiltInTemplates.all;
  }

  // Get templates by category
  List<Template> getTemplatesByCategory(TemplateCategory category) {
    return BuiltInTemplates.getByCategory(category);
  }

  // Get template by ID
  Template? getTemplateById(String id) {
    return BuiltInTemplates.getById(id);
  }

  // Search templates
  List<Template> searchTemplates(String query) {
    if (query.isEmpty) return getAllTemplates();
    
    final lowercaseQuery = query.toLowerCase();
    return BuiltInTemplates.all.where((template) {
      return template.name.toLowerCase().contains(lowercaseQuery) ||
             template.description.toLowerCase().contains(lowercaseQuery) ||
             template.category.displayName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get templates count by category
  Map<TemplateCategory, int> getTemplatesCountByCategory() {
    final counts = <TemplateCategory, int>{};
    
    for (var category in TemplateCategory.values) {
      counts[category] = getTemplatesByCategory(category).length;
    }
    
    return counts;
  }

  // Get featured templates (first 3 from each category)
  List<Template> getFeaturedTemplates() {
    final featured = <Template>[];
    
    for (var category in TemplateCategory.values) {
      final categoryTemplates = getTemplatesByCategory(category);
      featured.addAll(categoryTemplates.take(2)); // 2 from each category
    }
    
    return featured;
  }
}
