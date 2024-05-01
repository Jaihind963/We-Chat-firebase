import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:we_chat/models/chatuser.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserCard extends StatefulWidget {
  final ChatUser user;
  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin:const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            width: 50,
            height: 50,
            imageUrl: widget.user.image,
            errorWidget: (context, url, error) =>const CircleAvatar(
              child: Icon(Iconsax.user),
            ),
          ),
        ),
        title: Text(widget.user.name),
        subtitle: Text(widget.user.about),
        trailing: Text(
          "12:00 pm",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
