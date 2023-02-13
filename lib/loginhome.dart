import 'package:chat1/MessagePage.dart';
import 'package:chat1/lotginwithgoogle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginhome extends StatefulWidget {
  @override
  State<Loginhome> createState() => _LoginhomeState();
}

class _LoginhomeState extends State<Loginhome> {
  var _useremail, _username, _userphoto, _googleid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _username = pref.getString("username");
      _useremail = pref.getString("useremail");
      _userphoto = pref.getString("userphoto");
      _googleid = pref.getString("googleid");
    });
  }

  void logout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xff131313),
        drawer: Drawer(
          backgroundColor: Color(0xff131313),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "My Profile",
                    style: TextStyle(
                        fontSize: 25, color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(_userphoto),
                radius: 60,
              ),
              SizedBox(
                height: 10,
              ),
              Divider(thickness: 1, color: Colors.white54),
              SizedBox(
                height: 20,
              ),
              Text(
                "$_username",
                style: TextStyle(
                    fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "$_useremail",
                style: TextStyle(
                    fontSize: 20, color: Colors.white70),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.only(left: 200),
                child: TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      logout();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Loginwithgoogle(),
                          ));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded,
                            color: Colors.redAccent),
                        SizedBox(width: 5),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Color(0xff131313),
          elevation: 00,
          title: Text(
            "Quick Chat",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("user")
              .where("useremail", isNotEqualTo: _useremail)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.size == 0) {
                return Center(
                  child: Text(
                    "You Don't Have Any Friends",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data!.docs.map((document) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.15)),

                        height: 80,
                        child: ListTile(
                          leading: Container(
                            height: 50.0,
                            width: 50.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(document["userphoto"]),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          title: Text(
                            document["username"],
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            document["useremail"],
                            style: TextStyle(
                                color: Color.fromARGB(255, 192, 192, 192),
                                fontSize: 14.0),
                          ),
                          onTap: () {
                            var _username = document["username"].toString();
                            var _useremail = document["useremail"].toString();
                            var _userphoto = document["userphoto"].toString();
                            // print("name"+_username);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MessagePage(
                                      username: _username,
                                      receiverid: document.id.toString(),
                                      useremail: _useremail,
                                      userphoto: _userphoto,
                                    )));
                          },
                          // trailing:Divider(),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
