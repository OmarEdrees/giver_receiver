import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Donor/GetCurrentUserData/get_current_user_data.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/Donor/items_services/items_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header_items.dart';
import 'package:giver_receiver/presentation/screens/Donor/add_items_screen.dart';
import 'package:giver_receiver/presentation/widgets/items_screen/filter_items_bottom_sheet.dart';
import 'package:giver_receiver/presentation/widgets/items_screen/user_items_card/user_items_card.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ItemsServices _controller = ItemsServices();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    await _controller.loadCategories();
    await _controller.loadItems();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white, Color(0xFF17A589)],
              stops: [0.0, 0.7, 1.5],
            ),
          ),
          child: FutureBuilder(
            future: CurrentUserData().getCurrentUserData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final username = snapshot.data!['username'] ?? "Dear";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHeaderItems(icon: Icons.description, name: username),
                  const SizedBox(height: 15),

                  // ------------------ البحث ------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            child: TextFormField(
                              controller: itemScreenSearch,
                              cursorColor: AppColors().primaryColor,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: 'البحث عن عنصر',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors().primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _controller.searchItems(value);
                                });
                              },
                            ),
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
                                setState(() {
                                  _controller.applyFilters(
                                    condition: result["condition"],
                                    categoryId: result["category_id"],
                                  );
                                });
                              }
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
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

                  // ------------------ إضافة عنصر ------------------
                  userRole == "الواهب"
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddItemsScreen(onTipAdded: loadData),
                                ),
                              );
                              loadData();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'ماذا تريد أن تعطي اليوم؟',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),

                  // ------------------ عرض العناصر ------------------
                  Expanded(
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _controller.filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              "لا يوجد عناصر",
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            itemCount: _controller.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _controller.filteredItems[index];
                              final images =
                                  (item['images'] as List?)?.cast<String>() ??
                                  [];
                              final time = formatTime(item['created_at'] ?? '');

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: UserItemsCard(
                                  itemId: item['id'],
                                  title: item['title'],
                                  description: item['description'],
                                  imageUrls: images,
                                  timeAgo: time,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
