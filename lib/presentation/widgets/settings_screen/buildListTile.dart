import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

Widget buildListTile({
  required IconData icon,
  required String title,
  Widget? trailing,
  required VoidCallback onTap,
}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: ListTile(
      leading: Icon(icon, color: AppColors().primaryColor),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing,
      onTap: onTap,
    ),
  );
}

Widget divider() {
  return const Divider(height: 0, thickness: 0.5, indent: 20, endIndent: 20);
}
