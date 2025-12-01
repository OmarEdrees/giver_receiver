// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:giver_receiver/logic/services/add_items_services/add_items_services.dart';
// // import 'package:giver_receiver/logic/services/variables_app.dart';
// // import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';

// // class AddItemsScreen extends StatefulWidget {
// //   final VoidCallback onTipAdded;
// //   const AddItemsScreen({super.key, required this.onTipAdded});

// //   @override
// //   State<AddItemsScreen> createState() => _AddItemsScreenState();
// // }

// // class _AddItemsScreenState extends State<AddItemsScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   File? _selectedImage;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Container(
// //           child: Form(
// //             key: _formKey,
// //             child: SingleChildScrollView(
// //               padding: const EdgeInsets.all(15),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   GestureDetector(
// //                     onTap: () async {
// //                       final pickedFile = await ImagePicker().pickImage(
// //                         source: ImageSource.gallery,
// //                       );

// //                       if (pickedFile != null) {
// //                         setState(() {
// //                           _selectedImage = File(pickedFile.path);
// //                         });
// //                       }
// //                     },
// //                     child: Container(
// //                       width: double.infinity,
// //                       height: 200,
// //                       decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(15),
// //                         color: Colors.grey[350],
// //                         image: _selectedImage != null
// //                             ? DecorationImage(
// //                                 image: FileImage(_selectedImage!),
// //                                 fit: BoxFit.cover,
// //                               )
// //                             : null,
// //                       ),
// //                       child: _selectedImage == null
// //                           ? Icon(
// //                               Icons.camera_alt,
// //                               size: 40,
// //                               color: Colors.grey[700],
// //                             )
// //                           : null,
// //                     ),
// //                   ),
// //                   SizedBox(height: 15),
// //                   Text(
// //                     "Choose a picture",
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //                   ),
// //                   SizedBox(height: 15),
// //                   CustomTextFormField(
// //                     maxLines: 10,
// //                     focusNode: addItemsFocus,
// //                     validator: validated,
// //                     controller: addItems,
// //                     hintText: 'Items Content',
// //                     icon: Icons.lightbulb,
// //                   ),
// //                   SizedBox(height: 18),
// //                   GestureDetector(
// //                     onTap: () async {
// //                       if (!_formKey.currentState!.validate()) return;

// //                       final userId =
// //                           Supabase.instance.client.auth.currentUser?.id;
// //                       if (userId == null) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(content: Text("User not logged in")),
// //                         );
// //                         return;
// //                       }

// //                       showDialog(
// //                         barrierDismissible: false,
// //                         context: context,
// //                         builder: (_) =>
// //                             const Center(child: CircularProgressIndicator()),
// //                       );

// //                       // Pass the selected File directly to insertTip; insertTip will handle uploading.
// //                       final success = await AddItemsServices().insertItems(
// //                         userId: userId,
// //                         name: 'Unknown',
// //                         description: addItems.text.trim(),
// //                         status: 'status',
// //                         imageFile: _selectedImage,
// //                       );

// //                       Navigator.pop(context, true); // Close Loading Dialog

// //                       if (success == true) {
// //                         Navigator.pop(
// //                           context,
// //                           true,
// //                         ); // ✅ Return true to refresh page
// //                         addItems.clear();
// //                         _selectedImage = null;
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(content: Text("Tip added successfully ✅")),
// //                         );
// //                         widget.onTipAdded();
// //                       }
// //                     },
// //                     child: Container(
// //                       width: double.infinity,
// //                       height: 50,
// //                       decoration: BoxDecoration(
// //                         color: Color(0xFFFF7F3E),
// //                         borderRadius: BorderRadius.circular(25),
// //                       ),
// //                       child: Center(
// //                         child: Text(
// //                           'Add',
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:giver_receiver/logic/services/add_items_services/add_items_services.dart';
// import 'package:giver_receiver/logic/services/colors_app.dart';
// import 'package:giver_receiver/logic/services/variables_app.dart';
// import 'package:giver_receiver/presentation/screens/CustomHeader/custom_header.dart';
// import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// const List<String> itemConditions = [
//   "جديد تمامًا",
//   "شبه جديد",
//   "مستخدم - ممتاز",
//   "مستخدم - جيد",
//   "مستخدم - مقبول",
//   "مستخدم بكثرة",
//   "يحتاج إلى صيانة",
// ];

// class AddItemsScreen extends StatefulWidget {
//   final VoidCallback onTipAdded;
//   const AddItemsScreen({super.key, required this.onTipAdded});

//   @override
//   State<AddItemsScreen> createState() => _AddItemsScreenState();
// }

// class _AddItemsScreenState extends State<AddItemsScreen> {
//   final _formKey = GlobalKey<FormState>();

//   int currentPage = 0;
//   List<File> _selectedImages = [];
//   String? selectedCategoryName;
//   String? selectedCategoryId;
//   String? selectedCondition;
//   bool isAvailable = true;

