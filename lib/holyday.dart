import 'dart:convert';
import 'package:calcutta_psapp/hoteldetailspage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HolydayPage extends StatefulWidget {
  const HolydayPage({super.key});

  @override
  State<HolydayPage> createState() => _HolydayPageState();
}

class _HolydayPageState extends State<HolydayPage> {
  // destination list
  List<Map<String, dynamic>> holydayplace = [];

  // hotel list
  List<Map<String, dynamic>> locationlist = [];

  bool loadingLocation = false;

  @override
  void initState() {
    super.initState();
    holydaylocation();
  }

  /// DESTINATION API
  Future<void> holydaylocation() async {
    final uri = Uri.parse('https://cpsgtinst.org/app/destination.php');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          holydayplace = List<Map<String, dynamic>>.from(data['stock']);
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// LOCATION / HOTEL API
  Future<void> locations(String location) async {
    setState(() {
      loadingLocation = true;
      locationlist.clear();
    });

    final uri = Uri.parse(
      'https://cpsgtinst.org/app/hotel.php?location=$location',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          locationlist = List<Map<String, dynamic>>.from(data['stock']);
          loadingLocation = false;
        });
      }
    } catch (e) {
      loadingLocation = false;
      print('Error: $e');
    }
  }

  /// BOTTOM SHEET
 void openLocationSheet(String location) async {
  await locations(location);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: loadingLocation
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [

                  /// 🔷 DRAG HANDLE
                  const SizedBox(height: 10),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔷 LOCATION HEADER
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D3B66), Color(0xFF164E83)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔷 HOTEL LIST
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: locationlist.length,
                      itemBuilder: (context, index) {
                        final hotel = locationlist[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF0D3B66),
                              child: const Icon(Icons.hotel, color: Colors.white),
                            ),
                            title: Text(
                              hotel['name'] ?? 'Hotel',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              hotel['address'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Hoteldetailspage(
                                    hotelName: hotel['name'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Holiday Destinations",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D3B66),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: holydayplace.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: holydayplace.length,
              itemBuilder: (context, index) {
                final place = holydayplace[index];
                return InkWell(
                  onTap: () => openLocationSheet(place['location']),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          place['location'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
