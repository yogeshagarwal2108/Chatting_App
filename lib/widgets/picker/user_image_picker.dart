import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImageFile) pickedImageFun;
  UserImagePicker(this.pickedImageFun);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File image;

  _pickImage() async{
    final picker= ImagePicker();
    final pickedImage= await picker.getImage(source: ImageSource.camera, imageQuality: 60, maxWidth: 150, maxHeight: 150);
    final pickedImageFile= File(pickedImage.path);
    setState(() {
      image= pickedImageFile;
    });
    widget.pickedImageFun(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 40,
          backgroundImage: image!= null ? FileImage(image) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          textColor: Theme.of(context).primaryColor,
          label: Text("pick image"),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
