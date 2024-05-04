import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.toId
        ? blueMessage()
        : greenMessage();
  }

  Widget blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 221, 245, 255),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            border: Border.all(color: Colors.lightBlue),
          ),
          child: Text(
            widget.message.msg,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(widget.message.send),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.done_all_outlined,color: Colors.blue,),
            ),
          ],
        )
      ],
    );
  }

  Widget greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.done_all_outlined,color: Colors.blue,),
            ),
            Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(widget.message.send),
          ),],
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 225, 176),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
              border: Border.all(color: Colors.lightGreen),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
