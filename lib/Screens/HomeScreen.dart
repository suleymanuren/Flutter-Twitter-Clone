import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone_firebase/Constants/Constants.dart';
import 'package:flutter_twitter_clone_firebase/Models/Tweet.dart';
import 'package:flutter_twitter_clone_firebase/Models/UserModel.dart';
import 'package:flutter_twitter_clone_firebase/Screens/CreateTweetScreen.dart';
import 'package:flutter_twitter_clone_firebase/Services/DatabaseServices.dart';
import 'package:flutter_twitter_clone_firebase/Widgets/TweetContainer.dart';

import '../Widgets/PostCard.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;

  HomeScreen({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _followingTweets = [];
  bool _loading = false;





  setupFollowingTweets() async {
    setState(() {
      _loading = true;
    });
    List followingTweets =
        await DatabaseServices.getHomeTweets(widget.currentUserId);
    if (mounted) {
      setState(() {
        _followingTweets = followingTweets;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupFollowingTweets();
  }

  @override
  final db = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Image.asset('assets/tweet.png'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateTweetScreen(
                          currentUserId: widget.currentUserId,
                        )));
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
            child: Image.asset('assets/logo.png'),
          ),
          title: Text(
            'Home Screen',
            style: TextStyle(
              color: KTweeterColor,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => setupFollowingTweets(),
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection('tweets').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');

                  default:
                    return Deneme(currentUserId: 'pO2RcHb1AFXnaO4sQ61B7fiHANi1',);
                }
              }),
        ));
  }
}
