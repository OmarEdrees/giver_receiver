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
  bool _isClosed = false;
  bool _isReported = false;

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
          'close': false,
          'is_reported': false,
        });
        _messages = [];
        _isClosed = false;
        _isReported = false;
      } else {
        _messages = List<Map<String, dynamic>>.from(response['messages'] ?? []);
        _isClosed = response['close'] ?? false;
        _isReported = response['is_reported'] ?? false;
      }
      emit(ChatLoaded(List.from(_messages), _isClosed, _isReported));
      _listenRealtime();
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  /// إرسال رسالة
  Future<void> sendMessage(String text) async {
    if (_isClosed) return; // لا تسمح بالإرسال إذا كانت مغلقة

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
    emit(ChatLoaded(List.from(_messages), _isClosed, _isReported));
  }

  /// الإبلاغ عن المحادثة
  Future<void> reportChat() async {
    if (_isReported) return; // تجنب الإبلاغ المتكرر

    await supabase
        .from('chats')
        .update({'is_reported': true})
        .eq('id', chatId);
    _isReported = true;
    emit(ChatLoaded(List.from(_messages), _isClosed, _isReported));
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
            final newClosed = payload.newRecord['close'] ?? false;
            final newReported = payload.newRecord['is_reported'] ?? false;
            _messages = List<Map<String, dynamic>>.from(newMessages ?? []);
            _isClosed = newClosed;
            _isReported = newReported;
            emit(ChatLoaded(List.from(_messages), _isClosed, _isReported));
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