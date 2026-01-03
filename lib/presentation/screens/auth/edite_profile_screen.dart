import 'dart:io';
import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/Donor/GetCurrentUserData/get_current_user_data.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:giver_receiver/presentation/widgets/customTextFields.dart';
import 'package:image_picker/image_picker.dart';

class EditeProfileScreen extends StatefulWidget {
  const EditeProfileScreen({super.key});

  @override
  State<EditeProfileScreen> createState() => _EditeProfileScreenState();
}

class _EditeProfileScreenState extends State<EditeProfileScreen> {
  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Map<String, dynamic>? profileData;
  final currentUserData = CurrentUserData();

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  void loadProfile() async {
    final data = await currentUserData.getCurrentUserData();
    if (!mounted) return;
    setState(() {
      profileData = data;
      editeProfileName.text = profileData?['full_name'] ?? '';
      editProfileEmail.text = profileData?['email'] ?? '';
      editProfilePhone.text = profileData?['phone_number'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            CustomHeader(icon: Icons.person, title: 'تعديل الملف الشخصي'),
            SizedBox(height: 5),
            Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // صورة البروفايل
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 75,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : profileData?['image'] != null
                                ? NetworkImage(profileData!['image'])
                                : null,
                            child:
                                selectedImage == null &&
                                    profileData?['image'] == null
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey[700],
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 30),
                        CustomTextFormField(
                          focusNode: editProfileNameFocus,
                          controller: editeProfileName,
                          hintText: "الاسم الكامل",
                          icon: Icons.person,
                          validator: addChildNameValidator,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          focusNode: editProfileEmailFocus,
                          controller: editProfileEmail,
                          hintText: 'البريد الالكتروني',
                          icon: Icons.email,
                          validator: emailValidator,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          keyboardType: TextInputType.number,
                          focusNode: editProfilePhoneFocus,
                          controller: editProfilePhone,
                          hintText: 'رقم الهاتف',
                          icon: Icons.phone,
                          validator: addChildNameValidator,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            await currentUserData.updateProfile(context);
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors().primaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'تعديل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
