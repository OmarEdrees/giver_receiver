import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

class SaveButtonWidget extends StatefulWidget {
  final IconData icon;
  final String title;
  final Future<void> Function()? ontap;
  const SaveButtonWidget({
    super.key,
    required this.icon,
    required this.title,
    this.ontap,
  });

  @override
  State<SaveButtonWidget> createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget> {
  bool changeColor = false; // ← خليها هنا داخل الـ State

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: changeColor ? AppColors().primaryColor : Colors.transparent,
          border: Border.all(color: AppColors().primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 22,
              color: changeColor ? Colors.white : AppColors().primaryColor,
            ),
            const SizedBox(width: 7),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: changeColor ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
