import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/models/chatuser.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 248, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: InkWell(
          onTap: () {},
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  width: 35,
                  height: 35,
                  imageUrl: widget.user.image,
                  errorWidget: (context, url, error) => const CircleAvatar(
                    child: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Text(
                    "Last seen 12:00pm",
                    style: TextStyle(fontSize: 13, color: Colors.black45),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom -
                kBottomNavigationBarHeight,
            child: StreamBuilder(
              stream: APIs.getAllMessages(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data!.docs;
                    print("Data: ${jsonEncode(data[0].data())}");
                    _list.clear();

                    _list.add(Message(msg: "Hii", toId: "xyz", read: "", type: Type.text, send: "12:00pm", fromId: APIs.user.uid));
                    _list.add(Message(msg: "Hello", toId: APIs.user.uid, read: "", type: Type.text, send: "12:05pm", fromId: 'xyz'));
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(
                            decelerationRate: ScrollDecelerationRate.normal),
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return MessageCard(message: _list[index]);
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("Connection lost"),
                      );
                    }
                }
              },
            ),
          ),
          chatInput()
        ],
      ),
    );
  }

  Widget chatInput() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions_outlined),
                  ),
                  const Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 2,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          hintText: "Type Something...",
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.gallery),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 5,
            shape: const CircleBorder(),
            color: const Color.fromARGB(255, 189, 152, 252),
            onPressed: () {},
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
