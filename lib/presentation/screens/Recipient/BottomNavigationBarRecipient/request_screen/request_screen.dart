import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Recipient/request_screen_services.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  final RequestServices _req = RequestServices();
  List<Map<String, dynamic>> myRequests = [];
  List<Map<String, dynamic>> filteredRequests = [];

  bool isLoading = true;
  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    myRequests = await _req.getMyRequests();
    filteredRequests = List.from(myRequests);
    setState(() => isLoading = false);
  }

  void filterRequests() {
    if (selectedStatus == "All") {
      filteredRequests = List.from(myRequests);
    } else {
      filteredRequests = myRequests.where((req) {
        return req["status"] == selectedStatus;
      }).toList();
    }
    setState(() {}); // ← لتحديث واجهة المستخدم
  }

  Future<void> deleteRequestById(String id) async {
    final result = await RequestServices().deleteRequest(id);

    if (result) {
      myRequests.removeWhere((req) => req["id"] == id);
      filteredRequests.removeWhere((req) => req["id"] == id);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Request deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to delete request")));
    }
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------- Icon ----------------
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_forever, color: Colors.red, size: 48),
              ),

              SizedBox(height: 18),

              // ---------------- Title ----------------
              Text(
                "Delete Item",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              // ---------------- Content ----------------
              Text(
                "Are you sure you want to delete this item? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              SizedBox(height: 25),

              // ---------------- Buttons ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        deleteRequestById(id);
                      },

                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors().primaryColor;

    return Scaffold(
      body: Column(
        children: [
          const CustomHeader(
            icon: Icons.volunteer_activism_outlined,
            title: "Requests",
          ),
          const SizedBox(height: 15),

          // ------------------ البحث + الفلترة ------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                // البحث
                Expanded(
                  flex: 9,
                  child: TextFormField(
                    controller: requestScreenSearch,
                    cursorColor: primary,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search for Request',
                      prefixIcon: Icon(Icons.search, color: primary),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (value) {
                      final search = value.toLowerCase();
                      filteredRequests = myRequests.where((req) {
                        final reason = req["reason"].toString().toLowerCase();
                        return reason.contains(search);
                      }).toList();
                      setState(() {});
                    },
                  ),
                ),

                const SizedBox(width: 10),

                // الفلترة بالStatus
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        icon: Icon(Icons.filter_list, color: primary),
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All")),
                          DropdownMenuItem(
                            value: "pending",
                            child: Text("pending"),
                          ),
                          DropdownMenuItem(
                            value: "approve",
                            child: Text("Approved"),
                          ),
                          DropdownMenuItem(
                            value: "reject",
                            child: Text("Rejected"),
                          ),
                        ],
                        onChanged: (value) {
                          selectedStatus = value!;
                          filterRequests(); // ← تحديث القائمة حسب الحالة
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ------------------ قائمة الطلبات ------------------
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredRequests.isEmpty
                ? const Center(
                    child: Text(
                      "No requests found",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final req = filteredRequests[index];

                      final imageUrl = req["attachment_url"];
                      final reason = req["reason"];
                      final timeAgo = formatTime(req["created_at"]);
                      final status = req["status"] ?? "pending";

                      Color statusColor = status == "approve"
                          ? Colors.green
                          : status == "reject"
                          ? Colors.red
                          : status == "delivered"
                          ? Colors.blue
                          : Colors.orange;

                      return Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ----------------- الوقت + الحالة -----------------
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
                                    border: Border.all(
                                      color: statusColor,
                                      width: 1.2,
                                    ),
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
                                    vertical: 6,
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

                            // ----------------- السبب -----------------
                            Text(
                              reason,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // ----------------- الصورة مع طبقة تعتيم + زر حذف -----------------
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  // الصورة
                                  imageUrl != null
                                      ? Image.network(
                                          imageUrl,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          height: 200,
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),

                                  // طبقة التعتيم
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.black.withOpacity(0.35),
                                  ),

                                  // زر الحذف
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        confirmDelete(req["id"]);
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            243,
                                            227,
                                            227,
                                          ),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                              255,
                                              185,
                                              17,
                                              5,
                                            ),
                                            width: 1.7,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),
                          ],
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
