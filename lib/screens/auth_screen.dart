import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading= false;

  Future<void> _submitFormData(String email, String username, String password, File image, bool isLogin, BuildContext context) async{
    try{
      setState(() {
        isLoading= true;
      });
      final auth= FirebaseAuth.instance;
      UserCredential authResult;
      if(isLogin){
        authResult= await auth.signInWithEmailAndPassword(email: email, password: password);
      }
      else{
        authResult= await auth.createUserWithEmailAndPassword(email: email, password: password);

        final ref= FirebaseStorage.instance.ref().child("user_image").child(authResult.user.uid + ".jpg");
        await ref.putFile(image);
        final url= await ref.getDownloadURL();

        FirebaseFirestore.instance.collection("users").doc(authResult.user.uid).set({
          "username": username,
          "email": email,
          "image_url": url,
        });
      }
    } on PlatformException catch(error){
      String message= "an error occurred! please check your credentials";
      if(error.message!= null){
        message= error.message;
      }

      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 3),
      ));

      setState(() {
        isLoading= false;
      });
    }catch(error){
      print(error);
      setState(() {
        isLoading= false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      body: AuthForm(_submitFormData, isLoading),
    );
  }
}