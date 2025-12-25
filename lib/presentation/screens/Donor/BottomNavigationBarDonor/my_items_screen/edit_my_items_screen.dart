import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/edit_items_services/edit_items_controller.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';

class EditItemsScreen extends StatefulWidget {
  final String itemId;
  final VoidCallback onItemUpdated;

  const EditItemsScreen({
    super.key,
    required this.itemId,
    required this.onItemUpdated,
  });

  @override
  State<EditItemsScreen> createState() => _EditItemsScreenState();
}

class _EditItemsScreenState extends State<EditItemsScreen> {
  late EditItemsController controller;

  @override
  void initState() {
    super.initState();
    controller = EditItemsController();

    controller.fetchCategories().then((_) {
      controller.loadItem(widget.itemId);
    });

    controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(icon: Icons.edit, title: 'Edit Item'),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- IMAGES ----------------
                    GestureDetector(
                      onTap: () async {
                        await controller.pickImages();

                        // عند اختيار صور جديدة نحذف القديمة
                        if (controller.newImages.isNotEmpty) {
                          controller.oldImages.clear();
                        }

                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                        ),
                        child: controller.newImages.isNotEmpty
                            // ------------------- صور جديدة -------------------
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: PageView.builder(
                                      controller:
                                          controller.pageControllerImages,
                                      itemCount: controller.newImages.length,
                                      onPageChanged: (i) {
                                        setState(
                                          () => controller.currentPage = i,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return Image.file(
                                          controller.newImages[index],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),

                                  if (controller.newImages.length > 1)
                                    Positioned(
                                      bottom: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          controller.newImages.length,
                                          (index) => AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            width:
                                                controller.currentPage == index
                                                ? 12
                                                : 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color:
                                                  controller.currentPage ==
                                                      index
                                                  ? Colors.white
                                                  : Colors.white54,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            // ------------------- صور قديمة -------------------
                            : controller.oldImages.isNotEmpty
                            ? Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: PageView.builder(
                                      controller:
                                          controller.pageControllerImages,
                                      itemCount: controller.oldImages.length,
                                      onPageChanged: (i) {
                                        setState(
                                          () => controller.currentPage = i,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return Image.network(
                                          controller.oldImages[index],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),

                                  if (controller.oldImages.length > 1)
                                    Positioned(
                                      bottom: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          controller.oldImages.length,
                                          (index) => AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            width:
                                                controller.currentPage == index
                                                ? 12
                                                : 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              color:
                                                  controller.currentPage ==
                                                      index
                                                  ? Colors.white
                                                  : Colors.white54,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            // ------------------- لا يوجد صور -------------------
                            : const Center(
                                child: Text(
                                  "No Images",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormField(
                      controller: addItemsTitle,
                      hintText: "Title",
                      icon: Icons.title,
                      validator: validated,
                      focusNode: addItemsTitleFocus,
                    ),

                    const SizedBox(height: 18),

                    CustomTextFormField(
                      controller: addItemsDescription,
                      hintText: "Description",
                      validator: validated,
                      maxLines: 5,
                      icon: Icons.description,
                      focusNode: addItemsDescriptionFocus,
                    ),

                    const SizedBox(height: 18),

                    CustomTextFormField(
                      controller: addItemsQuantity,
                      hintText: "Quantity",
                      keyboardType: TextInputType.number,
                      validator: validated,
                      icon: Icons.numbers,
                      focusNode: addItemsQuantityFocus,
                    ),

                    const SizedBox(height: 18),

                    controller.customDropdown(
                      value: controller.selectedCategoryName,
                      hint: "Select Category",
                      items: controller.categories
                          .map((c) => c["name"] as String)
                          .toList(),
                      onChanged: (value) {
                        controller.selectCategory(value);
                      },
                    ),

                    const SizedBox(height: 18),

                    controller.customDropdown(
                      value: controller.selectedCondition,
                      hint: "Select Condition",
                      items: controller.itemConditions,
                      onChanged: controller.selectCondition,
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Is Available?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Switch(
                          value: controller.isAvailable,
                          activeColor: AppColors().primaryColor,
                          onChanged: controller.toggleAvailability,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    GestureDetector(
                      onTap: () async {
                        final ok = await controller.updateItem(context);
                        if (ok) {
                          Navigator.pop(
                            context,
                            true,
                          ); // ← إرسال true للشاشة الأم
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors().primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
