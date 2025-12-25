import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

class SaveButtonWidgetItems extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  /// إذا true → الزر سيغير لونه تلقائياً عند الضغط
  /// إذا false → اللون يعتمد على isActive القادم من الأب
  final bool flipColorOnTap;

  /// هل الزر مفعّل (لونه شغال) → تستخدم عندما flipColorOnTap = false
  final bool isActive;

  const SaveButtonWidgetItems({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.flipColorOnTap = true,
    this.isActive = false,
  });

  @override
  State<SaveButtonWidgetItems> createState() => _SaveButtonWidgetItemsState();
}

class _SaveButtonWidgetItemsState extends State<SaveButtonWidgetItems> {
  bool internalActive = false;

  @override
  void initState() {
    super.initState();

    /// إذا الزر يعتمد على الضغط → نستعمل internalActive
    /// إذا الزر لا يعتمد على الضغط → نتجاهل internalActive
    internalActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    final bool active = widget.flipColorOnTap
        ? internalActive
        : widget.isActive;

    return GestureDetector(
      onTap: () {
        if (widget.flipColorOnTap) {
          setState(() => internalActive = !internalActive);
        }
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors().primaryColor : Colors.transparent,
          border: Border.all(color: AppColors().primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 22,
              color: active ? Colors.white : AppColors().primaryColor,
            ),
            const SizedBox(width: 7),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: active ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
