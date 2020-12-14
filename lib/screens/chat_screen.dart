import "package:flutter/material.dart";
import '../widgets/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chat/new_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    final fbm= FirebaseMessaging();
    fbm.configure(
      onMessage: (msg){     ////when app is in foreground
        print(msg);
        return;
      },
      onLaunch: (msg){             ////when app is closed/terminated
        print(msg);
        return;
      },
      onResume: (msg){            /////when app is in background
        print(msg);
        return;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Chat"),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            icon: Icon(Icons.more_vert, color: Theme.of(context).primaryIconTheme.color,),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 5,),
                      Text("Logout"),
                    ],
                  ),
                ),
                value: "logout",
              ),
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier== "logout"){
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages()
            ),
            NewMessages(),
          ],
        ),
      ),
    );
  }
}