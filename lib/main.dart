import "package:flutter/material.dart";
import './screens/chat_screen.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final _initialization= Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, appSnapshot)=> MaterialApp(
        title: "Chap App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurpleAccent,
          accentColor: Colors.white,
          primarySwatch: Colors.deepPurple,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.deepPurpleAccent,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),

        home: appSnapshot.connectionState== ConnectionState.waiting ? SplashScreen() : StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot){
            if(authSnapshot.connectionState== ConnectionState.waiting){
              return SplashScreen();
            }

            if(!authSnapshot.hasData){
              return AuthScreen();
            }
            return ChatScreen();
          }
        ),
      ),
    );
  }
}
