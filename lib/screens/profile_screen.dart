import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/auth/login_screen.dart';
import 'package:we_chat/helper/show_dialog.dart';
import 'package:we_chat/models/chatuser.dart';
import 'package:we_chat/screens/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 10,
                ),
                SizedBox(height: 5),
           _image != null?     ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                   
                   File(_image!),
                   width:100,
                   height: 100,
                   fit: BoxFit.cover,
              
                  ),
                ):ClipRRect(
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
                IconButton(
                  onPressed: () {
                    showBottomBar();
                  },
                  icon: Icon(Iconsax.user_edit),
                ),
                SizedBox(height: 25),
                Text("Email: ${widget.user.email}"),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onSaved: (value) => APIs.me.name = value ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the name";
                      } else {
                        return null;
                      }
                    },
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                      // focusedErrorBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(20)
                      // ),
                      prefixIcon: Icon(Iconsax.user),
                      hintText: "eg. Sabavat Jaihind",
                      labelText: "Name",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    onSaved: (value) => APIs.me.about = value ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required field";
                      } else {
                        return null;
                      }
                    },
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.info_circle),
                      hintText: "eg. hey, Iam using we chat!",
                      labelText: "About",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 205, 181, 246),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      APIs.updateUserInfo()
                          .then((value) =>
                              Dialogs.showSnackbar(context, "Updated"))
                          .then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ));
                      }).onError((error, stackTrace) {
                        Dialogs.showSnackbar(context, error.toString());
                      });
                    }
                  },
                  label: Text(
                    "Update",
                    style: TextStyle(color: Colors.black87),
                  ),
                  icon: Icon(
                    Iconsax.edit,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showBottomBar() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView(
          padding: EdgeInsets.only(top: 20, bottom: 100),
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "Pick Profile Picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               
                ElevatedButton.icon(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      // Pick an image.
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);

                          if(image!= null){
                            setState(() {
                              _image = image.path;
                            });
                          }
                          Navigator.pop(context);
                    },
                    icon: Image.asset(
                      "assets/images/add_image.png",
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                    label: Text("Photo"),),
                    ElevatedButton.icon(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    // Capture a photo.
                    final XFile? photo =
                        await picker.pickImage(source: ImageSource.camera);

if (photo != null){
  setState(() {
    _image = photo.path;
  });
}
Navigator.pop(context);
                  },
                  icon: Image.asset(
                    "assets/images/camera.png",
                    height: 50,
                    width: 50,
                    fit: BoxFit.fill,
                  ),
                  label: Text("Camera"),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
