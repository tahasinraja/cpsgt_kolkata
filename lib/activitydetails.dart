import 'dart:convert';
import 'package:calcutta_psapp/imageviwer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class activitydetails extends StatefulWidget {
  final String teamName;
  const activitydetails({super.key, required this.teamName});

  @override
  State<activitydetails> createState() => _activitydetailsState();
}

class _activitydetailsState extends State<activitydetails> {
  List<dynamic> activityDetails = [];
  List<dynamic> activityImages = [];

  /// DETAILS API
  Future<void> fetchActivityDetails(String teamName) async {
    final uri = Uri.parse(
      'https://cpsgtinst.org/app/actides.php?team_name=$teamName',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        print('Description fetch succefully');
        final data = jsonDecode(response.body);
        setState(() {
          activityDetails = data['stock'];
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  /// IMAGE API
  Future<void> fetchActivityImages(String teamName) async {
    final uri = Uri.parse('https://cpsgtinst.org/app/actimg.php?cat=$teamName');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        print('image fetch succesfully');
        final data = jsonDecode(response.body);
        setState(() {
          activityImages = data['stock'];
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchActivityDetails(widget.teamName);
    fetchActivityImages(widget.teamName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: Text(
          widget.teamName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: activityDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 DESCRIPTION CARD
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          activityDetails[0]['description'] ?? '',
                          style: const TextStyle(fontSize: 15, height: 1.5),
                        ),
                      ),
                    ),
                  ),

                  /// 🔹 IMAGE GALLERY TITLE
                  if (activityImages.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  /// 🔹 IMAGE GRID
                  if (activityImages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activityImages.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => imageviwer(
                                    imageurl: activityImages[index]['image'],
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                activityImages[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
