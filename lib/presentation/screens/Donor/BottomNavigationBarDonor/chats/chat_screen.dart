import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giver_receiver/logic/cubit/chat/chat_cubit.dart';
import 'package:giver_receiver/logic/cubit/chat/chat_state.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/logic/services/sized_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatDonorScreen extends StatefulWidget {
  final String chatId;
  final String recipientName;
  final String recipientImage;

  const ChatDonorScreen({
    super.key,
    required this.chatId,
    required this.recipientName,
    required this.recipientImage,
  });

  @override
  State<ChatDonorScreen> createState() => _ChatDonorScreenState();
}

class _ChatDonorScreenState extends State<ChatDonorScreen> {
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
              //   isVideoCall: false,
              //   userId: cubit.callUserId!,
              //   userName: cubit.callUserName!,
              // );
            },
            icon: Icon(Icons.call, size: SizeConfig.width * 0.07),
          ),
          IconButton(
            onPressed: () {
              // ZegoServices.callWithZego(
              //   isVideoCall: true,
              //   userId: cubit.callUserId!,
              //   userName: cubit.callUserName!,
              // );
            },
            icon: Icon(
              color: Colors.white,
              Icons.video_chat_outlined,
              size: SizeConfig.width * 0.07,
            ),
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
                  return ListView.builder(
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
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    context.read<UserChatCubit>().sendMessage(
                      controller.text.trim(),
                    );

                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
