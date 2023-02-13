import 'dart:io';

import 'package:chat1/loginhome.dart';
import 'package:chat1/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginwithgoogle extends StatefulWidget {
  @override
  State<Loginwithgoogle> createState() => _LoginwithgoogleState();
}

class _LoginwithgoogleState extends State<Loginwithgoogle> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void initState() {
    // _googleSignIn.signOut();
    // TODO: implement initState
    super.initState();

    checklogin();
  }

  checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("useremail")) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Loginhome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/hp.jpg'), fit: BoxFit.cover)),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome To Quick Chats.",
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "You Can Chat With Anyone Here.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "You Just Need A Google Account To Start Chatting.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "To Start Chatting Click On The Google Logo.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            GoogleSignInAccount? googleSignInAccount =
                                await _googleSignIn.signIn();
                            GoogleSignInAuthentication
                                googleSignInAuthentication =
                                await googleSignInAccount!.authentication;
                            AuthCredential credential =
                                GoogleAuthProvider.credential(
                              accessToken:
                                  googleSignInAuthentication.accessToken,
                              idToken: googleSignInAuthentication.idToken,
                            );
                            UserCredential authResult =
                                await _auth.signInWithCredential(credential);
                            User? _user = authResult.user;

                            var username = _user?.displayName.toString();
                            var useremail = _user?.email.toString();
                            var userphoto = _user?.photoURL.toString();
                            var googleid = _user?.uid.toString();
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setString("username", username!);
                            pref.setString("useremail", useremail!);
                            pref.setString("userphoto", userphoto!);
                            pref.setString("googleid", googleid!);
                            print("username:" + username);
                            print("userid:" + useremail);
                            print("userphoto:" + userphoto);
                            print("googleid:" + googleid);
                            await FirebaseFirestore.instance
                                .collection("user")
                                .where("useremail", isEqualTo: useremail)
                                .get()
                                .then((data) async {
                              if (data.size <= 0) {
                                await FirebaseFirestore.instance
                                    .collection("user")
                                    .add({
                                  "username": username,
                                  "useremail": useremail,
                                  "userphoto": userphoto,
                                  "googleid": googleid,
                                }).then((value) {
                                  pref.setString(
                                      "senderid", value.id.toString());
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Loginhome()));
                                });
                              } else {
                                pref.setString(
                                    "senderid", data.docs.first.id.toString());
                                print("data already present");
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Loginhome()));
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(color: Colors.white24)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/gl2.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/gl1.png',
                                      height: 50,
                                      width: 120,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
