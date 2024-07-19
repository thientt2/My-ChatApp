import 'package:chatapp_basic/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get instance of firebase and auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();

        //return user
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiveId, message) async {
    //get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiveId: receiveId,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room Id for the two user (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, receiveId];
    ids.sort(); //sort the ids (this ensure the chatroomId is the same for any 2 people)
    String chatroomId = ids.join("_");

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("message")
        .add(newMessage.toMap());
  }

  //get messages

  Stream<QuerySnapshot> getMessage(String userId, otherUserId) {
    //constuct a chat room ID for the 2 people
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("message")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
