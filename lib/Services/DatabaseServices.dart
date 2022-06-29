import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_twitter_clone_firebase/Constants/Constants.dart';
import 'package:flutter_twitter_clone_firebase/Models/Tweet.dart';
import 'package:flutter_twitter_clone_firebase/Models/UserModel.dart';
import 'package:flutter_twitter_clone_firebase/models/Tweet.dart' as model;

import 'StorageService.dart';

class DatabaseServices {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

   static Future<void> createTweet(Tweet tweet) async {

    tweetsRef.doc(tweet.authorId).set({'tweetTime': tweet.timestamp});
    _fireStore.collection('tweets').doc(tweet.authorId).set({
      'text': tweet.text,
      'image': tweet.image,
      'userName': tweet.userName,
      "authorId": tweet.authorId,
      "timestamp": tweet.timestamp,
      'likes': tweet.likes,
      'retweets': tweet.retweets,
    });
  

  }
 




  Future<String> likePost(String authorId, String? id, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(id)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('tweets').doc(authorId).update({
          'likes': FieldValue.arrayRemove([id])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('tweets').doc(authorId).update({
          'likes': FieldValue.arrayUnion([id])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }







 


  static Future<List> getHomeTweets(String currentUserId) async {
    QuerySnapshot homeTweets = await feedRefs
        .doc(currentUserId)
        .collection('userFeed')
        .orderBy('timestamp', descending: true)
        .get();

    List<Tweet> followingTweets =
        homeTweets.docs.map((doc) => Tweet.fromDoc(doc)).toList();
    return followingTweets;
  }



}
