import 'dart:io';

import 'package:flutter/material.dart';
import 'package:giver_receiver/logic/services/variables_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentUserData {
  final supabase = Supabase.instance.client;
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return response;
  }

  ///////////////////////////////////////////////////////
  Future<void> updateProfile(BuildContext context) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    String? imageUrl;

    // لو المستخدم اختر صورة
    if (selectedImage != null) {
      imageUrl = await uploadProfileImage(selectedImage!, user.id);
    }

    final updates = {
      'full_name': editeProfileName.text.trim(),
      'email': editProfileEmail.text.trim(),
      'phone_number': editProfilePhone.text.trim(),
      if (imageUrl != null) 'image': imageUrl, // ← نخزن الرابط فقط
    };

    final response = await supabase
        .from('users')
        .update(updates)
        .eq('id', user.id);

    print(response);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Profile updated successfully')),
      );
    }
  }

  // Future<void> updateProfile(BuildContext context) async {
  //   final user = supabase.auth.currentUser;
  //   if (user == null) return;

  //   final updates = {
  //     'full_name': editeProfileName.text.trim(),
  //     'email': editProfileEmail.text.trim(),
  //     'phone_number': editProfilePhone.text.trim(),
  //     'image': selectedImage,
  //   };

  //   final response = await supabase
  //       .from('users')
  //       .update(updates)
  //       .eq('id', user.id);

  //   print(response); // Debug

  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('✅ Profile updated successfully')),
  //     );
  //   }
  // }

  //////////////////////////////////////////////////////////////////
  Future<String?> uploadProfileImage(File file, String userId) async {
    final fileName = 'profile_$userId.jpg';

    try {
      await supabase.storage
          .from('update_profile_images') // اسم الباكيت
          .upload(fileName, file, fileOptions: const FileOptions(upsert: true));

      return supabase.storage
          .from('update_profile_images')
          .getPublicUrl(fileName);
    } catch (e) {
      print("Image Upload Error: $e");
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
  Future<int> getCurrentDonationsCount() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final response = await Supabase.instance.client
        .from('user_items')
        .select('''
        id,
        requests!inner (
          status
        )
      ''')
        .eq('user_id', userId)
        .eq('requests.status', 'pending');

    // نعد العناصر بدون تكرار
    final uniqueItems = response.map((e) => e['id']).toSet();
    return uniqueItems.length;
  }

  ///////////////////////////////////////////////////////////////////////////////////
  Future<int> getPreviousDonationsCount() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final response = await Supabase.instance.client
        .from('user_items')
        .select('''
        id,
        requests!inner (
          status
        )
      ''')
        .eq('user_id', userId)
        .eq('requests.status', 'delivered');

    final uniqueItems = response.map((e) => e['id']).toSet();
    return uniqueItems.length;
  }
}
