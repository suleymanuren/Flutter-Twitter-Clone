import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_twitter_clone_firebase/Models/Tweet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_twitter_clone_firebase/Constants/Constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  FirebaseAuth auth = FirebaseAuth.instance;

    final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> uploadProfilePicture(String url, File imageFile) async {
    String? uniquePhotoId = Uuid().v4();
    File? image = await compressImage(uniquePhotoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'userProfile_(.*).jpg');
      uniquePhotoId = exp.firstMatch(url)![1];
    }
    UploadTask uploadTask = storageRef
        .child('images/users/userProfile_$uniquePhotoId.jpg')
        .putFile(image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadCoverPicture(String url, File imageFile) async {
    String? uniquePhotoId = Uuid().v4();
    File? image = await compressImage(uniquePhotoId, imageFile);

    if (url.isNotEmpty) {
      RegExp exp = RegExp(r'userCover_(.*).jpg');
      uniquePhotoId = exp.firstMatch(url)![1];
    }
    UploadTask uploadTask = storageRef
        .child('images/users/userCover_$uniquePhotoId.jpg')
        .putFile(image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage
    
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if(isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(
      file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  static Future<String> uploadTweetPicture(File imageFile) async {
    String uniquePhotoId = Uuid().v4();
    File? image = await compressImage(uniquePhotoId, imageFile);

    UploadTask uploadTask = storageRef
        .child('images/tweets/tweet_$uniquePhotoId.jpg')
        .putFile(image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
   final ImagePicker _picker = ImagePicker();

Future<File?> takePhoto(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);                  
    
    final File? file = File(image!.path);
    return file;
  }
  static Future<File?> compressImage(String photoId, File image) async {
    final tempDirection = await getTemporaryDirectory();
    final path = tempDirection.path;
    File? compressedImage = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,
      '$path/img_$photoId.jpg',
      quality: 70,
    );
    return compressedImage;
  }

}

