import 'package:chat1/lotginwithgoogle.dart';
import 'package:chat1/provider/auth_provider.dart';
import 'package:chat1/screens/login_page.dart';
import 'package:chat1/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Loginwithgoogle(),
        title: "FlutterPhoneAuth",
      ),
    );
  }
}
