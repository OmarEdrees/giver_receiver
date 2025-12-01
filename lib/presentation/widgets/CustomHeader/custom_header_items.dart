import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';

class CustomHeaderItems extends StatelessWidget {
  const CustomHeaderItems({super.key, required this.icon, required this.name});
  final String name;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height * 0.16,
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text("👋", style: TextStyle(fontSize: 35)),
          ),
          SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                'Hi $name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.height * 0.03,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              Text(
                'Browse items and donate what you can',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: SizeConfig.height * 0.0165,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
