import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/Recipient/items_screen/order_button_bottom_sheet.dart';
import 'package:giver_receiver/presentation/widgets/Recipient/save_items_screen/SaveItemManager.dart';
import 'package:giver_receiver/presentation/widgets/items_screen/user_items_card/save_button_widget_items.dart';
import 'package:giver_receiver/presentation/widgets/my_items_screen/save_button_widget_my_items.dart';

class UserItemsCard extends StatefulWidget {
  // final String name;
  // final String specialty;
  final String itemId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String timeAgo;
  // final String avatarUrl;

  const UserItemsCard({
    super.key,
    // required this.name,
    // required this.specialty,
    required this.itemId,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.imageUrls,
    // required this.avatarUrl,
  });

  @override
  State<UserItemsCard> createState() => _UserItemsCardState();
}

class _UserItemsCardState extends State<UserItemsCard> {
  int currentPage = 0;
  bool isSaved = false;

  void loadSaveStatus() async {
    isSaved = await SaveItemManager.isItemSaved(widget.itemId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    pageControllerImagesItems = PageController();
    loadSaveStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Divider(color: Colors.grey[300], thickness: 1.5),
          // ),
          Container(
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
          ),

          /////////////////////////////////////////////////////////////
          Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          SizedBox(height: 10),
          /////////////////////////////////////////////////////////////
          if (widget.imageUrls.isNotEmpty)
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PageView.builder(
                      controller: pageControllerImages,
                      itemCount: widget.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.imageUrls[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  if (widget.imageUrls.length > 1)
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imageUrls.length,
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          // if (imageUrls.isNotEmpty)
          //   Stack(
          //     children: [
          //       Container(
          //         width: double.infinity,
          //         height: 200,
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(15),
          //           image: DecorationImage(
          //             image: NetworkImage(imageUrls.first), // أول صورة فقط
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //       // ⬅ إذا كان في أكثر من صورة — أظهر (+X)
          //       if (imageUrls.length > 1)
          //         Positioned(
          //           bottom: 10,
          //           right: 10,
          //           child: Container(
          //             padding: EdgeInsets.symmetric(
          //               horizontal: 10,
          //               vertical: 5,
          //             ),
          //             decoration: BoxDecoration(
          //               color: Colors.black.withOpacity(0.6),
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //             child: Text(
          //               "+${imageUrls.length}", // مثال: +3
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ),
          //         ),
          //     ],
          //   ),
          /////////////////////////////////////////////////////////////
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SaveButtonWidgetItems(
                  onTap: () {
                    print('likedddddddddddddddddddddd');
                  },
                  icon: Icons.thumb_up_outlined,
                  title: 'Like',
                  flipColorOnTap: true,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: SaveButtonWidgetItems(
                  onTap: () async {
                    await SaveItemManager.toggleSaveItem(widget.itemId);
                    loadSaveStatus(); // تحديث اللون فوراً
                    print("Item Saved Status Changed");
                  },
                  icon: Icons.save_outlined,
                  title: 'Save',
                  flipColorOnTap: false, // ← لا تغيّر اللون تلقائياً
                  isActive: isSaved, // ← اللون يأتي من حالة الحفظ
                ),
              ),
              userRole == 'Recipient' ? SizedBox(width: 15) : SizedBox.shrink(),
              userRole == 'Recipient'
                  ? Expanded(
                      child: SaveButtonWidgetMyItems(
                        ontap: () {
                          return showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            builder: (_) =>
                                OrderRequestBottomSheet(itemId: widget.itemId),
                          );
                        },
                        icon: Icons.volunteer_activism_outlined,
                        title: 'Order',
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }
}
