import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/GetCurrentUserData/get_current_user_data.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/screens/CustomHeader/custom_header.dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/items_screen.dart';
import 'package:giver_receiver/presentation/screens/Donor/BottomNavigationBarDonor/my_items_screen/my_items_screen..dart';
import 'package:giver_receiver/presentation/screens/auth/edite_profile_screen.dart';
import 'package:giver_receiver/presentation/screens/auth/sign_in_screen.dart';
import 'package:giver_receiver/presentation/widgets/settings/buildListTile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final currentUserData = CurrentUserData();
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    profileData = await currentUserData.getCurrentUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout, color: Colors.black),
      //       onPressed: () {
      //         Supabase.instance.client.auth.signOut();
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => SignInScreen()),
      //         );
      //         emailController.clear();
      //         passController.clear();
      //       },
      //     ),
      //   ],
      // ),
      body: Center(
        child: Column(
          children: [
            const CustomHeader(icon: Icons.settings, title: 'Settings'),
            const SizedBox(height: 25),
            // صورة البروفايل
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[300],
              backgroundImage: selectedImage != null
                  ? FileImage(selectedImage!)
                  : NetworkImage(
                          profileData?['image'] ??
                              'assets/images/autism-high-resolution-logo.png',
                        )
                        as ImageProvider, // ضع صورتك هنا
            ),
            const SizedBox(height: 15),
            Text(
              profileData?['full_name'] ?? '',

              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              profileData?['phone_number'] ?? '',

              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditeProfileScreen()),
                ).then((value) {
                  if (value == true) {
                    loadProfile(); // 👈 هذا سيعمل refresh تلقائي
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: Colors.grey),
                ),
              ),
              child: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 290,
        padding: EdgeInsets.only(top: 10),

        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildListTile(
                icon: Icons.settings,
                title: "Settings",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              divider(),
              buildListTile(
                icon: Icons.lock,
                title: "Change password",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              divider(),
              buildListTile(
                icon: Icons.card_giftcard_sharp,
                title: "Refer friends",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              divider(),
              buildListTile(
                icon: Icons.info,
                title: "About",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              divider(),
              buildListTile(
                icon: Icons.phone,
                title: "Contact us",
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
