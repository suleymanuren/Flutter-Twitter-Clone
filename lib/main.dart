import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone_firebase/Screens/HomeScreen.dart';
import 'package:flutter_twitter_clone_firebase/Screens/WelcomeScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp();

    
  } else {
    await Firebase.initializeApp();
  }
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  Widget getScreenId() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen(currentUserId: snapshot.data.toString());
          } else {
            return WelcomeScreen();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        home: getScreenId(),
      );
    
  }
}
