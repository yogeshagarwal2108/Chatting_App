import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String newMessage= "";
  final _messageController= new TextEditingController();

  _sendMessage() async{
    FocusScope.of(context).unfocus();
    final user= FirebaseAuth.instance.currentUser;
    final userData= await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": newMessage,
      "createdAt": Timestamp.now(),
      "userId": user.uid,
      "username": userData.data()["username"],
      "userImage": userData.data()["image_url"],
    });
    _messageController.clear();
    setState(() {
      newMessage= "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child:Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: "Send a message...",
              ),
              controller: _messageController,
              onChanged: (value){
                setState(() {
                  newMessage= value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: newMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
