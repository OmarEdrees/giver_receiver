import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/my_items_servises/my_items_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/my_items_screen/requests_on_my_item.dart';
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

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(icon: Icons.description, title: 'عناصري'),

              const SizedBox(height: 15),

              // ----------------------- Search -----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: TextFormField(
                    controller: myItemScreenSearch,
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
                    onChanged: filterItems,
                  ),
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
                          "لا يوجد عناصر",
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

                          final List requests = item['requests'] ?? [];

                          // نجيب الطلب الموافق عليه (إن وجد)
                          final Map<String, dynamic>? approvedRequest = requests
                              .cast<Map<String, dynamic>>()
                              .firstWhere(
                                (r) => r['status'] == 'approve',
                                orElse: () => {},
                              );

                          final bool hasApproved = approvedRequest!.isNotEmpty;

                          // بيانات الموهوب (فقط إذا في approve)
                          final requester = hasApproved
                              ? approvedRequest['requester']
                              : null;
                          final requesterId = requester?['id'];
                          final requesterName = requester?['full_name'];
                          final requesterImage = requester?['image'];
                          final requestId = hasApproved
                              ? approvedRequest['id']
                              : null;

                          final status = requests.isNotEmpty
                              ? requests[0]['status']
                              : 'no_request';

                          Color statusColor = status == "approve"
                              ? Colors.green
                              : status == "reject"
                              ? Colors.red
                              : status == "delivered"
                              ? Colors.blue
                              : Colors.orange;
                          ////////////////////////////////////////////////////////////
                          final int requestsCount = requests.length;

                          final List<dynamic>? imageList = item['images'];
                          final List<String> imageUrls = imageList != null
                              ? imageList.map((img) => img.toString()).toList()
                              : [];

                          final time = formatTime(item['created_at']);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        RequestsOnMyItem(itemId: item['id']),
                                  ),
                                );
                              },
                              child: MyItemsCard(
                                requestsCount: requestsCount,
                                status: status,
                                statusColor: statusColor,
                                onRefresh: loadItems,
                                itemId: item['id'],
                                title: item['title'],
                                isAvailable: item['is_available'],
                                description: item['description'],
                                images: imageUrls,
                                timeAgo: time,
                                currentUserId: supabase.auth.currentUser!.id,

                                // 🔥 الشات فقط إذا approve
                                otherUserId: hasApproved ? requesterId : null,
                                otherName: hasApproved ? requesterName : null,
                                otherImage: hasApproved ? requesterImage : null,
                                requestId: requestId,
                              ),
                            ),
                          );
                        },
                      ),

                // ListView.builder(
                //     padding: const EdgeInsets.only(
                //       left: 15,
                //       right: 15,
                //       bottom: 15,
                //     ),
                //     itemCount: filteredItems.length,
                //     itemBuilder: (context, index) {
                //       final item = filteredItems[index];

                //       final status =
                //           item['requests'] != null &&
                //               item['requests'].isNotEmpty
                //           ? item['requests'][0]['status']
                //           : 'no_request';
                //       final itemId = item['id'];
                //       final title = item['title'];
                //       final isAvailable = item['is_available'];
                //       final description = item['description'];
                //       final createdAt = item['created_at'];
                //       Color statusColor = status == "approve"
                //           ? Colors.green
                //           : status == "reject"
                //           ? Colors.red
                //           : status == "delivered"
                //           ? Colors.blue
                //           : Colors.orange;
                //       ////////////////////////////////////
                //       // الطلبات
                //       final List requests = item['requests'] ?? [];
                //       // نجيب الطلب الموافق عليه
                //       final approvedRequest = requests.firstWhere(
                //         (r) => r['status'] == 'approve',
                //         orElse: () => null,
                //       );

                //       if (approvedRequest == null) {
                //         // ما في طلب موافق → لا تفتح شات
                //         return const SizedBox();
                //       }

                //       // بيانات الموهوب
                //       final requester = approvedRequest['requester'];
                //       final requesterId = requester['id'];
                //       final requesterName = requester['full_name'];
                //       final requesterImage = requester['image'];
                //       final request = item['requests'][0];
                //       final requestId = request['id'];
                //       print(
                //         '***********************************************************',
                //       );
                //       print(requesterId);
                //       print(supabase.auth.currentUser!.id);

                //       // ⬅ جلب الصور من Supabase
                //       final List<dynamic>? imageList = item['images'];
                //       final List<String> imageUrls = imageList != null
                //           ? imageList.map((img) => img.toString()).toList()
                //           : [];

                //       final time = formatTime(createdAt);

                //       return Padding(
                //         padding: const EdgeInsets.only(bottom: 12),
                //         child: MyItemsCard(
                //           status: status,
                //           statusColor: statusColor,
                //           onRefresh: loadItems,
                //           itemId: itemId,
                //           title: title,
                //           isAvailable: isAvailable,
                //           description: description,
                //           images: imageUrls,
                //           timeAgo: time,
                //           currentUserId: supabase.auth.currentUser!.id,
                //           otherImage: requesterImage,
                //           otherName: requesterName,
                //           otherUserId: requesterId,
                //           requestId: requestId,
                //         ),
                //       );
                //     },
                //   ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
