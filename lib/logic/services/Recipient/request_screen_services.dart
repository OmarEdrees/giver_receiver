import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestServices {
  final supabase = Supabase.instance.client;

  /// ---------------------------------------------------------
  /// 1️⃣ رفع صورة الطلب (إن وُجدت)
  /// ---------------------------------------------------------
  Future<String?> uploadAttachment(File? image) async {
    if (image == null) return null;

    try {
      final filePath = "requests/${DateTime.now().millisecondsSinceEpoch}.jpg";

      await supabase.storage.from('requests_images').upload(filePath, image);

      final url = supabase.storage
          .from('requests_images')
          .getPublicUrl(filePath);

      return url;
    } catch (e) {
      print("Upload Attachment Error: $e");
      return null;
    }
  }

  /// ---------------------------------------------------------
  /// 2️⃣ إرسال الطلب وحفظه في قاعدة البيانات
  /// ---------------------------------------------------------
  // Future<bool> sendRequest({
  //   required String itemId,
  //   required String reason,
  //   File? attachment,
  // }) async {
  //   try {
  //     final userId = supabase.auth.currentUser!.id;

  //     // رفع الصورة إذا موجودة
  //     final attachmentUrl = await uploadAttachment(attachment);

  //     await supabase.from('requests').insert({
  //       'item_id': itemId,
  //       'requester_id': userId,
  //       'reason': reason,
  //       'attachment_url': attachmentUrl,
  //       'created_at': DateTime.now().toIso8601String(),
  //     });

  //     return true;
  //   } catch (e) {
  //     print("Send Request Error: $e");
  //     return false;
  //   }
  // }
  Future<bool> sendRequest({
    required String itemId,
    required String reason,
    File? attachment,
  }) async {
    try {
      final userId = supabase.auth.currentUser!.id; // requester (اللي عم يطلب)

      // 1️⃣ جيب صاحب العنصر (donor)
      final itemData = await supabase
          .from('user_items')
          .select('user_id')
          .eq('id', itemId)
          .maybeSingle();

      if (itemData == null || itemData['user_id'] == null) {
        print("❌ Error: item has no owner!");
        return false;
      }

      final donorId = itemData['user_id']; // ← صاحب العنصر

      // 2️⃣ ارفع الصورة (إذا موجودة)
      final attachmentUrl = await uploadAttachment(attachment);

      // 3️⃣ خزّن الطلب في requests
      await supabase.from('requests').insert({
        'item_id': itemId,
        'requester_id': userId,
        'donor_id': donorId, // ⬅️ أضفناها هون
        'reason': reason,
        'attachment_url': attachmentUrl,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print("Send Request Error: $e");
      return false;
    }
  }

  /// ---------------------------------------------------------
  /// 3️⃣ جلب الطلبات حسب المستخدم الحالي
  /// ---------------------------------------------------------
  Future<List<Map<String, dynamic>>> getMyRequests() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from('requests')
          .select()
          .eq('requester_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Get My Requests Error: $e");
      return [];
    }
  }

  /// ---------------------------------------------------------
  /// 4️⃣ جلب كل الطلبات على عنصر معين
  /// ---------------------------------------------------------
  Future<List<Map<String, dynamic>>> getRequestsForItem(String itemId) async {
    try {
      final response = await supabase
          .from('requests')
          .select()
          .eq('item_id', itemId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Get Requests For Item Error: $e");
      return [];
    }
  }

  /// ---------------------------------------------------------
  /// حذف عنصر معين
  /// ---------------------------------------------------------
  Future<bool> deleteRequest(String requestId) async {
    try {
      await supabase.from('requests').delete().eq('id', requestId);
      return true;
    } catch (e) {
      print("Delete Error: $e");
      return false;
    }
  }
}
