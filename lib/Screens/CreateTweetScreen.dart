import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_twitter_clone_firebase/Constants/Constants.dart';
import 'package:flutter_twitter_clone_firebase/Models/Tweet.dart';
import 'package:flutter_twitter_clone_firebase/Services/DatabaseServices.dart';
import 'package:flutter_twitter_clone_firebase/Services/StorageService.dart';
import 'package:flutter_twitter_clone_firebase/Widgets/RoundedButton.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as Io;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CreateTweetScreen extends StatefulWidget {
  final String currentUserId;

  const CreateTweetScreen({Key? key, required this.currentUserId})
      : super(key: key);
  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  String _tweetText='';
  File? _pickedImage;
  bool _loading = false;
  String? id;
  String userName='Süleyman Üren';
  Uint8List? _file;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
  String? image;

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
FirebaseAuth auth = FirebaseAuth.instance;

  Future uploadFile() async {
    if (_photo == null) 
    return;
    final fileName = (_photo!.path);
    final destination = 'files/$fileName';

    
    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child('feedPhotos/');
            UploadTask uploadTask = ref.child("product_$id.jpg").putFile(_photo!);
String tempPhotoUrl = await (await uploadTask).ref.getDownloadURL();
    setState(() {
      print("@@@@@@@@@@@@@@@$tempPhotoUrl");
      auth.currentUser!.updatePhotoURL(tempPhotoUrl);

      image = tempPhotoUrl;
                                        DateTime postID = DateTime.now();
                    Tweet tweet = Tweet(
                      id: id,
                      text: _tweetText,
                      image:tempPhotoUrl,
                      userName: 'Süleyman Üren',
                      authorId: postID.toString(),
                      likes: 0,
                      retweets: 0,
                      timestamp: Timestamp.fromDate(
                        DateTime.now(),
                      ),
                    );
                    DatabaseServices.createTweet(tweet);
                    Navigator.pop(context);
    });
      await ref.putFile(_photo!);
                  return tempPhotoUrl;

    } catch (e) {
      print('error occured');
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Gönderi Oluştur'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Fotoğraf Çek'),
                onPressed: () async {
                  Navigator.pop(context);
                  File? file = await pickImage(ImageSource.camera);
                  setState(() {
                    _pickedImage = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Galeriden Seç'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _pickedImage = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  handleImageFromGallery() async {
    try {
      final ImagePicker _imagePicker = ImagePicker();
      Uint8List file = await pickImage(ImageSource.gallery);

      XFile? imageFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _pickedImage = imageFile as File?;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  
  Widget build(BuildContext parentContext) {
    context:
    parentContext;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: KTweeterColor,
        centerTitle: true,
        title: Text(
          'Gönderi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                maxLength: 280,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'Enter your Tweet',
                ),
                onChanged: (value) {
                  _tweetText = value;
                },
              ),
              SizedBox(height: 10),
              _pickedImage == null
                  ? SizedBox.shrink()
                  : Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                              color: KTweeterColor,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_pickedImage!),
                              )),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: _photo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _photo!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50)),
                          width: 200,
                          height: 200,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              RoundedButton(
                btnText: 'Paylaş',
                onBtnPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  if (_tweetText != '' || _tweetText.isEmpty) {
                    String image;

                    if (_photo == null) {
                      setState(() {});
                                               DateTime postID = DateTime.now();
                    Tweet tweet = Tweet(
                      id: id,
                      text: _tweetText,
                      image: "null",
                      userName: "Suleyman",
                      authorId: postID.toString(),
                      likes: 0,
                      retweets: 0,
                      timestamp: Timestamp.fromDate(
                        DateTime.now(),
                      ),
                    );
                    DatabaseServices.createTweet(tweet);
                    Navigator.pop(context);
                    } else {
                                  uploadFile();
                    }
        
                  }
                  setState(() {
                    _loading = false;
                  });
                },
              ),
              SizedBox(height: 20),
              _loading ? CircularProgressIndicator() : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
