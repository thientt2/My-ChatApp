import 'package:chatapp_basic/UI/chat.dart';
import 'package:chatapp_basic/components/user_tile.dart';
import 'package:chatapp_basic/services/auth/auth_service.dart';
import 'package:chatapp_basic/components/my_drawer.dart';
import 'package:chatapp_basic/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  //chat & auth service
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: chatService.getUserStream(),
        builder: (context, snapshot) {
          //error
          if (snapshot.hasError) {
            return const Text("Error");
          }
          //loanding...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loanding...");
          }
          //return list view
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }
  //build individual list tile for user

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //displays all users except current user
    if (userData["email"] != authService.getCurrentUser()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            //tappped on a user => go to chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiveEmail: userData["email"],
                  receiveId: userData["uid"],
                ),
              ),
            );
          });
    } else {
      return Container();
    }
  }
}