//   List<Map<String, dynamic>> categories = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }

//   Future<void> fetchCategories() async {
//     final response = await Supabase.instance.client.from('categories').select();
//     setState(() {
//       categories = List<Map<String, dynamic>>.from(response);
//     });
//   }

//   // ---------------------- CUSTOM DROPDOWN UI ----------------------
//   Widget customDropdown({
//     required String? value,
//     required String hint,
//     required List<String> items,
//     required Function(String?) onChanged,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.grey.shade400, width: 1.2),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           icon: const Icon(Icons.arrow_drop_down, size: 28),
//           hint: Text(
//             hint,
//             style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
//           ),
//           isExpanded: true,
//           items: items
//               .map(
//                 (item) => DropdownMenuItem(
//                   value: item,
//                   child: Text(item, style: const TextStyle(fontSize: 16)),
//                 ),
//               )
//               .toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );
//   }
//   // ---------------------------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader(icon: Icons.add, title: 'Add New Item'),

//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(15),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // -------------------- IMAGE PICKER --------------------
//                     GestureDetector(
//                       onTap: () async {
//                         final pickedFiles = await ImagePicker()
//                             .pickMultiImage();

//                         if (pickedFiles.isNotEmpty) {
//                           setState(() {
//                             _selectedImages = pickedFiles
//                                 .map((e) => File(e.path))
//                                 .toList();
//                           });
//                         }
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.grey[300],
//                         ),
//                         child: _selectedImages.isEmpty
//                             ? Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.camera_alt,
//                                     size: 40,
//                                     color: Colors.grey[700],
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text("Picke Image"),
//                                 ],
//                               )
//                             : Stack(
//                                 alignment: Alignment.bottomCenter,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(15),
//                                     child: _selectedImages.length == 1
//                                         ? Image.file(
//                                             _selectedImages.first,
//                                             width: double.infinity,
//                                             height: double.infinity,
//                                             fit: BoxFit.cover,
//                                           )
//                                         : PageView.builder(
//                                             controller: pageControllerImages,
//                                             itemCount: _selectedImages.length,
//                                             onPageChanged: (index) {
//                                               setState(() {
//                                                 currentPage = index;
//                                               });
//                                             },
//                                             itemBuilder: (context, index) {
//                                               return Image.file(
//                                                 _selectedImages[index],
//                                                 width: double.infinity,
//                                                 height: double.infinity,
//                                                 fit: BoxFit.cover,
//                                               );
//                                             },
//                                           ),
//                                   ),

//                                   /// DOT INDICATOR
//                                   if (_selectedImages.length > 1)
//                                     Positioned(
//                                       bottom: 10,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: List.generate(
//                                           _selectedImages.length,
//                                           (index) => AnimatedContainer(
//                                             duration: Duration(
//                                               milliseconds: 300,
//                                             ),
//                                             margin: EdgeInsets.symmetric(
//                                               horizontal: 4,
//                                             ),
//                                             width: currentPage == index
//                                                 ? 12
//                                                 : 7,
//                                             height: 7,
//                                             decoration: BoxDecoration(
//                                               color: currentPage == index
//                                                   ? Colors.white
//                                                   : Colors.white54,
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 10),
//                     const Text(
//                       "Choose a picture",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // -------------------- TITLE --------------------
//                     CustomTextFormField(
//                       controller: addItemsTitle,
//                       hintText: "Title",
//                       icon: Icons.title,
//                       validator: validated,
//                       focusNode: addItemsTitleFocus,
//                     ),

//                     const SizedBox(height: 18),

//                     // -------------------- DESCRIPTION --------------------
//                     CustomTextFormField(
//                       maxLines: 5,
//                       controller: addItemsDescription,
//                       hintText: 'Description',
//                       icon: Icons.description,
//                       validator: validated,
//                       focusNode: addItemsDescriptionFocus,
//                     ),

//                     const SizedBox(height: 18),

//                     // -------------------- QUANTITY --------------------
//                     CustomTextFormField(
//                       controller: addItemsQuantity,
//                       hintText: "Quantity",
//                       icon: Icons.numbers,
//                       keyboardType: TextInputType.number,
//                       validator: validated,
//                       focusNode: addItemsQuantityFocus,
//                     ),

//                     const SizedBox(height: 18),

//                     // -------------------- CATEGORY DROPDOWN --------------------
//                     customDropdown(
//                       value: selectedCategoryName,
//                       hint: "Select Category",
//                       items: categories
//                           .map((c) => c['name'] as String)
//                           .toList(),
//                       onChanged: (value) {
//                         final category = categories.firstWhere(
//                           (cat) => cat['name'] == value,
//                         );
//                         setState(() {
//                           selectedCategoryName = value;
//                           selectedCategoryId = category['id'];
//                         });
//                       },
//                     ),

