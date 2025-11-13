import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/add_items_services/add_items_services.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/user_items_screen/floatingActionButton_add_items.dart';
import 'package:giver_receiver/presentation/widgets/user_items_screen/user_items_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserItems extends StatefulWidget {
  const UserItems({super.key});

  @override
  State<UserItems> createState() => _UserItemsState();
}

class _UserItemsState extends State<UserItems> {
  final supabase = Supabase.instance.client;

  bool refreshTips = false;
  Future<void> _reloadTips() async {
    setState(() {
      refreshTips = !refreshTips; // فقط لتغيير القيمة وإعادة بناء Future
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingactionbuttonAddItems(
        onTipAdded: _reloadTips,
      ),

      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Items",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),

            child: Icon(
              Icons.description,
              color: AppColors().primaryColor,
              size: 32,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>?>(
          future: AddItemsServices().getItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "No tips available",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                final description = item['description'];
                final image = item['image'];
                final time = formatTime(item['created_at']);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserItemsCard(
                    content: description,
                    imageUrl: image,
                    timeAgo: time,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
