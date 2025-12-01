import 'dart:io';
import 'package:giver_receiver/logic/services/Donor/my_items_services/my_items_servises/my_items_services.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemsController with ChangeNotifier {
  // --------------------------------------------------------
  // قائمة بحالات العناصر (الجديد – المستخدم…)
  // تستخدم داخل DropDown
  // --------------------------------------------------------
  List<String> itemConditions = [
    "جديد تمامًا",
    "شبه جديد",
    "مستخدم - ممتاز",
    "مستخدم - جيد",
    "مستخدم - مقبول",
    "مستخدم بكثرة",
    "يحتاج إلى صيانة",
  ];

  // --------------------------------------------------------
  // مفتاح الـ Form لإجراء عملية التحقق validate
  // --------------------------------------------------------
  final formKey = GlobalKey<FormState>();

  // --------------------------------------------------------
  // دالة يتم تمريرها من الواجهة لتحديث الشاشة عند تمرير الصور
  // --------------------------------------------------------
  Function()? onUpdate;

  // --------------------------------------------------------
  // قائمة الصور اللي اختارها المستخدم
  // --------------------------------------------------------
  List<File> selectedImages = [];

  // --------------------------------------------------------
  // رقم الصفحة عند عرض الصور على شكل Slider
  // --------------------------------------------------------
  int currentPage = 0;

  // --------------------------------------------------------
  // متحكم لتمرير الصور في PageView
  // --------------------------------------------------------
  final pageControllerImages = PageController();

  // -------------------   CATEGORY --------------------------
  String? selectedCategoryName; // اسم التصنيف المختار
  String? selectedCategoryId; // ID التصنيف من قاعدة البيانات

  // ------------------- CONDITION ----------------------------
  String? selectedCondition; // حالة العنصر

  // ------------------ AVAILABILITY --------------------------
  bool isAvailable = true;

  // --------------------------------------------------------
  // قائمة التصنيفات القادمة من Supabase
  // --------------------------------------------------------
  List<Map<String, dynamic>> categories = [];

  // --------------------------------------------------------
  // CONSTRUCTOR — يتم استدعاؤه عند إنشاء الكنترولر
  // يقوم بجلب التصنيفات من قاعدة البيانات
  // --------------------------------------------------------
  AddItemsController() {
    fetchCategories();
  }

  // --------------------------------------------------------
  // دالة مسح الحقول بعد الإضافة بنجاح
  // --------------------------------------------------------
  void clearFields() {
    // مسح الحقول النصية
    addItemsTitle.clear();
    addItemsDescription.clear();
    addItemsQuantity.clear();

    // مسح الصور
    selectedImages.clear();
    currentPage = 0;
    if (selectedImages.length > 1) {
      pageControllerImages.jumpToPage(0);
    }

    // مسح التصنيف والحالة
    selectedCategoryName = null;
    selectedCategoryId = null;
    selectedCondition = null;

    // إعادة التوفر لقيمة true
    isAvailable = true;

    notifyListeners();
  }

  // --------------------------------------------------------
  // دالة جلب التصنيفات من Supabase
  // --------------------------------------------------------
  Future<void> fetchCategories() async {
    final response = await Supabase.instance.client.from('categories').select();
    categories = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  // --------------------------------------------------------
  // دالة اختيار عدة صور من الاستوديو
  // --------------------------------------------------------
  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      notifyListeners();
    }
  }

  // --------------------------------------------------------
  // دالة اختيار التصنيف
  // --------------------------------------------------------
  void selectCategory(String? value) {
    final category = categories.firstWhere((cat) => cat['name'] == value);
    selectedCategoryName = value;
    selectedCategoryId = category['id'];
    notifyListeners();
  }

  // --------------------------------------------------------
  // دالة اختيار حالة العنصر (مثل جديد – مستخدم)
  // --------------------------------------------------------
  void selectCondition(String? value) {
    selectedCondition = value;
    notifyListeners();
  }

  // --------------------------------------------------------
  // تبديل حالة توفر العنصر: متاح / غير متاح
  // --------------------------------------------------------
  void toggleAvailability(bool value) {
    isAvailable = value;
    notifyListeners();
  }

  // --------------------------------------------------------
  // واجهة مخصصة لإنشاء Dropdown بشكل موحد
  // --------------------------------------------------------
  Widget customDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, size: 28),
          hint: Text(
            hint,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          isExpanded: true,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 16)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --------------------------------------------------------
  // واجهة عرض معاينة الصور بعد اختيارها
  // --------------------------------------------------------
  Widget buildImagesPreview() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: selectedImages.length == 1
              // صورة واحدة فقط
              ? Image.file(
                  selectedImages.first,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              // عدة صور → عرضها داخل PageView
              : PageView.builder(
                  controller: pageControllerImages,
                  itemCount: selectedImages.length,
                  onPageChanged: (index) {
                    currentPage = index;
                    onUpdate?.call(); // تحديث الواجهة
                  },
                  itemBuilder: (context, index) {
                    return Image.file(
                      selectedImages[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  // دالة إرسال العنصر إلى قاعدة البيانات
  // تضم التحقق من المدخلات
  // --------------------------------------------------------
  Future<bool> submitItem(BuildContext context) async {
    // فشل التحقق من الـ form
    if (!formKey.currentState!.validate()) return false;

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Select category")));
      return false;
    }

    if (selectedCondition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Select condition")));
      return false;
    }

    // الحصول على user ID من Supabase
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return false;

    // إرسال البيانات للخدمة الخاصة بعملية الإدخال
    final success = await MyItemsServices().insertItems(
      userId: userId,
      title: addItemsTitle.text.trim(),
      description: addItemsDescription.text.trim(),
      quantity: int.parse(addItemsQuantity.text.trim()),
      categoryId: selectedCategoryId!,
      condition: selectedCondition!,
      isAvailable: isAvailable,
      imageFile: selectedImages,
    );

    return success;
  }
}

// import 'dart:io';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class AddItemsServices {
//   final supabase = Supabase.instance.client;
//   final bucket = "add_items_images";

//   // ------------------------ رفع صورة ------------------------
//   Future<String?> uploadImage({
//     required File file,
//     required String userId,
//   }) async {
//     final fileName =
//         'add_items_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

//     await supabase.storage.from(bucket).upload(fileName, file);
//     return supabase.storage.from(bucket).getPublicUrl(fileName);
//   }

//   // ------------------------ إضافة عنصر ------------------------
//   Future<bool> insertItems({
//     required String userId,
//     required String title,
//     required String description,
//     required int quantity,
//     required String categoryId,
//     required String condition,
//     required List<File> images,
//     required bool isAvailable,
//   }) async {
//     try {
//       final user = supabase.auth.currentUser;
//       if (user == null) return false;

//       // رفع الصور → Array
//       List<String> imagesList = [];
//       for (final file in images) {
//         final uploadedUrl = await uploadImage(file: file, userId: user.id);
//         if (uploadedUrl != null) imagesList.add(uploadedUrl);
//       }

//       await supabase.from("user_items").insert({
//         "user_id": userId,
//         "title": title,
//         "description": description,
//         "quantity": quantity,
//         "category_id": categoryId,
//         "condition": condition,
//         "images": imagesList,
//         "is_available": isAvailable,
//         "created_at": DateTime.now().toUtc().toIso8601String(),
//         "updated_at": DateTime.now().toUtc().toIso8601String(),
//       });

//       return true;
//     } catch (e) {
//       print("Insert Items Error: $e");
//       return false;
//     }
//   }

//   // ------------------------ جلب العناصر ------------------------
//   Future<List<Map<String, dynamic>>> getItems() async {
//     try {
//       final response = await supabase
//           .from('user_items')
//           .select()
//           .order('created_at', ascending: false);

//       return List<Map<String, dynamic>>.from(response);
//     } catch (e) {
//       print('Get Items Error: $e');
//       return [];
//     }
//   }

//   // ------------------------ تحديث عنصر ------------------------
//   Future<bool> updateItem({
//     required String itemId,
//     String? title,
//     String? description,
//     int? quantity,
//     String? condition,
//     bool? isAvailable,
//     List<File>? newImages,
//   }) async {
//     try {
//       Map<String, dynamic> updateData = {
//         "updated_at": DateTime.now().toUtc().toIso8601String(),
//       };

//       if (title != null) updateData["title"] = title;
//       if (description != null) updateData["description"] = description;
//       if (quantity != null) updateData["quantity"] = quantity;
//       if (condition != null) updateData["condition"] = condition;
//       if (isAvailable != null) updateData["is_available"] = isAvailable;

//       // رفع صور جديدة إذا موجود
//       if (newImages != null && newImages.isNotEmpty) {
//         final user = supabase.auth.currentUser!;
//         List<String> uploaded = [];

//         for (final img in newImages) {
//           final url = await uploadImage(file: img, userId: user.id);
//           if (url != null) uploaded.add(url);
//         }

//         updateData["images"] = uploaded;
//       }

//       await supabase.from("user_items").update(updateData).eq("id", itemId);

//       return true;
//     } catch (e) {
//       print("Update Item Error: $e");
//       return false;
//     }
//   }

//   // ------------------------ حذف عنصر ------------------------
//   Future<bool> deleteItem(String itemId) async {
//     try {
//       await supabase.from("user_items").delete().eq("id", itemId);
//       return true;
//     } catch (e) {
//       print("Delete Item Error: $e");
//       return false;
//     }
//   }

//   // ------------------------ تحديث توفر العنصر ------------------------
//   Future<bool> toggleAvailability({
//     required String itemId,
//     required bool isAvailable,
//   }) async {
//     try {
//       await supabase
//           .from("user_items")
//           .update({
//             "is_available": isAvailable,
//             "updated_at": DateTime.now().toUtc().toIso8601String(),
//           })
//           .eq("id", itemId);

//       return true;
//     } catch (e) {
//       print("Toggle Status Error: $e");
//       return false;
//     }
//   }
// }
