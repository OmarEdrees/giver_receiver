import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/Donor/items_services/items_services.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/my_items_servises/my_items_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:giver_receiver/presentation/widgets/items_screen/filter_items_bottom_sheet.dart';
import 'package:giver_receiver/presentation/widgets/items_screen/user_items_card/user_items_card.dart';
import 'package:giver_receiver/presentation/widgets/Recipient/save_items_screen/SaveItemManager.dart';

class SaveItemsScreen extends StatefulWidget {
  const SaveItemsScreen({super.key});

  @override
  State<SaveItemsScreen> createState() => _SaveItemsScreenState();
}

class _SaveItemsScreenState extends State<SaveItemsScreen> {
  List<Map<String, dynamic>> savedItems = [];
  List<Map<String, dynamic>> filteredSavedItems = [];
  bool isLoading = true;
  final ItemsServices _controller = ItemsServices();

  @override
  void initState() {
    super.initState();
    loadSavedItems();
    _controller.loadCategories();
  }

  Future<void> loadSavedItems() async {
    setState(() {
      isLoading = true;
    });

    final savedIds = await SaveItemManager.getSavedItems();

    final List<Map<String, dynamic>>? allItems = await MyItemsServices()
        .getAllItems();

    savedItems = allItems!
        .where((item) => savedIds.contains(item['id']))
        .toList();

    filteredSavedItems = List.from(savedItems);

    setState(() {
      isLoading = false;
    });
  }

  void applySearch(String query) {
    final search = query.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredSavedItems = List.from(savedItems);
      } else {
        filteredSavedItems = savedItems.where((item) {
          final title = item['title'].toString().toLowerCase();
          final desc = item['description'].toString().toLowerCase();
          return title.contains(search) || desc.contains(search);
        }).toList();
      }
    });
  }

  void applyFilters({String? condition, String? categoryId}) {
    setState(() {
      filteredSavedItems = savedItems.where((item) {
        final matchesCondition =
            condition == null ||
            condition.isEmpty ||
            item['condition'] == condition;
        final matchesCategory =
            categoryId == null ||
            categoryId.isEmpty ||
            item['category_id'].toString() == categoryId;
        return matchesCondition && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(icon: Icons.save, title: "Save Items"),
          const SizedBox(height: 15),

          // ------------------ البحث ------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextFormField(
                    controller: saveScreenSearch,
                    cursorColor: AppColors().primaryColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search for item',
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors().primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: applySearch,
                  ),
                ),

                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(25),
                          ),
                        ),
                        builder: (context) {
                          return FilterItemBottomSheet(
                            categoriesList: _controller.categoriesList,
                          );
                        },
                      );

                      if (result != null) {
                        applyFilters(
                          condition: result["condition"],
                          categoryId: result["category_id"],
                        );
                      }
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.filter_list,
                        color: AppColors().primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : filteredSavedItems.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: const Center(child: Text("No saved items found")),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredSavedItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredSavedItems[index];
                      final List<String> imageUrls = item['images'] != null
                          ? List<String>.from(item['images'])
                          : [];
                      final time = formatTime(item['created_at'] ?? '');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: UserItemsCard(
                          itemId: item['id'],
                          title: item['title'],
                          description: item['description'],
                          timeAgo: time,
                          imageUrls: imageUrls,
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
