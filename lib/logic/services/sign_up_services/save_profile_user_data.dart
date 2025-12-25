import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaveProfileUserData {
  final picker = ImagePicker();
  Future<File?> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      return File(picked.path);
    }
    return null;
  }

  Future<String?> uploadImage(File file) async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        debugPrint('No user is currently logged in while uploading the image');
        return null;
      }

      final fileName =
          'users_${currentUser.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await Supabase.instance.client.storage
          .from('users_images')
          .upload(fileName, file);

      final publicUrl = Supabase.instance.client.storage
          .from('users_images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<void> saveUserData({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String id,
    required String username,
    required String email,
    required String fullName,
    required String phone,
    required String role,
    File? imageFile,
  }) async {
    if (!formKey.currentState!.validate()) return;

    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile);
    }

    // String? imageUrl;
    // final parentUser = Supabase.instance.client.auth.currentUser;
    // if (parentUser == null) {
    //   debugPrint('No user currently logged in');
    //   return;
    // }

    try {
      final response = await Supabase.instance.client.from('users').insert({
        'id': id,
        'username': username,
        'email': email,
        'full_name': fullName,
        'phone_number': phone,
        'image': imageUrl,
        'role': role,

        //"tokens": [await getIt<FirebaseMessaging>().getToken()]
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The data has been saved successfully')),
      );

      return response;
    } catch (e) {
      debugPrint('Insert error: $e');
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('error: $e')));
    }
  }
}
