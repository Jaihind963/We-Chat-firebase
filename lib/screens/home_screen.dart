import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/models/chatuser.dart';
import 'package:we_chat/screens/profile_screen.dart';
import 'package:we_chat/widgets/usercard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> searchList = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfIntro();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: !isSearching,
        onPopInvoked: (_)async {
          if(isSearching){
            setState(() {
              isSearching =!isSearching;
            });
           
          }else{
           Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 02,
            leading:
                IconButton(onPressed: () {}, icon: const Icon(Iconsax.home_2)),
            title: isSearching
                ? TextField(
                    autofocus: true,
                    style: const TextStyle(letterSpacing: 0.5),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                    if (value.isEmpty){
                      setState(() {
                        searchList.clear();
                      });
                    }else{
                      searchList.clear();
                      for (var i in list) {
        
                        if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                            i.email.toLowerCase().contains(value.toLowerCase())) {
                              searchList.add(i);
                          
                        }
                      }
                      setState(() {
                            searchList;
                            
                          });
                    }
                    },
                  )
                : const Text(
                    "We Chat",
                  ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;

                    if(!isSearching){
                      searchList.clear();
                    }
                  });
                },
                icon: Icon(
                    isSearching ? Iconsax.close_square : Iconsax.search_normal),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        user: APIs.me,
                      ),
                    ),
                  );
                },
                icon: const Icon(Iconsax.more),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Iconsax.add),
          ),
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
        
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data!.docs;
                  list =
                      data.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                          decelerationRate: ScrollDecelerationRate.normal),
                      itemCount: isSearching ? searchList.length : list.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                            user: isSearching ? searchList[index] : list[index]);
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
      ),
    );
  }
}
