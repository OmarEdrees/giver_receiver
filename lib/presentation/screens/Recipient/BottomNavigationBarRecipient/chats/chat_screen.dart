import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giver_receiver/logic/cubit/chat/chat_cubit.dart';
import 'package:giver_receiver/logic/cubit/chat/chat_state.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatRecipientScreen extends StatefulWidget {
  final String chatId;
  final String recipientName;
  final String recipientImage;

  const ChatRecipientScreen({
    super.key,
    required this.chatId,
    required this.recipientName,
    required this.recipientImage,
  });

  @override
  State<ChatRecipientScreen> createState() => _ChatRecipientScreenState();
}

class _ChatRecipientScreenState extends State<ChatRecipientScreen> {
  final TextEditingController controller = TextEditingController();
  final myId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    context.read<UserChatCubit>().loadChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors().primaryColor.withOpacity(0.8),
        titleSpacing: 0,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade600,
              backgroundImage: NetworkImage(widget.recipientImage),
            ),
            SizedBox(width: 12),
            Text(
              widget.recipientName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // ZegoServices.callWithZego(
              // isVideoCall: false,
              // userId: cubit.callUserId!,
              // userName: cubit.callUserName!,
              // );
            },
            icon: Icon(Icons.call, size: SizeConfig.width * 0.07),
          ),
          IconButton(
            onPressed: () {
              // ZegoServices.callWithZego(
              // isVideoCall: true,
              // userId: cubit.callUserId!,
              // userName: cubit.callUserName!,
              // );
            },
            icon: Icon(
              color: Colors.white,
              Icons.video_chat_outlined,
              size: SizeConfig.width * 0.07,
            ),
          ),
          // زر الإبلاغ
          BlocBuilder<UserChatCubit, ChatState>(
            builder: (context, state) {
              if (state is ChatLoaded && !state.isReported) {
                return IconButton(
                  onPressed: () {
                    context.read<UserChatCubit>().reportChat();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم الإبلاغ عن المحادثة')),
                    );
                  },
                  icon: const Icon(Icons.flag_outlined, color: Colors.white),
                  tooltip: 'الإبلاغ',
                );
              }
              return const SizedBox.shrink(); // إخفاء الزر إذا تم الإبلاغ بالفعل
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<UserChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChatLoaded) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final msg = state.messages[index];
                            final isMe = msg['id'] == myId;
                            return BubbleSpecialThree(
                              isSender: isMe,
                              text: msg['message'],
                              color: isMe
                                  ? AppColors().primaryColor
                                  : Colors.grey.shade300,
                              tail: true,
                              textStyle: TextStyle(
                                color: isMe ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            );
                          },
                        ),
                      ),
                      if (state.isClosed)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: const Text(
                            'الأدمن أغلق المحادثة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          // Input - يظهر فقط إذا لم تكن مغلقة
          BlocBuilder<UserChatCubit, ChatState>(
            builder: (context, state) {
              if (state is! ChatLoaded || state.isClosed) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextFormField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "enter your message",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (controller.text.trim().isEmpty) return;
                        context.read<UserChatCubit>().sendMessage(
                          controller.text.trim(),
                        );
                        controller.clear();
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors().primaryColor,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}