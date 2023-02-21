import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat1/addvideo.dart';
import 'package:chat1/allConstants/livelocation.dart';
import 'package:chat1/screens/profilepage.dart';
import 'package:chat1/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import 'allConstants/showloc.dart';

class MessagePage extends StatefulWidget {
  var username, useremail, userphoto, receiverid;

  MessagePage({this.username, this.useremail, this.userphoto, this.receiverid});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _chat = TextEditingController();

  File? imagefile;
  File? pdffile;
  late Iterable<Contact> _contacts;
  ImagePicker _picker = ImagePicker();
  var senderid;
  var receiverid;
  String? date;
  int? diff;
  bool emojiShowing = false;
  File? file;
  Timer? timer;

  // int formattedTime =(DateFormat.Hm().format(DateTime.now()));

  ScrollController _scrollController = ScrollController();
  var _useremail, _username, _userphoto, _googleid;

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      senderid = pref.getString("senderid");
      receiverid = widget.receiverid;
      _username = pref.getString("username");
      _useremail = pref.getString("useremail");
      _userphoto = pref.getString("userphoto");
      _googleid = pref.getString("googleid");
    });
  }

  _onEmojiSelected(Emoji emoji) {
    _chat
      ..text += emoji.emoji
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: _chat.text.length));
  }

  _onBackspacePressed() {
    _chat
      ..text = _chat.text.characters.skipLast(1).toString()
      ..selection =
          TextSelection.fromPosition(TextPosition(offset: _chat.text.length));
  }

  showFilePicker(FileType fileType) async {
    FilePickerResult? imagefile =
        await FilePicker.platform.pickFiles(type: fileType);

    if (imagefile != null) {
      video();
    } else {
      print("object");
    }
  }

  upload() async {
    DateTime date = DateTime.now();
    print(date);
    String formattedDate = DateFormat('dd-MM-yy').format(date);
    String formattedDate1 = DateFormat().add_jm().format(DateTime.now());
    print(formattedDate1);
    var uuid = Uuid();
    var filename = uuid.v4().toString() + ".jpg";
    print("file:" + filename);
    EasyLoading.show(status: 'Uploading Image ...');
    await FirebaseStorage.instance
        .ref(filename)
        .putFile(imagefile!)
        .whenComplete(() {})
        .then((filedata) async {
      filedata.ref.getDownloadURL().then((fileurl) async {
        // print("url:"+fileurl.toString());
        await FirebaseFirestore.instance
            .collection("user")
            .doc(senderid)
            .collection("chat")
            .doc(receiverid)
            .collection("message")
            .add({
          "senderid": senderid,
          "receiverid": receiverid,
          "massages": fileurl,
          "type": "image",
          "date": formattedDate.toString(),
          "time": date.toString(), "timestrap": formattedDate1.toString(),

          // "timestamp": formattedDate1.toString(),
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(receiverid)
              .collection("chat")
              .doc(senderid)
              .collection("message")
              .add({
            "senderid": senderid,
            "receiverid": receiverid,
            "massages": fileurl,
            "type": "image",
            "date": formattedDate.toString(),
            "time": date.toString(), "timestrap": formattedDate1.toString(),

            // "timestamp": formattedDate1.toString(),
          }).then((value) {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut);
            EasyLoading.showSuccess(' Upload Success!');
          });
        });
      });
    });
  }

  uploadpdf() async {
    DateTime date = DateTime.now();
    print(date);
    String formattedDate = DateFormat('dd-MM-yy').format(date);
    String formattedDate1 = DateFormat().add_jm().format(DateTime.now());
    print(formattedDate1);
    var uuid = Uuid();
    var filename = uuid.v4().toString() + ".pdf";
    print("file:" + filename);
    EasyLoading.show(status: 'Uploading Pdf ...');
    await FirebaseStorage.instance
        .ref(filename)
        .putFile(pdffile!)
        .whenComplete(() {})
        .then((filedata) async {
      filedata.ref.getDownloadURL().then((fileurl) async {
        // print("url:"+fileurl.toString());
        await FirebaseFirestore.instance
            .collection("user")
            .doc(senderid)
            .collection("chat")
            .doc(receiverid)
            .collection("message")
            .add({
          "senderid": senderid,
          "receiverid": receiverid,
          "massages": fileurl,
          "type": "pdf",
          "date": formattedDate.toString(),
          "time": date.toString(), "timestrap": formattedDate1.toString(),

          // "timestamp": formattedDate1.toString(),
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(receiverid)
              .collection("chat")
              .doc(senderid)
              .collection("message")
              .add({
            "senderid": senderid,
            "receiverid": receiverid,
            "massages": fileurl,
            "type": "pdf",
            "date": formattedDate.toString(),
            "time": date.toString(), "timestrap": formattedDate1.toString(),

            // "timestamp": formattedDate1.toString(),
          }).then((value) {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut);
            EasyLoading.showSuccess(' Upload Success!');
          });
        });
      });
    });
  }

  video() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yy').format(now);
    String formattedDate1 = DateFormat().add_jm().format(DateTime.now());
    var uuid = Uuid();
    var filename = uuid.v4().toString() + ".mp4";
    EasyLoading.show(status: 'Uploading Video...');
    await FirebaseStorage.instance
        .ref(filename)
        .putFile(imagefile!)
        .whenComplete(() {})
        .then((filedata) async {
      filedata.ref.getDownloadURL().then((fileurl) async {
        print("url:" + fileurl.toString());
        await FirebaseFirestore.instance
            .collection("user")
            .doc(senderid)
            .collection("chat")
            .doc(receiverid)
            .collection("message")
            .add({
          "senderid": senderid,
          "receiverid": receiverid,
          "massages": fileurl,
          "type": "video",
          "date": formattedDate.toString(),
          "time": now.toString(),
          "timestrap": formattedDate1.toString(),
          // "timestamp": formattedDate1.toString(),
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(receiverid)
              .collection("chat")
              .doc(senderid)
              .collection("message")
              .add({
            "senderid": senderid,
            "receiverid": receiverid,
            "massages": fileurl,
            "type": "video",
            "date": formattedDate.toString(),
            "time": now.toString(),
            "timestrap": formattedDate1.toString(),
            // "timestamp": formattedDate1.toString(),
          }).then((value) {
            _chat.text.toString();
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut);
            EasyLoading.showSuccess(' Upload Success!');
          });
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getdata();
    setState(() {});
    configLoading();
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff131313),
        endDrawer: Drawer(
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
                    "Profile",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(widget.userphoto),
                radius: 60,
              ),
              SizedBox(
                height: 20,
              ),
              Divider(thickness: 1, color: Colors.white54),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.username,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.useremail,
                style: TextStyle(fontSize: 20, color: Colors.white60),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 60,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 00,
          backgroundColor: Colors.white.withOpacity(0.15),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          titleSpacing: 0,
          title: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(0.0),
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 245, 245, 245),
                    shape: BoxShape.circle),
                child: ClipOval(
                  child: Image.network(
                    widget.userphoto,
                    height: 45.0,
                    width: 45.0,
                  ),
                ),
              ),
              SizedBox(
                width: 50.0,
              ),
              Text(
                widget.username,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("user")
                        .doc(senderid)
                        .collection("chat")
                        .doc(receiverid)
                        .collection("message")
                        .orderBy(
                          "time",
                          descending: true,
                        )
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.size <= 0) {
                          return Center(
                            child: Text(
                              "No Messages",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 238, 238, 238)),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ListView(
                              controller: _scrollController,
                              reverse: true,
                              // shrinkWrap: true,
                              children: snapshot.data!.docs.map((document) {
                                var value = document["senderid"].toString();
                                if (value == senderid) {
                                  return Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  // width: MediaQuery.of(context).size.width*0.70,
                                                  margin: EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 8,
                                                      right: 5,
                                                      left: 5),
                                                  padding: EdgeInsets.all(9.0),
                                                  child: (document["type"] ==
                                                          "image")
                                                      ? InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xff4d4d4d),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  content:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                    child: Image
                                                                        .network(
                                                                      document[
                                                                          "massages"],
                                                                      width:
                                                                          250.0,
                                                                      // height: 450.0,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
                                                              document[
                                                                  "massages"],
                                                              width: 250.0,
                                                              // height: 250.0,
                                                              fit: BoxFit.cover,
                                                              frameBuilder:
                                                                  (context,
                                                                      child,
                                                                      frame,
                                                                      wasSynchronouslyLoaded) {
                                                                return child;
                                                              },
                                                              loadingBuilder:
                                                                  (context,
                                                                      child,
                                                                      loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                } else {
                                                                  return Center(
                                                                    child: CircularProgressIndicator(
                                                                        color: Colors
                                                                            .black),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      : (document["type"] ==
                                                              "video")
                                                          ? Stack(
                                                              children: [
                                                                Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  height: 300,
                                                                  width: 170,
                                                                  child: addvideo(
                                                                      vid: document[
                                                                          "massages"]),
                                                                ),
                                                                Positioned(
                                                                  left: 130,
                                                                  top: 2,
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.60),
                                                                    child: PopupMenuButton(
                                                                        shape: RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              color: Colors.cyan,
                                                                              width: 3),
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(15.0),
                                                                          ),
                                                                        ),
                                                                        icon: Icon(
                                                                          Icons
                                                                              .more_vert_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        itemBuilder: (context) => [
                                                                              PopupMenuItem(
                                                                                  onTap: () {
                                                                                    print('Hellow Video');
                                                                                    _saveVideo(document["massages"], 'Billie');
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Icon(Icons.save_alt_rounded),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Text(
                                                                                        'Save Video',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      )
                                                                                    ],
                                                                                  ))
                                                                            ],
                                                                        color: Color(0xff131313)),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          // ? GestureDetector(
                                                          //     onTap: () async {
                                                          //       Navigator.of(context).push(
                                                          //           MaterialPageRoute(
                                                          //               builder:
                                                          //                   (context) =>
                                                          //                       addvideo(
                                                          //                         vid: document["massages"],
                                                          //                       )));
                                                          //     },
                                                          //     child: Container(
                                                          //         height: 19.0,
                                                          //         // padding:
                                                          //         //     EdgeInsets.all(1.0),
                                                          //         child: Text(
                                                          //           "Video",
                                                          //           style: TextStyle(
                                                          //               fontSize:
                                                          //                   15.0),
                                                          //         )),
                                                          //   )
                                                          : (document["type"] ==
                                                                  "location")
                                                              ? Container(
                                                                  height: 200,
                                                                  width: 400,
                                                                  child:
                                                                      Showloc(
                                                                    loc: widget
                                                                        .receiverid,
                                                                  ))
                                                              : Text(
                                                                  document[
                                                                      "massages"],
                                                                  maxLines: 20,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15.0),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                ),

                                                  decoration: BoxDecoration(
                                                    color: (document["type"] ==
                                                            "image")
                                                        ? Colors.cyan
                                                        : Colors.cyan,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            topLeft:
                                                                Radius.circular(
                                                                    25),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    25)),
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 223,
                                                  top: 18,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.60),
                                                    child: PopupMenuButton(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.cyan,
                                                              width: 3),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                15.0),
                                                          ),
                                                        ),
                                                        icon: Icon(
                                                          Icons
                                                              .more_vert_rounded,
                                                          color: Colors.white,
                                                        ),
                                                        itemBuilder:
                                                            (context) => [
                                                                  PopupMenuItem(
                                                                      onTap:
                                                                          () {
                                                                        print(
                                                                            'Hellow Image');
                                                                        _save(
                                                                            document["massages"],
                                                                            "kittie");
                                                                      },
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(Icons
                                                                              .save_alt_rounded),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            'Save Image',
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )
                                                                        ],
                                                                      ))
                                                                ],
                                                        color:
                                                            Color(0xff131313)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              document["timestrap"].toString(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                } else {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                //  \ height: 20.0,
                                                // width: 220.0,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.0),
                                                padding: EdgeInsets.all(10.0),
                                                child: (document["type"] ==
                                                        "image")
                                                    ? Stack(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
                                                              document[
                                                                  "massages"],
                                                              width: 250.0,
                                                              fit: BoxFit.cover,
                                                              frameBuilder:
                                                                  (context,
                                                                      child,
                                                                      frame,
                                                                      wasSynchronouslyLoaded) {
                                                                return child;
                                                              },
                                                              loadingBuilder:
                                                                  (context,
                                                                      child,
                                                                      loadingProgress) {
                                                                if (loadingProgress ==
                                                                    null) {
                                                                  return child;
                                                                } else {
                                                                  return Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 2,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.60),
                                                              child:
                                                                  PopupMenuButton(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.cyan,
                                                                            width: 3),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0),
                                                                        ),
                                                                      ),
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .more_vert_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      itemBuilder:
                                                                          (context) =>
                                                                              [
                                                                                PopupMenuItem(
                                                                                    onTap: () {
                                                                                      print('Hellow Image Recive');
                                                                                      _save(document["massages"], "kittie");
                                                                                    },
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Icon(Icons.save_alt_rounded),
                                                                                        SizedBox(
                                                                                          width: 10,
                                                                                        ),
                                                                                        Text(
                                                                                          'Save Image',
                                                                                          style: TextStyle(color: Colors.white),
                                                                                        )
                                                                                      ],
                                                                                    ))
                                                                              ],
                                                                      color: Color(
                                                                          0xff131313)),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : (document["type"] ==
                                                            "video")
                                                        ? Stack(
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                height: 300,
                                                                width: 170,
                                                                child: addvideo(
                                                                    vid: document[
                                                                        "massages"]),
                                                              ),
                                                              Positioned(
                                                                top: 2,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.60),
                                                                  child: PopupMenuButton(
                                                                      shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color:
                                                                                Colors.cyan,
                                                                            width: 3),
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0),
                                                                        ),
                                                                      ),
                                                                      icon: Icon(
                                                                        Icons
                                                                            .more_vert_rounded,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      itemBuilder: (context) => [
                                                                            PopupMenuItem(
                                                                                onTap: () {
                                                                                  print('Hellow Video recive');
                                                                                  _saveVideo(document["massages"], 'Billie');
                                                                                },
                                                                                child: Row(
                                                                                  children: [
                                                                                    Icon(Icons.save_alt_rounded),
                                                                                    SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    Text(
                                                                                      'Save Video',
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    )
                                                                                  ],
                                                                                ))
                                                                          ],
                                                                      color: Color(0xff131313)),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : (document["type"] ==
                                                                "location")
                                                            ? Container(
                                                                height: 200,
                                                                width: 400,
                                                                child: Showloc(
                                                                  loc: widget
                                                                      .receiverid,
                                                                ),
                                                              )
                                                            : Text(
                                                                document[
                                                                    "massages"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                decoration: BoxDecoration(
                                                  color: (document["type"] ==
                                                          "image")
                                                      ? Color(0xff223152)
                                                      : Color(0xff223152)
                                                          .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  25),
                                                          topLeft:
                                                              Radius.circular(
                                                                  25),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  25)),
                                                  shape: BoxShape.rectangle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            document["timestrap"].toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }).toList(),
                            ),
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
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, right: 6, bottom: 5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          final content = Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 200.0,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Color(0xff131313),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                ),
                                child: GridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    ),
                                    children: [
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //     permission();
                                      //     DateTime now = DateTime.now();
                                      //     String formattedDate =
                                      //         DateFormat("dd-MM-yy")
                                      //             .format(now);
                                      //     print(formattedDate);
                                      //     String formattedDate1 = DateFormat('')
                                      //         .add_jms()
                                      //         .format(now);
                                      //     print(formattedDate);
                                      //     print(formattedDate1);
                                      //     final XFile? image =
                                      //         await _picker.pickImage(
                                      //             source: ImageSource.camera);
                                      //     imagefile = File(image!.path);
                                      //     var uuid = Uuid();
                                      //     var filename =
                                      //         uuid.v4().toString() + ".jpg";
                                      //     print("file:" + filename);
                                      //     await FirebaseStorage.instance
                                      //         .ref(filename)
                                      //         .putFile(imagefile!)
                                      //         .whenComplete(() {})
                                      //         .then((filedata) async {
                                      //       filedata.ref
                                      //           .getDownloadURL()
                                      //           .then((fileurl) async {
                                      //         await FirebaseFirestore.instance
                                      //             .collection("user")
                                      //             .doc(senderid)
                                      //             .collection("chat")
                                      //             .doc(receiverid)
                                      //             .collection("message")
                                      //             .add({
                                      //           "senderid": senderid,
                                      //           "receiverid": receiverid,
                                      //           "massages": fileurl,
                                      //           "type": "image",
                                      //           "time": formattedDate1,
                                      //           "date": formattedDate,
                                      //         }).then((value) async {
                                      //           await FirebaseFirestore.instance
                                      //               .collection("user")
                                      //               .doc(receiverid)
                                      //               .collection("chat")
                                      //               .doc(senderid)
                                      //               .collection("message")
                                      //               .add({
                                      //             "senderid": senderid,
                                      //             "receiverid": receiverid,
                                      //             "massages": fileurl,
                                      //             "type": "image",
                                      //             "time": formattedDate1,
                                      //             "date": formattedDate,
                                      //           }).then((value) {
                                      //             _chat.text.toString();
                                      //           });
                                      //         });
                                      //       });
                                      //     });
                                      //   },
                                      //   child: Column(
                                      //     children: [
                                      //       Container(
                                      //         height: 60.0,
                                      //         width: 60.0,
                                      //         decoration: BoxDecoration(
                                      //             shape: BoxShape.circle,
                                      //             color: Colors.cyanAccent),
                                      //         child: Icon(
                                      //           Icons.camera_alt_outlined,
                                      //           color: Colors.black,
                                      //           size: 30.0,
                                      //         ),
                                      //       ),
                                      //       SizedBox(
                                      //         height: 10,
                                      //       ),
                                      //       Text(
                                      //         "Camera",
                                      //         style: TextStyle(
                                      //             color: Colors.white),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      GestureDetector(
                                        onTap: () async {
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);

                                          imagefile = File(image!.path);
                                          upload();
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.cyanAccent),
                                              child: Icon(
                                                Icons.photo,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Photos",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final XFile? image =
                                              await _picker.pickVideo(
                                                  source: ImageSource.gallery);
                                          imagefile = File(image!.path);
                                          video();
                                          Navigator.of(context).pop();

                                          // FilePickerResult? imagefile =
                                          // await FilePicker.platform
                                          //     .pickFiles(
                                          //     type: FileType.any,
                                          //     allowMultiple:
                                          //     false);
                                          //
                                          // if (imagefile == null) return;
                                          // final path = imagefile
                                          //     .files.single.path!;
                                          // setState(() {
                                          //   file=File(path);
                                          // });
                                          // // final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                                          // imagefile = File(image!.path);

                                          // video();
                                          // showFilePicker(
                                          //     FileType.video);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.cyanAccent),
                                              child: Icon(
                                                Icons
                                                    .video_camera_back_outlined,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Videos",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          final XFile? image =
                                              await _picker.pickImage(
                                                  source: ImageSource.gallery);

                                          imagefile = File(image!.path);
                                          upload();
                                          Navigator.of(context).pop();
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.cyanAccent),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print('hello');
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => location(
                                                loc: widget.receiverid),
                                          ));
                                          Navigator.of(context).pop();
                                          // Navigator.of(context)
                                          //     .push(MaterialPageRoute(
                                          //   builder: (context) => location(
                                          //     loc: widget.receiverid,
                                          //   ),
                                          // ));
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.cyanAccent),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                color: Colors.black,
                                                size: 30.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Location",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return FractionallySizedBox(
                                  widthFactor: 0.9,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: content,
                                  ),
                                );
                              });
                        },
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // borderRadius: BorderRadius.only(
                            //   topRight: Radius.circular(25),
                            //   topLeft: Radius.circular(25),
                            // ),
                            color: Colors.white.withOpacity(0.15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: TextField(
                                  style: TextStyle(color: Colors.white),
                                  cursorColor:
                                      Color.fromARGB(153, 190, 190, 190),
                                  keyboardType: TextInputType.text,
                                  controller: _chat,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Message',
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 126, 126, 126)),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyanAccent.shade100,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyanAccent.shade100,
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        Icons.emoji_emotions_rounded,
                                        color:
                                            Color.fromARGB(255, 210, 210, 210),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          emojiShowing = !emojiShowing;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  var senderid = pref.getString("senderid");
                                  var receiverid = widget.receiverid;
                                  print("senderid : " + senderid!);
                                  print("receiverid : " + receiverid);
                                  DateTime now = DateTime.now();
                                  String formattedDate =
                                      DateFormat("dd-MM-yy").format(now);
                                  print(formattedDate);
                                  String formattedDate1 = DateFormat()
                                      .add_jm()
                                      .format(DateTime.now());
                                  print(formattedDate);
                                  print(formattedDate1);

                                  var msg = _chat.text.toString();
                                  print(msg);

                                  if (msg.length >= 1) {
                                    await FirebaseFirestore.instance
                                        .collection("user")
                                        .doc(senderid)
                                        .collection("chat")
                                        .doc(receiverid)
                                        .collection("message")
                                        .add({
                                      "senderid": senderid,
                                      "receiverid": receiverid,
                                      "massages": msg,
                                      "type": "text",
                                      "date": formattedDate.toString(),
                                      "time": now.toString(),
                                      "timestrap": formattedDate1.toString(),
                                    }).then((value) async {
                                      await FirebaseFirestore.instance
                                          .collection("user")
                                          .doc(receiverid)
                                          .collection("chat")
                                          .doc(senderid)
                                          .collection("message")
                                          .add({
                                        "senderid": senderid,
                                        "receiverid": receiverid,
                                        "massages": msg,
                                        "type": "text",
                                        "date": formattedDate.toString(),
                                        "time": now.toString(),
                                        "timestrap": formattedDate1.toString(),
                                      }).then((value) {
                                        print(value);
                                        _chat.text = '';
                                        _scrollController.animateTo(
                                            _scrollController
                                                .position.minScrollExtent,
                                            duration:
                                                Duration(milliseconds: 200),
                                            curve: Curves.easeInOut);
                                      });
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Color.fromARGB(255, 210, 210, 210),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                        onEmojiSelected: (Category? category, Emoji emoji) {
                          _onEmojiSelected(emoji);
                        },
                        onBackspacePressed: _onBackspacePressed,
                        config: Config(
                            columns: 7,
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            initCategory: Category.RECENT,
                            bgColor: const Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            backspaceColor: Colors.blue,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void permission() async {
    Map<Permission, PermissionStatus> map =
        await [Permission.storage, Permission.camera].request();

    if (await Permission.camera.isDenied) {
      print("Camera Deny");
    }
    if (await Permission.storage.isDenied) {
      print("location");
    }
  }

  _saveVideo(String path, String name) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/$name.mp4";
    EasyLoading.show(status: 'Downloading Video ...');
    await Dio().download(path, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);
    EasyLoading.showSuccess('Video Saved to Gallery');
    // Fluttertoast.showToast(
    //     msg: 'Video Saved to Gallery',
    //     toastLength: Toast.LENGTH_SHORT,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.cyan,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  _save(String path, String name) async {
    EasyLoading.show(status: 'Downloading Image ...');
    var response = await Dio()
        .get(path, options: Options(responseType: ResponseType.bytes));

    var result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: name);
    print(response.data);
    EasyLoading.showSuccess('Image Saved to Gallery');
    // Fluttertoast.showToast(
    //     msg: 'Image Saved to Gallery',
    //     toastLength: Toast.LENGTH_SHORT,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.cyan,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }
}
