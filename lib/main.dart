import 'package:calcutta_psapp/mainhome.dart';
import 'package:calcutta_psapp/otploginpage.dart';
import 'package:calcutta_psapp/splacescreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //check login
  Future<Widget> checklogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final phone = prefs.getString('phone') ?? '';

    if (isLoggedIn) {
      return MainPage(phone: phone);
    } else {
      return sendotppage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checklogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Splacescreen();
          }
          return snapshot.data!;
        },
      ),
    );
  }
}
