import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone_firebase/Constants/Constants.dart';
import 'package:flutter_twitter_clone_firebase/Models/Tweet.dart';
import 'package:flutter_twitter_clone_firebase/Models/UserModel.dart';
import 'package:flutter_twitter_clone_firebase/Screens/CreateTweetScreen.dart';
import 'package:flutter_twitter_clone_firebase/Services/DatabaseServices.dart';
import 'package:flutter_twitter_clone_firebase/Widgets/TweetContainer.dart';
import 'package:flutter_twitter_clone_firebase/Widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_twitter_clone_firebase/models/Tweet.dart' as model;


class Deneme extends StatefulWidget {
  final String currentUserId;

  Deneme({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _DenemeState createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  @override
  final db = FirebaseFirestore.instance;

  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: db.collection('tweets').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');

                default:
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      if (document['image'] == "null") {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ).copyWith(right: 0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                        document['image']
                                            .toString() //PROFIL FOTOĞRAFI
                                        ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document['userName'].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  document['image'].toString() == 'null'
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                              useRootNavigator: false,
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: ListView(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16),
                                                      shrinkWrap: true,
                                                      children: [
                                                        'Delete',
                                                      ]
                                                          .map(
                                                            (e) => InkWell(
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          16),
                                                                  child:
                                                                      Text(e),
                                                                ),
                                                                onTap: () {
                                                                  // remove the dialog box
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }),
                                                          )
                                                          .toList()),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.more_vert),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            // IMAGE SECTION OF THE POST
                            GestureDetector(
                              onDoubleTap: () {
                               /* DatabaseServices().likePost(
                                tweet.authorId,
                                      tweet.id,
                                      document['likes']
                                );
                                setState(() {
                                  isLikeAnimating = true;
                                });*/
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        document['text'].toString(), //ANA RESİM
                                      ),
                                    ),
                                  ),
                               /*   AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: isLikeAnimating ? 1 : 0,
                                    child: LikeAnimation(
                                      isAnimating: isLikeAnimating,
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 100,
                                      ),
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      onEnd: () {
                                        setState(() {
                                          isLikeAnimating = false;
                                        });
                                      },
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
  
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DefaultTextStyle(
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontWeight: FontWeight.w800),
                                      child: Text(
                                        '${document['likes']} likes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      )),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        children: [
                                          TextSpan(
                                            text:
                                                document['userName'].toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${document['text'].toString()}',
                                                style: TextStyle(color: Colors.black)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      DateFormat.yMMMd().format(
                                          document['timestamp'].toDate()),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 16,
                              ).copyWith(right: 0),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundImage: NetworkImage(
                                        document['image']
                                            .toString() //PROFIL FOTOĞRAFI
                                        ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document['userName'].toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  document['image'].toString() == 'null'
                                      ? IconButton(
                                          onPressed: () {
                                            showDialog(
                                              useRootNavigator: false,
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: ListView(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 16),
                                                      shrinkWrap: true,
                                                      children: [
                                                        'Delete',
                                                      ]
                                                          .map(
                                                            (e) => InkWell(
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          16),
                                                                  child:
                                                                      Text(e),
                                                                ),
                                                                onTap: () {
                                                                  // remove the dialog box
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }),
                                                          )
                                                          .toList()),
                                                );
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.more_vert),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            // IMAGE SECTION OF THE POST
                            GestureDetector(
                              onDoubleTap: () {
                               /* DatabaseServices().likePost(
                                tweet.authorId,
                                      tweet.id,
                                      document['likes']
                                );
                                setState(() {
                                  isLikeAnimating = true;
                                });*/
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    width: double.infinity,
                                    child: Image.network(
                                      document['image'].toString(), //ANA RESİM
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                               /*   AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: isLikeAnimating ? 1 : 0,
                                    child: LikeAnimation(
                                      isAnimating: isLikeAnimating,
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 100,
                                      ),
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      onEnd: () {
                                        setState(() {
                                          isLikeAnimating = false;
                                        });
                                      },
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
  
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DefaultTextStyle(
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontWeight: FontWeight.w800),
                                      child: Text(
                                        '${document['likes']} likes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      )),
                           Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            const TextStyle(color: Colors.blue),
                                        children: [
                                          TextSpan(
                                            text:
                                                document['userName'].toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' ${document['text'].toString()}',
                                                style: TextStyle(color: Colors.black)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      DateFormat.yMMMd().format(
                                          document['timestamp'].toDate()),
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }
                    }).toList(),
                  );
              }
            }));
  }
}
