import 'dart:async';




import 'package:calcutta_psapp/otploginpage.dart';

import 'package:flutter/material.dart';

class Splacescreen extends StatefulWidget {
  const Splacescreen({super.key});

  @override
  State<Splacescreen> createState() => _SplacescreenState();
}

class _SplacescreenState extends State<Splacescreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>sendotppage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D3B66),
      body: Container(
        child: Center(
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/images/cpsgts.png',
                width: 200,
                height: 200,
              ),

              SizedBox(height: 30,),
              Text('UNMESH',style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 30,color: Colors.white),)
            ],
          ),
        
        ),
      ),
    );
  }
}
