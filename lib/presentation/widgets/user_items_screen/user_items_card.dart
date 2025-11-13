import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';

class UserItemsCard extends StatelessWidget {
  // final String name;
  // final String specialty;
  final String content;
  final String? imageUrl;
  final String timeAgo;
  // final String avatarUrl;

  const UserItemsCard({
    super.key,
    // required this.name,
    // required this.specialty,
    required this.content,
    required this.timeAgo,
    this.imageUrl,
    // required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Divider(color: Colors.grey[300], thickness: 1.5),
        ),

        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Unknown',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            timeAgo,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),

          leading: Container(
            width: 55,
            height: 60,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
            ),
            child: Icon(Icons.person, color: AppColors().primaryColor),
          ),
        ),

        SizedBox(height: 15),

        Text(content, style: const TextStyle(fontSize: 16)),

        SizedBox(height: 10),
        if (imageUrl != null)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 30),
        //   child: Divider(color: Colors.grey[300], thickness: 1.5),
        // ),
      ],
    );
  }
}