//                     const SizedBox(height: 18),

//                     // -------------------- CONDITION DROPDOWN --------------------
//                     customDropdown(
//                       value: selectedCondition,
//                       hint: "Select Condition",
//                       items: itemConditions,
//                       onChanged: (value) {
//                         setState(() => selectedCondition = value);
//                       },
//                     ),

//                     const SizedBox(height: 18),

//                     // -------------------- AVAILABLE SWITCH --------------------
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Is it available?",
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Switch(
//                           value: isAvailable,
//                           activeColor: AppColors().primaryColor,
//                           onChanged: (v) => setState(() => isAvailable = v),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 25),

//                     // -------------------- SUBMIT BUTTON --------------------
//                     GestureDetector(
//                       onTap: () async {
//                         if (!_formKey.currentState!.validate()) return;

//                         if (selectedCategoryId == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Select category")),
//                           );
//                           return;
//                         }
//                         if (selectedCondition == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Select condition")),
//                           );
//                           return;
//                         }

//                         final userId =
//                             Supabase.instance.client.auth.currentUser?.id;

//                         showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (_) =>
//                               const Center(child: CircularProgressIndicator()),
//                         );

//                         final success = await AddItemsServices().insertItems(
//                           userId: userId!,
//                           title: addItemsTitle.text.trim(),
//                           description: addItemsDescription.text.trim(),
//                           quantity: int.parse(addItemsQuantity.text.trim()),
//                           categoryId: selectedCategoryId!,
//                           condition: selectedCondition!,
//                           isAvailable: isAvailable,
//                           imageFile: _selectedImages,
//                         );

//                         Navigator.pop(context);

//                         if (success) {
//                           Navigator.pop(context, true);
//                           widget.onTipAdded();
//                         }
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: AppColors().primaryColor,
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Add',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 25),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// add_items_screen.dart
// UI file only — logic moved to controller

import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Donor/my_items_services/add_items_services/add_items_services.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';

class AddItemsScreen extends StatefulWidget {
  final VoidCallback onTipAdded;
  const AddItemsScreen({super.key, required this.onTipAdded});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  late AddItemsController controller;

  @override
  void initState() {
    super.initState();
    controller = AddItemsController();
    controller.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomHeader(icon: Icons.add, title: 'Add New Item'),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: controller.formKey, // Use controller's formKey
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------- IMAGE PICKER --------------------
                    GestureDetector(
                      onTap: () async {
                        await controller.pickImages();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[300],
                        ),
                        child: controller.selectedImages.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text("Pick Image"),
                                ],
                              )
                            : controller.buildImagesPreview(),
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Text(
                      "Choose a picture",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // -------------------- TITLE --------------------
                    CustomTextFormField(
                      controller: addItemsTitle,
                      hintText: "Title",
                      icon: Icons.title,
                      validator: validated,
                      focusNode: addItemsTitleFocus,
                    ),

                    const SizedBox(height: 18),

                    // -------------------- DESCRIPTION --------------------
                    CustomTextFormField(
                      maxLines: 5,
                      controller: addItemsDescription,
                      hintText: 'Description',
                      icon: Icons.description,
                      validator: validated,
                      focusNode: addItemsDescriptionFocus,
                    ),

                    const SizedBox(height: 18),

                    // -------------------- QUANTITY --------------------
                    CustomTextFormField(
                      controller: addItemsQuantity,
                      hintText: "Quantity",
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      validator: validated,
                      focusNode: addItemsQuantityFocus,
                    ),

                    const SizedBox(height: 18),

                    // -------------------- CATEGORY --------------------
                    controller.customDropdown(
                      value: controller.selectedCategoryName,
                      hint: "Select Category",
                      items: controller.categories
                          .map((c) => c['name'] as String)
                          .toList(),
                      onChanged: (value) {
                        controller.selectCategory(value);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 18),

                    // -------------------- CONDITION --------------------
                    controller.customDropdown(
                      value: controller.selectedCondition,
                      hint: "Select Condition",
                      items: controller.itemConditions,
                      onChanged: (value) {
                        controller.selectCondition(value);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 18),

                    // -------------------- AVAILABLE SWITCH --------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Is it available?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Switch(
                          value: controller.isAvailable,
                          activeColor: AppColors().primaryColor,
                          onChanged: (v) {
                            controller.toggleAvailability(
                              v,
                            ); // يحدث القيمة داخل الـ controller
                            setState(() {}); // يحدث واجهة المستخدم
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // -------------------- SUBMIT --------------------
                    GestureDetector(
                      onTap: () async {
                        if (!controller.formKey.currentState!.validate())
                          return;

                        final success = await controller.submitItem(context);
                        if (success) {
                          controller.clearFields();
                          Navigator.pop(context, true);
                          widget.onTipAdded();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors().primaryColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Center(
                          child: Text(
                            'Add',
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
