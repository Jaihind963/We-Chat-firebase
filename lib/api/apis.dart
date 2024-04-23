import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat/models/chatuser.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static late ChatUser me;

  static Future<bool> userExist() async {
    return (await firestore
            .collection("users")
            .doc(user.uid)
            .get())
        .exists;
  }
  static Future <void> getSelfIntro()async{
await firestore.collection("users").doc(user.uid).get().then((user) async {
if(user.exists){
me = ChatUser.fromJson(user.data()!);
print("Data: ${user.data()}");
}else{
await  createUser().then((value) => getAllUsers());
}
});
  }

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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection("users").where('id', isNotEqualTo: user.uid).snapshots();
  }
}
