import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  var username, useremail, userphoto, receiverid;
  ProfilePage({this.username, this.useremail, this.userphoto, this.receiverid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _useremail, _username, _userphoto, _googleid;
  var senderid;
  var receiverid;

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      senderid = pref.getString("senderid");
      _username = pref.getString("username");
      _useremail = pref.getString("useremail");
      _userphoto = pref.getString("userphoto");
      _googleid = pref.getString("googleid");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 00,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Profile Page',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.userphoto),
          )
        ],
      )),
    ));
  }
}
