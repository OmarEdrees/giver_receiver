import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Donor/GetCurrentUserData/get_current_user_data.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/my_items_servises/my_items_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/my_items_screen/edit_my_items_screen.dart';
import 'package:giver_receiver/presentation/widgets/my_items_screen/save_button_widget_my_items.dart';

class MyItemsCard extends StatefulWidget {
  final VoidCallback onRefresh;
  final String itemId;
  final String title;
  final String description;
  final List<String> images;
  final bool isAvailable;
  final String timeAgo;

  const MyItemsCard({
    super.key,
    required this.onRefresh,
    required this.itemId,
    required this.title,
    required this.description,
    required this.images,
    required this.isAvailable,
    required this.timeAgo,
  });

  @override
  State<MyItemsCard> createState() => _MyItemsCardState();
}

class _MyItemsCardState extends State<MyItemsCard> {
  int currentPage = 0;
  bool isDisEnable = true;

  @override
  void initState() {
    super.initState();
    pageControllerImagesMyItems = PageController();
    isDisEnable = widget.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------- الهيدر (اسم المستخدم + الوقت + الصورة) -------------------------
          FutureBuilder(
            future: CurrentUserData()
                .getCurrentUserData(), // استدعاء بيانات المستخدم
            builder: (context, snapshot) {
              return Container(
                height: 40,
                //padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.bottomCenter,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // ---------------------- العنوان ----------------------
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------------------- الوقت (trailing) ----------------------
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
                        widget.timeAgo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ------------------------- الوصف -------------------------
          Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),

          const SizedBox(height: 15),

          // ------------------------- صور المنتج (السلايدر) -------------------------
          if (widget.images.isNotEmpty)
            SizedBox(
              height: 220,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // ----------------- صور العنصر -----------------
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: PageView.builder(
                      controller: pageControllerImagesMyItems,
                      itemCount: widget.images.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.images[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  // ----------------- طبقة التعتيم السوداء -----------------
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(
                          0.35,
                        ), // ← التعتيم (غيّر النسبة)
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  // ----------------- رقم في الأعلى جهة اليسار -----------------
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        shape: BoxShape.circle,
                        color: AppColors().primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          '5', // ← حط الرقم اللي بدك ياه
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ----------------- المؤشر (dots) -----------------
                  if (widget.images.length > 1)
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage == index ? 12 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.grey),
            ),

          const SizedBox(height: 18),

          // ------------------------- الحالة -------------------------
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.isAvailable
                      ? Colors.green[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  widget.isAvailable ? "Available" : 'UnAvailable',
                  style: TextStyle(
                    color: widget.isAvailable ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    isDisEnable ? "Enable" : 'Disable',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  Switch(
                    value: isDisEnable,
                    activeColor: AppColors().primaryColor,
                    onChanged: (v) {
                      setState(() {
                        isDisEnable = v;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 18),

          // ------------------------- الأزرار السفلية -------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SaveButtonWidgetMyItems(
                  icon: Icons.edit,
                  title: 'Edit',
                  ontap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemsScreen(
                          itemId: widget.itemId,
                          onItemUpdated: () {},
                        ),
                      ),
                    );

                    if (result == true) {
                      widget.onRefresh();
                    }
                  },
                ),
              ),
              SizedBox(width: 10),

              Expanded(
                child: SaveButtonWidgetMyItems(
                  icon: Icons.delete,
                  title: 'Delete',
                  ontap: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
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
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                  size: 48,
                                ),
                              ),

                              SizedBox(height: 18),

                              // ---------------- Title ----------------
                              Text(
                                "Delete Item",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 10),

                              // ---------------- Content ----------------
                              Text(
                                "Are you sure you want to delete this item? This action cannot be undone.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),

                              SizedBox(height: 25),

                              // ---------------- Buttons ----------------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
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
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () =>
                                          Navigator.pop(context, true),
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

                    if (confirm != true) return;

                    final deleted = await MyItemsServices().deleteItem(
                      widget.itemId,
                    );

                    if (deleted) {
                      widget.onRefresh(); // تحديث القائمة
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Item deleted successfully")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error deleting item")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
