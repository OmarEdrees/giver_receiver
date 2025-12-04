import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyItemsServices {
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
  // Future<bool?> insertItems({
  //   required String userId,
  //   required String name,
  //   required String description,
  //   File? imageFile,
  //   required String status,
  // }) async {
  //   final user = supabase.auth.currentUser;
  //   if (user == null) return null;
  //   String? imageUrl;
  //   if (imageFile != null) {
  //     imageUrl = await uploadImage(file: imageFile, userId: user.id);
  //   }
  //   try {
  //     await supabase.from("user_items").insert({
  //       "user_id": userId,
  //       //"name": name,
  //       "description": description,
  //       "images": imageUrl,
  //       // "status": status,
  //     });

  //     return true;
  //   } catch (e) {
  //     print("Insert Tip Error: $e");
  //     return false;
  //   }
  // }
  Future<bool> insertItems({
    required String userId,
    required String title,
    required String description,
    required int quantity,
    required String categoryId, // UUID من جدول الـ Categories
    required String condition, // new / used
    required List<File> imageFile, // صورة واحدة فقط (نخزنها كـ Array)
    required bool isAvailable, // true / false
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print("User not logged in");
        return false;
      }

      List<String>? imagesList;

      // رفع الصورة إذا موجودة
      if (imageFile.isNotEmpty) {
        imagesList = [];
        for (final file in imageFile) {
          final uploadedUrl = await uploadImage(file: file, userId: user.id);

          if (uploadedUrl == null) {
            print("Image upload failed");
            return false;
          }

          imagesList.add(uploadedUrl);
        }
      }

      // تنفيذ عملية الإدخال
      await supabase.from("user_items").insert({
        "user_id": userId,
        "title": title,
        "description": description,
        "quantity": quantity,
        "category_id": categoryId,
        "condition": condition,
        "images": imagesList, // array of URLs
        "is_available": isAvailable,
        "created_at": DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print("Insert Items Error: $e");
      return false;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>?> getAllItems() async {
    try {
      final response = await supabase
          .from('user_items')
          .select()
          .eq('is_hidden', false) // ← إخفاء العناصر المعطلة
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        print('No visible items found');
        return [];
      }

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Get Items Error: $e');
      return null;
    }
  }
  // Future<List<Map<String, dynamic>>?> getAllItems() async {
  //   try {
  //     final response = await supabase
  //         .from('user_items')
  //         .select()
  //         .order('created_at', ascending: false); // لترتيب الأحدث أولاً

  //     // التأكد من أن النتيجة ليست فارغة
  //     if (response.isEmpty) {
  //       print('No items found for user');
  //       return [];
  //     }

  //     return List<Map<String, dynamic>>.from(response);
  //   } catch (e) {
  //     print('Get Items Error: $e');
  //     return null;
  //   }
  // }

  ////////////////////////////////////////////////////////////////////////////
  Future<List<Map<String, dynamic>>?> getMyItems() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) return [];

      final response = await Supabase.instance.client
          .from('user_items')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ ERROR GET USER ITEMS: $e");
      return [];
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<bool> deleteItem(String itemId) async {
    try {
      final supabase = Supabase.instance.client;

      // حذف الصور من التخزين قبل حذف العنصر (اختياري)
      final itemData = await supabase
          .from('user_items')
          .select('images')
          .eq('id', itemId)
          .single();

      final List<dynamic>? images = itemData['images'];

      if (images != null && images.isNotEmpty) {
        for (var imgUrl in images) {
          final String fileName = imgUrl.split('/').last;
          await supabase.storage.from('add_items_images').remove([fileName]);
        }
      }

      // حذف العنصر من الجدول
      await supabase.from('user_items').delete().eq('id', itemId);

      return true;
    } catch (e) {
      print('ERROR DELETE ITEM: $e');
      return false;
    }
  }
}
