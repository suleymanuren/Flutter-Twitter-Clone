import 'package:cloud_firestore/cloud_firestore.dart';

class Tweet {
  String? id;
  String authorId;
  String? text;
  String? image;
  Timestamp timestamp;
  int likes;
  int retweets;
  String userName;

  Tweet(
      {this.id,
      required this.authorId,
      required this.text,
       this.image,
      required this.userName,
      required this.timestamp,
      required this.likes,
      required this.retweets});

  factory Tweet.fromDoc(DocumentSnapshot doc) {
    return Tweet(
      id: doc.id,
      authorId: doc['authorId'],
      text: doc['text'],
      image: doc['image'],
      userName: doc['userName'],
      timestamp: doc['timestamp'],
      likes: doc['likes'],
      retweets: doc['retweets'],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": text,
        "uid": id,
        "likes": likes,
        "postId": timestamp,
        "datePublished": timestamp,
        'profImage': image,
        'userName': userName
      };
}
