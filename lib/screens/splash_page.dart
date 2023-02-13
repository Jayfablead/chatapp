import 'package:chat1/allConstants/color_constants.dart';
import 'package:chat1/allConstants/size_constants.dart';
import 'package:chat1/screens/home_page.dart';
import 'package:chat1/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../providers/auth_provider1.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AuthProvider1 authProvider = context.read<AuthProvider1>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Welcome to Smart Talk",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Sizes.dimen_18),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Smartest Chat Application",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: Sizes.dimen_18),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(
              color: AppColors.lightGrey,
            ),
          ],
        ),
      ),
    );
  }
}
