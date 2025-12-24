import 'package:supabase_flutter/supabase_flutter.dart';

class RequestsOnMyItemServices {
  Future<List<Map<String, dynamic>>> getRequestsForItem(String itemId) async {
    try {
      final response = await Supabase.instance.client
          .from('requests')
          .select('''
          id,
          reason,
          attachment_url,
          status,
          created_at,
          requester:users!requests_requester_id_fkey (
            id,
            full_name,
            image
          )
        ''')
          .eq('item_id', itemId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("❌ ERROR GET ITEM REQUESTS: $e");
      return [];
    }
  }
}
