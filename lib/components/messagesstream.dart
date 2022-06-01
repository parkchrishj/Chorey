//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
//
//class MessagesStream extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder<QuerySnapshot>(
//      stream: _firestore.collection('messages').snapshots(),
//      builder: (context, snapshot) {
////        if (!snapshot.hasData) {
////          return Center(
////            child: CircularProgressIndicator(
////              backgroundColor: Colors.lightBlueAccent,
////            ),
////          );
////        }
//        final messages = snapshot.data.documents.reversed;
//        List<MessageBubble> messageBubbles = [];
//        for (var message in messages) {
//          final messageText = message.data['text'];
//          final messageSender = message.data['sender'];
//
//          final currentUser = loggedInUser.email;
//
//          final messageBubble = MessageBubble(
//            sender: messageSender,
//            text: messageText,
//            isMe: currentUser == messageSender,
//          );
//
//          messageBubbles.add(messageBubble);
//        }
//        return Expanded(
//          child: ListView(
//            reverse: true,
//            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//            children: messageBubbles,
//          ),
//        );
//      },
//    );
//  }
//}
//
//class MessageBubble extends StatelessWidget {
//  MessageBubble({this.sender, this.text, this.isMe});
//
//  final String sender;
//  final String text;
//  final bool isMe;
//
//  @override
//  Widget build(BuildContext context) {
//    return Padding(
//      padding: EdgeInsets.all(10.0),
//      child: Column(
//        crossAxisAlignment:
//            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//        children: <Widget>[
//          Text(
//            sender,
//            style: TextStyle(
//              fontSize: 12.0,
//              color: Colors.black54,
//            ),
//          ),
//          Material(
//            borderRadius: isMe
//                ? BorderRadius.only(
//                    topLeft: Radius.circular(30.0),
//                    bottomLeft: Radius.circular(30.0),
//                    bottomRight: Radius.circular(30.0))
//                : BorderRadius.only(
//                    bottomLeft: Radius.circular(30.0),
//                    bottomRight: Radius.circular(30.0),
//                    topRight: Radius.circular(30.0),
//                  ),
//            elevation: 5.0,
//            color: isMe ? Colors.lightBlueAccent : Colors.white,
//            child: Padding(
//              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//              child: Text(
//                text,
//                style: TextStyle(
//                  color: isMe ? Colors.white : Colors.black54,
//                  fontSize: 15.0,
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
