import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiveId;
  // final String receiveEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiveId,   
    required this.message,
    required this.timestamp,
  });

  //convert to the map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiveId': receiveId,      
      'message': message,
      'timestamp': timestamp,
    };
  }
}
