import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_state.dart';

class UserChatCubit extends Cubit<ChatState> {
  UserChatCubit({
    required this.chatId,
    required this.currentUserId,
    required this.otherUserId,
  }) : super(ChatInitial());

  final String chatId;
  final String currentUserId; // الموهوب أو الواهب
  final String otherUserId; // الادمن أو الشخص الآخر

  final supabase = Supabase.instance.client;
  RealtimeChannel? _channel;

  List<Map<String, dynamic>> _messages = [];

  /// تحميل الشات + الاشتراك بالريل تايم
  Future<void> loadChat() async {
    emit(ChatLoading());

    try {
      final response = await supabase
          .from('chats')
          .select()
          .eq('id', chatId)
          .maybeSingle();

      // إذا ما في محادثة، ينشئ واحدة
      if (response == null) {
        await supabase.from('chats').insert({
          'id': chatId,
          'user_one_id': currentUserId,
          'user_two_id': otherUserId,
          'messages': [],
        });

        _messages = [];
      } else {
        _messages = List<Map<String, dynamic>>.from(response['messages'] ?? []);
      }

      emit(ChatLoaded(List.from(_messages)));
      _listenRealtime();
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  /// إرسال رسالة
  Future<void> sendMessage(String text) async {
    final newMessage = {
      'id': currentUserId,
      'message': text,
      'created_at': DateTime.now().toIso8601String(),
    };

    _messages.add(newMessage);

    await supabase
        .from('chats')
        .update({'messages': _messages})
        .eq('id', chatId);

    emit(ChatLoaded(List.from(_messages)));
  }

  /// الريل تايم
  void _listenRealtime() {
    _channel?.unsubscribe();

    _channel = supabase
        .channel('chat_$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chats',
          callback: (payload) {
            final newMessages = payload.newRecord['messages'];
            _messages = List<Map<String, dynamic>>.from(newMessages ?? []);
            emit(ChatLoaded(List.from(_messages)));
          },
        )
        .subscribe();
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}
