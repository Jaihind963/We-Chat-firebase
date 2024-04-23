import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat/firebase_options.dart';
import 'package:we_chat/screens/splash_screen.dart';

void main() async{

WidgetsFlutterBinding.ensureInitialized();
// enter full screen
SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
// for setting oriented only portrait mode
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((value) async {
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
});

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'We Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme:const AppBarTheme(
          elevation: 02,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 19,fontWeight: FontWeight.normal,color: Colors.black)
        )
      ),
      home:const SplashScreen(),
    );
  }
}

