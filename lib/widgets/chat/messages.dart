import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {

  final user= FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chat").orderBy("createdAt", descending: true).snapshots(),
      builder: (context,chatSnapshot){
        if(chatSnapshot.connectionState== ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }

        final chatDocument= chatSnapshot.data.docs;
        return  ListView.builder(
          reverse: true,
          itemCount: chatDocument.length,
          itemBuilder: (context, i)=> MessageBubble(
            chatDocument[i].data()["text"],
            chatDocument[i].data()["userId"]== user.uid,
            chatDocument[i].data()["username"],
            chatDocument[i].data()["userImage"],
            key: ValueKey(chatDocument[i].id),
          ),
        );
      }
    );
  }
}
