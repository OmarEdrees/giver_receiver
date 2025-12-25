// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:giver_receiver/logic/services/add_items_services/add_items_services.dart';
// import 'package:giver_receiver/logic/services/variables_app.dart';
// import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class FloatingactionbuttonAddItems extends StatefulWidget {
//   final VoidCallback onTipAdded;
//   const FloatingactionbuttonAddItems({super.key, required this.onTipAdded});

//   @override
//   State<FloatingactionbuttonAddItems> createState() =>
//       _FloatingactionbuttonAddItemsState();
// }

// class _FloatingactionbuttonAddItemsState
//     extends State<FloatingactionbuttonAddItems> {
//   final _formKey = GlobalKey<FormState>();
//   File? _selectedImage;

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (context) => Dialog(
//             insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),

//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         final pickedFile = await ImagePicker().pickImage(
//                           source: ImageSource.gallery,
//                         );

//                         if (pickedFile != null) {
//                           setState(() {
//                             _selectedImage = File(pickedFile.path);
//                           });
//                         }
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 200,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.grey[350],
//                           image: _selectedImage != null
//                               ? DecorationImage(
//                                   image: FileImage(_selectedImage!),
//                                   fit: BoxFit.cover,
//                                 )
//                               : null,
//                         ),
//                         child: _selectedImage == null
//                             ? Icon(
//                                 Icons.camera_alt,
//                                 size: 40,
//                                 color: Colors.grey[700],
//                               )
//                             : null,
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Text(
//                       "Choose a picture",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     CustomTextFormField(
//                       maxLines: 10,
//                       focusNode: addItemsTitleFocus,
//                       validator: validated,
//                       controller: addItemsTitle,
//                       hintText: 'Items Content',
//                       icon: Icons.lightbulb,
//                     ),
//                     SizedBox(height: 18),
//                     GestureDetector(
//                       onTap: () async {
//                         if (!_formKey.currentState!.validate()) return;

//                         final userId =
//                             Supabase.instance.client.auth.currentUser?.id;
//                         if (userId == null) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("User not logged in")),
//                           );
//                           return;
//                         }

//                         showDialog(
//                           barrierDismissible: false,
//                           context: context,
//                           builder: (_) =>
//                               const Center(child: CircularProgressIndicator()),
//                         );

//                         // Pass the selected File directly to insertTip; insertTip will handle uploading.
//                         final success = await AddItemsServices().insertItems(
//                           userId: userId,
//                           name: 'Unknown',
//                           description: addItemsTitle.text.trim(),
//                           status: 'status',
//                           imageFile: _selectedImage,
//                         );
//                         print("successmmmmmmmmmmmmmmmmmmmmmmmmmmmm: $success");

//                         Navigator.pop(context, true); // Close Loading Dialog

//                         if (success == true) {
//                           Navigator.pop(
//                             context,
//                             true,
//                           ); // ✅ Return true to refresh page
//                           addItemsTitle.clear();
//                           _selectedImage = null;
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("Tip added successfully ✅")),
//                           );
//                           widget.onTipAdded();
//                         }
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         height: 50,
//                         decoration: BoxDecoration(
//                           color: Color(0xFFFF7F3E),
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         child: Center(
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
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ).then((value) {
//           if (value == true) {
//             // ✅ Refresh TipsScreen after adding
//             (context as Element).markNeedsBuild();
//           }
//         });
//       },
//       backgroundColor: const Color(0xFFFF7F3E),
//       shape: const CircleBorder(),
//       child: const Icon(Icons.add, color: Colors.white),
//     );
//   }
// }
