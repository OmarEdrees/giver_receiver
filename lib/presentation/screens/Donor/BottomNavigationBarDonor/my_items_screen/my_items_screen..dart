import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/my_items_servises/my_items_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:giver_receiver/presentation/widgets/my_items_screen/my_items_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key});

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    setState(() => isLoading = true);

    final items = await MyItemsServices().getMyItems();

    setState(() {
      allItems = items ?? [];
      filteredItems = allItems;
      isLoading = false;
    });
  }

  void filterItems(String query) {
    final search = query.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredItems = allItems;
      } else {
        filteredItems = allItems.where((item) {
          final title = item['title'].toString().toLowerCase();
          final desc = item['description'].toString().toLowerCase();
          return title.contains(search) || desc.contains(search);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Color(0xFF17A589)],
            stops: [0.0, 0.7, 1.5],
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(icon: Icons.description, title: 'My Items'),

            const SizedBox(height: 15),

            // ----------------------- Search -----------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: myItemScreenSearch,
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
                onChanged: filterItems,
              ),
            ),

            const SizedBox(height: 15),

            // ----------------------- Items List -----------------------
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No items found",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        bottom: 15,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        final itemId = item['id'];
                        final title = item['title'];
                        final isAvailable = item['is_available'];
                        final description = item['description'];
                        final createdAt = item['created_at'];

                        // ⬅ جلب الصور من Supabase
                        final List<dynamic>? imageList = item['images'];
                        final List<String> imageUrls = imageList != null
                            ? imageList.map((img) => img.toString()).toList()
                            : [];

                        final time = formatTime(createdAt);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MyItemsCard(
                            onRefresh: loadItems,
                            itemId: itemId,
                            title: title,
                            isAvailable: isAvailable,
                            description: description,
                            images: imageUrls,
                            timeAgo: time,
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
