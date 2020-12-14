import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final message;
  final bool isMe;
  final userName;
  final String userImage;
  final Key key;
  MessageBubble(this.message, this.isMe, this.userName, this.userImage, {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey[300] : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 9),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(userName, style: TextStyle(color: isMe ? Colors.black : Theme.of(context).accentColor, fontWeight: FontWeight.bold),),
                  Text(message, style: TextStyle(color: isMe ? Colors.black : Theme.of(context).accentColor),),
                ],
              ),
            ),
          ],
        ),

        Positioned(
          left: isMe ? null : 140,
          right: isMe ? 140 : null,
          child: CircleAvatar(
            radius: 23,
            backgroundImage: NetworkImage(userImage),
          ),
        ),
      ],

      overflow: Overflow.visible,
    );
  }
}
