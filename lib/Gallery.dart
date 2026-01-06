import 'dart:convert';

import 'package:calcutta_psapp/imageviwer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class gallerypage extends StatefulWidget {
  const gallerypage({super.key});

  @override
  State<gallerypage> createState() => _gallerypageState();
}

class _gallerypageState extends State<gallerypage> {
  List<dynamic>? gallerylist;
  Future<void> fetchgallery() async {
    final uri = Uri.parse('https://cpsgtinst.org/app/gallery.php');
    try {
      final responce = await http.get(uri);
      if (responce.statusCode == 200) {
        print('Fetch succefully');
        final data = jsonDecode(responce.body);
        setState(() {
          gallerylist = data['stock'];
        });
      } else {
        print('Failed to load');
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchgallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: Text('Gallery', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: gallerylist == null
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: gallerylist!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => imageviwer(
                              imageurl: gallerylist![index]['image'],
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: Image.network(
                          gallerylist![index]['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
