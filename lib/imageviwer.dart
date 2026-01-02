import 'package:flutter/material.dart';

class imageviwer extends StatefulWidget {
  final String imageurl;
  const imageviwer({super.key,required this.imageurl});

  @override
  State<imageviwer> createState() => _imageviwerState();
}

class _imageviwerState extends State<imageviwer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
         backgroundColor: Colors.black,
        title: Text('View',style: TextStyle(color: Colors.white),),centerTitle: true,
      ),
      body: Center(
        child: InteractiveViewer(
           minScale: 1,
          maxScale: 4,
          child: Image.network(
widget.imageurl,
 fit: BoxFit.contain,
        )),
      )
    );
  }
}