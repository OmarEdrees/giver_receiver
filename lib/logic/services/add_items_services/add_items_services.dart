import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class AddItemsServices {
  final supabase = Supabase.instance.client;
  final bucket = "add_items_images";

  Future<String?> uploadImage({
    required File file,
    required String userId,
  }) async {
    final fileName =
        'add_items_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from(bucket).upload(fileName, file);
    return supabase.storage.from(bucket).getPublicUrl(fileName);
  }

  ////////////////////////////////////////////////////////////////////////////
  Future<bool?> insertItems({
    required String userId,
    required String name,
    required String description,
    File? imageFile,
    required String status,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(file: imageFile, userId: user.id);
    }
    try {
      await supabase.from("user_items").insert({
        "user_id": userId,
        "name": name,
        "description": description,
        "image": imageUrl,
        "status": status,
      });

      return true;
    } catch (e) {
      print("Insert Tip Error: $e");
      return false;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>?> getItems() async {
    try {
      final response = await supabase
          .from('user_items')
          .select()
          .order('created_at', ascending: false); // لترتيب الأحدث أولاً

      // التأكد من أن النتيجة ليست فارغة
      if (response.isEmpty) {
        print('No items found for user');
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get Items Error: $e');
      return null;
    }
  }
}
