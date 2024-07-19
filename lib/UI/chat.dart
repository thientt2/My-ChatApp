import 'package:chatapp_basic/components/chat_bubble.dart';
import 'package:chatapp_basic/components/my_textfield.dart';
import 'package:chatapp_basic/services/auth/auth_service.dart';
import 'package:chatapp_basic/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiveEmail;
  final String receiveId;

  ChatPage({
    super.key,
    required this.receiveEmail,
    required this.receiveId,
  });

  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat and auth service
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  //send message
  void sendMessage() async {
    //if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      //send the message
      await chatService.sendMessage(receiveId, _messageController.text);

      //clear text controller
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiveEmail),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          //display all message
          Expanded(
            child: _builMessageList(),
          ),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _builMessageList() {
    String senderId = authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: chatService.getMessage(receiveId, senderId),
      builder: (context, snapshot) {
        //errors
        if (snapshot.hasError) {
          return const Text("Errors");
        }

        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        //return list view
        return ListView(
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser = data['senderId'] == authService.getCurrentUser()!.uid;

    //align message to the right if sender is the current user, ortherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data['message'],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  //build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take up most of the space
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
            ),
          ),

          //send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),
    );
  }
}
