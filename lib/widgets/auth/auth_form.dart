import 'package:flutter/material.dart';
import '../picker/user_image_picker.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  final Function(String email, String username, String password, File image, bool isLogin, BuildContext context) submitFormData;
  final isLoading;
  AuthForm(this.submitFormData, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  GlobalKey<FormState> _formKey= GlobalKey<FormState>();
  String email= "";
  String username= "";
  String password= "";
  bool isLogin= true;
  File pickedImageFile;

  void pickedImage(File image) {
    pickedImageFile= image;
  }

  _saveForm(){
    if(_formKey.currentState.validate()){
      FocusScope.of(context).unfocus();              //////to remove keyboard from current screen

      if(pickedImageFile== null && !isLogin){
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Please pick an image"),
            backgroundColor: Theme.of(context).errorColor,
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      _formKey.currentState.save();
      widget.submitFormData(email.trim(), username.trim(), password.trim(), pickedImageFile, isLogin ,context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 7,
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if(!isLogin)
                    UserImagePicker(pickedImage),
                  TextFormField(
                      key: ValueKey("email"),
                      autocorrect: false,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Email",
                        icon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please provide email";
                        }
                        else if(!value.contains("@")){
                          return "invalid email";
                        }
                        return null;
                      },
                      onSaved: (value){
                        email= value;
                      }
                  ),
                  if(!isLogin)
                    TextFormField(
                        key: ValueKey("username"),
                        autocorrect: true,
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: "Username",
                          icon: Icon(Icons.person),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value){
                          if(value.isEmpty){
                            return "Please provide username";
                          }
                          else if(value.length< 4){
                            return "please enter at least 4 characters";
                          }
                          return null;
                        },
                        onSaved: (value){
                          username= value;
                        }
                    ),
                  TextFormField(
                      key: ValueKey("password"),
                      decoration: InputDecoration(
                        labelText: "Password",
                        icon: Icon(Icons.straighten),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please provide password";
                        }
                        else if(value.length<6){
                          return "password length should be at least 6 chars long";
                        }
                        return null;
                      },
                      onSaved: (value){
                        password= value;
                      }
                  ),

                  SizedBox(height: 15,),
                  if(widget.isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  if(widget.isLoading== false)
                    RaisedButton(
                      child: Text(isLogin ? "Login" : "Sign up"),
                      elevation: 5,
                      onPressed: _saveForm,
                    ),

                  SizedBox(height: 5,),
                  if(widget.isLoading== false)
                    FlatButton(
                      child: Text(isLogin ? "create new account" : "already have an account"),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: (){
                        setState(() {
                          isLogin= !isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}