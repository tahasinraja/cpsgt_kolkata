import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class executivepage extends StatefulWidget {
  const executivepage({super.key});

  @override
  State<executivepage> createState() => _executivepageState();
}

class _executivepageState extends State<executivepage> {
  List<Map<String, dynamic>> executivelist = [];
  Future<void> fetchexecutive() async {
    final uri = Uri.parse('https://cpsgtinst.org/app/executive_cmeti.php');
    try {
      final responce = await http.get(uri);
      if (responce.statusCode == 200) {
        print('Executive CMTE fetch succefully');
        final data = jsonDecode(responce.body);
        setState(() {
          executivelist = List<Map<String, dynamic>>.from(data['stock']);
        });
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchexecutive();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Executive Committee",style: TextStyle(color: Colors.white),),
      backgroundColor: const Color(0xFF0D3B66),
    ),
    body: executivelist.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: executivelist.length,
            itemBuilder: (context, index) {
              final exec = executivelist[index];
              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            NetworkImage(exec['image']),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exec['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(exec['post'],
                                style: const TextStyle(
                                    color: Colors.blueGrey)),
                            Text(exec['deg'],
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

}
