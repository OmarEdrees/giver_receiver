import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

class FilterItemBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> categoriesList;

  const FilterItemBottomSheet({super.key, required this.categoriesList});

  @override
  State<FilterItemBottomSheet> createState() => _FilterItemBottomSheetState();
}

class _FilterItemBottomSheetState extends State<FilterItemBottomSheet> {
  String selectedCondition = "";
  String selectedCategory = "";

  final List<String> itemConditions = [
    "جديد تمامًا",
    "شبه جديد",
    "مستخدم - ممتاز",
    "مستخدم - جيد",
    "مستخدم - مقبول",
    "مستخدم بكثرة",
    "يحتاج إلى صيانة",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      child: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  "الفلتر",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 25),
              const Text(
                "الحالة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: itemConditions.map((condition) {
                  final isActive = selectedCondition == condition;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(condition),
                    selected: isActive,
                    selectedColor: AppColors().primaryColor,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() => selectedCondition = condition);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),
              const Text(
                "الأقسام",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: widget.categoriesList.map((cat) {
                  final catName = cat['name'] ?? '';
                  final isActive = selectedCategory == catName;
                  return ChoiceChip(
                    showCheckmark: false,
                    label: Text(catName),
                    selected: isActive,
                    selectedColor: AppColors().primaryColor,
                    backgroundColor: Colors.grey[200],
                    labelStyle: TextStyle(
                      color: isActive ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() => selectedCategory = catName);
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors().primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // إيجاد الـ category_id من الاسم المختار (إن وجد)
                    final selectedCategoryId = widget.categoriesList.firstWhere(
                      (cat) => cat['name'] == selectedCategory,
                      orElse: () => {},
                    )['id'];

                    Navigator.pop(context, {
                      "condition": selectedCondition,
                      "category_id": selectedCategoryId ?? "",
                    });
                  },
                  child: const Text(
                    "تطبيق الفلتر",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
