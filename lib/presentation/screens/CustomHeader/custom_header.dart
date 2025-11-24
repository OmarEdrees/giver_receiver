import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key, required this.icon, required this.title});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height * 0.135,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.height * 0.025,
        horizontal: SizeConfig.width * 0.06,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors().primaryColor,
            AppColors().primaryColor.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors().primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(icon, color: Colors.white, size: SizeConfig.height * 0.04),
        ],
      ),
    );
  }
}
