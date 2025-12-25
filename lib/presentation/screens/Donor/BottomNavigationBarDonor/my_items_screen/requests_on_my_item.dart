import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/requests_on_my_item_services.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';

class RequestsOnMyItem extends StatelessWidget {
  final String itemId;

  const RequestsOnMyItem({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(
            icon: Icons.volunteer_activism_outlined,
            title: 'Requests on My Item',
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: RequestsOnMyItemServices().getRequestsForItem(itemId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final requests = snapshot.data!;
              if (requests.isEmpty) {
                return const Center(child: Text("لا يوجد طلبات"));
              }

              return Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Color(0xFF17A589)],
                      stops: [0.0, 0.7, 1.5],
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final req = requests[index];

                      final requester = req['requester'];
                      final requesterName = requester?['full_name'] ?? 'مستخدم';
                      final requesterImage = requester?['image'];
                      final status = req['status'];
                      final reason = req['reason'];
                      final imageUrl = req['attachment_url'];
                      final timeAgo = formatTime(req['created_at']);

                      Color statusColor = status == "approve"
                          ? Colors.green
                          : status == "reject"
                          ? Colors.red
                          : status == "delivered"
                          ? Colors.blue
                          : Colors.orange;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // -------- الحالة + الوقت --------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors().primaryColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    timeAgo,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            // -------- اسم الموهوب --------
                            Text(
                              requesterName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            // -------- السبب --------
                            Text(reason, style: const TextStyle(fontSize: 15)),

                            const SizedBox(height: 12),

                            // -------- الصورة --------
                            if (imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
