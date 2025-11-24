import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/my_items_services/my_items_servises/my_items_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';

class EditItemsController with ChangeNotifier {
  final supabase = Supabase.instance.client;

  // ----------------------------
  //   بيانات العنصر الحالية
  // ----------------------------
  String itemId = "";
  String? selectedCategoryId;
  String? selectedCategoryName;
  String? selectedCondition;
  bool isAvailable = true;
  List<String> oldImages = []; // صور قديمة من Supabase
  List<File> newImages = []; // صور جديدة يرفعها المستخدم
  List<Map<String, dynamic>> categories = [];
  // --------------------------------------------------------
  // دالة يتم تمريرها من الواجهة لتحديث الشاشة عند تمرير الصور
  // --------------------------------------------------------
  Function()? onUpdate;

  // --------------------------------------------------------
  // قائمة الصور اللي اختارها المستخدم
  // --------------------------------------------------------
  List<File> selectedImages = [];

  // ----------------------------
  //  PageView للصور
  // ----------------------------
  int currentPage = 0;
  final pageControllerImages = PageController();

  final formKey = GlobalKey<FormState>();

  // ----------------------------
  //   شروط الحالة
  // ----------------------------
  List<String> itemConditions = [
    "جديد تمامًا",
    "شبه جديد",
    "مستخدم - ممتاز",
    "مستخدم - جيد",
    "مستخدم - مقبول",
    "مستخدم بكثرة",
    "يحتاج إلى صيانة",
  ];

  // ----------------------------
  // تحميل الفئات
  // ----------------------------
  Future<void> fetchCategories() async {
    final response = await supabase.from('categories').select();
    categories = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  // -----------------------------------
  //  جلب بيانات العنصر المطلوب تعديله
  // -----------------------------------
  Future<void> loadItem(String id) async {
    itemId = id;

    final data = await supabase
        .from("user_items")
        .select()
        .eq("id", id)
        .maybeSingle();

    if (data == null) return;

    // تعبئة الحقول
    addItemsTitle.text = data['title'];
    addItemsDescription.text = data['description'];
    addItemsQuantity.text = data['quantity'].toString();

    selectedCategoryId = data['category_id'];
    selectedCondition = data['condition'];
    isAvailable = data['is_available'];

    oldImages = List<String>.from(data['images'] ?? []);

    // استرجاع اسم الفئة من ال ID
    final category = categories.firstWhere(
      (c) => c['id'] == selectedCategoryId,
      orElse: () => {},
    );

    if (category.isNotEmpty) {
      selectedCategoryName = category["name"];
    }

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

  // ----------------------------
  // اختيار صور جديدة
  // ----------------------------
  Future<void> pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      newImages = pickedFiles.map((e) => File(e.path)).toList();
      notifyListeners();
    }
  }

  // ----------------------------
  //   تحديث الفئة
  // ----------------------------
  void selectCategory(String? value) {
    final category = categories.firstWhere((c) => c['name'] == value);
    selectedCategoryName = value;
    selectedCategoryId = category['id'];
    notifyListeners();
  }

  // ----------------------------
  //   تحديث الحالة
  // ----------------------------
  void selectCondition(String? value) {
    selectedCondition = value;
    notifyListeners();
  }

  // ----------------------------
  //   تحديث توفر العنصر
  // ----------------------------
  void toggleAvailability(bool v) {
    isAvailable = v;
    notifyListeners();
  }

  // ----------------------------
  //   حفظ التعديلات
  // ----------------------------
  Future<bool> updateItem(BuildContext context) async {
    if (!formKey.currentState!.validate()) return false;

    List<String> imagesList = [...oldImages];

    // إذا تم إضافة صور جديدة → نرفعها
    if (newImages.isNotEmpty) {
      for (final img in newImages) {
        final url = await MyItemsServices().uploadImage(
          file: img,
          userId: supabase.auth.currentUser!.id,
        );
        if (url != null) imagesList.add(url);
      }
    }

    await supabase
        .from("user_items")
        .update({
          "title": addItemsTitle.text.trim(),
          "description": addItemsDescription.text.trim(),
          "quantity": int.parse(addItemsQuantity.text.trim()),
          "category_id": selectedCategoryId,
          "condition": selectedCondition,
          "is_available": isAvailable,
          "images": imagesList,
          "updated_at": DateTime.now().toIso8601String(),
        })
        .eq("id", itemId);

    return true;
  }
}
