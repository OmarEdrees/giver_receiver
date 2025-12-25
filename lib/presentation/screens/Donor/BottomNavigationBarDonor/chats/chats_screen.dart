import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giver_receiver/logic/cubit/chat/chat_cubit.dart';
import 'package:giver_receiver/logic/services/colors_app.dart';
import 'package:giver_receiver/presentation/screens/Recipient/BottomNavigationBarRecipient/chats/chat_screen.dart';
import 'package:giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatssDonorScreen extends StatelessWidget {
  ChatssDonorScreen({super.key});

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final myId = supabase.auth.currentUser!.id;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Color(0xFF17A589)],
            stops: [0.0, 0.7, 1.5],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CustomHeader(icon: Icons.chat, title: "Chats"),
            const SizedBox(height: 15),
            //////////////////////////////////////////////////////////
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: TextFormField(
                // controller: reqestScreenSearch,
                cursorColor: AppColors().primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Search for Chats',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors().primaryColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  // controller.applyFilters(value);
                  // setState(() {});
                },
              ),
            ),
            //////////////////////////////////////////////////////
            Expanded(
              child: FutureBuilder(
                future: supabase
                    .from('chats')
                    .select('''
                    id,
                    user_one_id,
                    user_two_id,
                    messages,
                    user_one:users!user_one_id(id, full_name, image),
                    user_two:users!user_two_id(id, full_name, image)
                  ''')
                    .or('user_one_id.eq.$myId,user_two_id.eq.$myId'),
                //.order('created_at', ascending: false),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final chats = snapshot.data as List;

                  if (chats.isEmpty) {
                    return const Center(child: Text('No chats yet'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final chatId = chat['id'];

                      final userOne = chat['user_one'];
                      final userTwo = chat['user_two'];

                      final isMeUserOne = chat['user_one_id'] == myId;
                      final recipient = isMeUserOne ? userTwo : userOne;

                      final recipientName = recipient?['full_name'] ?? 'User';
                      final recipientImage = recipient?['image'];

                      final messages = chat['messages'] as List<dynamic>;
                      final lastMessage = messages.isNotEmpty
                          ? messages.last['message']
                          : 'No messages yet';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => UserChatCubit(
                                  currentUserId: myId,
                                  otherUserId: chat['user_one_id'] == myId
                                      ? chat['user_two_id']
                                      : chat['user_one_id'],
                                  chatId: chatId,
                                  //adminId: myId,
                                  // recipientId: chat['user_one_id'] == myId
                                  //     ? chat['user_two_id']
                                  //     : chat['user_one_id'],
                                )..loadChat(),
                                child: ChatRecipientScreen(
                                  chatId: chatId,
                                  recipientName: recipientName,
                                  recipientImage: recipientImage,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 10,
                            right: 15,
                            left: 15,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            horizontalTitleGap: 10,
                            title: Text(
                              recipientName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600]),
                            ),

                            trailing: Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Icon(
                                CupertinoIcons.chat_bubble,
                                color: AppColors().primaryColor,
                                size: 24,
                              ),
                            ),

                            leading: Container(
                              width: 60,
                              height: 65,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade600,
                                image: DecorationImage(
                                  image: recipientImage != null
                                      ? NetworkImage(recipientImage)
                                      : const AssetImage(
                                              'assets/images/facebook.png',
                                            )
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
