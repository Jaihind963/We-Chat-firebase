import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:we_chat/auth/login_screen.dart';
import 'package:we_chat/models/chatuser.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile Screen"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          GoogleSignIn().signOut();
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        },
        label: const Text("Logout"),
        icon: const Icon(Iconsax.logout),
      ),
      body: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            height: 10,
          ),
          SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              width: 100,
              height: 100,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(Iconsax.user),
              ),
            ),
          ),
                    IconButton(onPressed: (){}, icon: Icon(Iconsax.user_edit),),

          
          SizedBox(height: 25),
          Text("Email: ${widget.user.email}"),
          SizedBox(height: 25),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              initialValue: widget.user.name,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.user),
                hintText: "eg. Sabavat Jaihind",
                labelText: "Name",
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          SizedBox(height: 25),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              
              initialValue: widget.user.about,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.info_circle),
                
                hintText: "eg. hey, Iam using we chat!",
                labelText: "About",
                enabledBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          SizedBox(height: 25),
          ElevatedButton.icon(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 225, 210, 251))),
            onPressed: (){}, label: Text("Update",style: TextStyle(color: Colors.black87),),icon: Icon(
            Iconsax.edit,color: Colors.black87,),)
        ],
      ),
    );
  }
}
