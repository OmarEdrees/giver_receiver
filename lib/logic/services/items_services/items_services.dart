import 'package:giver_receiver/logic/services/my_items_services/my_items_servises/my_items_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ItemsServices {
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> categoriesList = [];

  Future<void> loadItems() async {
    final items = await MyItemsServices().getAllItems();
    allItems = items ?? [];
    filteredItems = allItems;
  }

  Future<void> loadCategories() async {
    final response = await Supabase.instance.client.from('categories').select();
    categoriesList = response;
  }

  void applyFilters({String? condition, String? categoryId}) {
    List<Map<String, dynamic>> temp = allItems;

    if ((condition != null && condition.isNotEmpty) ||
        (categoryId != null && categoryId.isNotEmpty)) {
      temp = temp.where((item) {
        final matchesCondition = condition != null && condition.isNotEmpty
            ? item['condition'] == condition
            : false;
        final matchesCategory = categoryId != null && categoryId.isNotEmpty
            ? item['category_id'] == categoryId
            : false;
        return matchesCondition || matchesCategory;
      }).toList();
    }

    filteredItems = temp;
  }

  void searchItems(String query) {
    final search = query.toLowerCase();
    if (query.isEmpty) {
      filteredItems = allItems;
    } else {
      filteredItems = allItems.where((item) {
        final title = item['title'].toString().toLowerCase();
        final desc = item['description'].toString().toLowerCase();
        return title.contains(search) || desc.contains(search);
      }).toList();
    }
  }
}
