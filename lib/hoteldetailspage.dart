import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Hoteldetailspage extends StatefulWidget {
  final String hotelName;
  const Hoteldetailspage({super.key, required this.hotelName});

  @override
  State<Hoteldetailspage> createState() => _HoteldetailspageState();
}

class _HoteldetailspageState extends State<Hoteldetailspage> {
  
  //map funtion
  Future<void> onmape(String lat, String lng) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open map';
    }
    
  }

  Map<String, dynamic>? hoteledetail;
  Future<void> hoteldescription(String hotelName) async {
    final uri = Uri.parse(
      'https://cpsgtinst.org/app/hotel_detls.php?name=$hotelName',
    );
    try {
      final Response = await http.get(uri);
      if (Response.statusCode == 200) {
        print('Hotel details fetch succefully');
        final Data = jsonDecode(Response.body);
        setState(() {
          hoteledetail = Map<String, dynamic>.from(Data['stock'][0]);
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
    hoteldescription(widget.hotelName);
    
  }

  @override
  Widget build(BuildContext context) {
final lat = hoteledetail?['lat']?.toString().trim();
final lng = hoteledetail?['lng']?.toString().trim();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: Text(widget.hotelName, style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade200,
      body: hoteledetail == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // 🔷 TOP BANNER
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0D3B66), Color(0xFF164E83)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.hotel,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                  // 🔷 DETAILS CARD
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _detailRow(Icons.hotel, hoteledetail!['name']),
                            _detailRow(
                              Icons.location_on,
                              hoteledetail!['address'],
                            ),
                            _detailRow(Icons.phone, hoteledetail!['phone']),
                            _detailRow(Icons.place, hoteledetail!['location']),
                    




                        
                          ],
                        ),
                        
                      ),
                      
                    ),
                  ),



if (lat != null && lat.isNotEmpty && lng != null && lng.isNotEmpty)
  Padding(
    padding: const EdgeInsets.all(16),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0D3B66),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        onmape(lat, lng);
      },
      icon: const Icon(Icons.map, color: Colors.white),
      label: const Text(
        "View on Google Map",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),

                if (lat == null || lat.isEmpty || lng == null || lng.isEmpty)
  const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      "Location not available",
      style: TextStyle(color: Colors.grey),
    ),
  ),

                ],
              ),
            ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
