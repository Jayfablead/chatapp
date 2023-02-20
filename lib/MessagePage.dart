import 'dart:io';

import 'package:chat1/addvideo.dart';
import 'package:chat1/allConstants/livelocation.dart';
import 'package:chat1/screens/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
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
  late Iterable<Contact> _contacts;
  ImagePicker _picker = ImagePicker();
  var senderid;
  var receiverid;
  String? date;
  int? diff;
  bool emojiShowing = false;
  File? file;

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
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.network(
                                                        document["massages"],
                                                        width: 250.0,
                                                        height: 250.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : (document["type"] ==
                                                          "video")
                                                      ? Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          height: 300,
                                                          width: 170,
                                                          child: addvideo(
                                                              vid: document[
                                                                  "massages"]),
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
                                                              child: Showloc(
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
                                                    ? Color(0xff3AA1FF)
                                                    : Color(0xff3AAFF1),
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    topLeft:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25)),
                                                shape: BoxShape.rectangle,
                                              ),
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
                                          Container(
                                            //  \ height: 20.0,
                                            // width: 220.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            padding: EdgeInsets.all(10.0),
                                            child: (document["type"] == "image")
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                      document["massages"],
                                                      width: 250.0,
                                                      height: 250.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : (document["type"] == "video")
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        height: 300,
                                                        width: 170,
                                                        child: addvideo(
                                                            vid: document[
                                                                "massages"]),
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
                                                                TextAlign.left,
                                                          ),
                                            decoration: BoxDecoration(
                                              color:
                                                  (document["type"] == "image")
                                                      ? Color(0xff223152)
                                                      : Color(0xff223152)
                                                          .withOpacity(0.3),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft: Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25)),
                                              shape: BoxShape.rectangle,
                                            ),
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
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
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
                                        onTap: () {
                                          print('hello');
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => location(
                                              loc: widget.receiverid,
                                            ),
                                          ));
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
                                width: 260,
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
}
