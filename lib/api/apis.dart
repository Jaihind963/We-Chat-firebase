import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chatuser.dart';

class APIs {
  //for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

//for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

// for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

//to return current user
  static User get user => auth.currentUser!;

//for storing self information
  static late ChatUser me;

// for checking user is exist or not
  static Future<bool> userExist() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  //for getting current user info
  static Future<void> getSelfIntro() async {
    await firestore.collection("users").doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        print("Data: ${user.data()}");
      } else {
        await createUser().then((value) => getAllUsers());
      }
    });
  }

//for creating the new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "hey am using WhatApp",
        createdAt: time.toString(),
        isOnline: false,
        lastActive: time.toString(),
        id: user.uid,
        pushToken: "",
        email: user.email.toString());
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

//for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection("users")
        .doc(user.uid)
        .update({"name": me.name, "about": me.about});
  }

//update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extention
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child("profile_pictures/${user.uid}.$ext");

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data Transfred: ${p0.bytesTransferred / 1000} kb ');
    });
    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection("users")
        .doc(user.uid)
        .update({"image": me.image});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages() {
    return firestore.collection("messages").snapshots();
  }
}
