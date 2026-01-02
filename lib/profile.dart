import 'dart:convert';

import 'package:calcutta_psapp/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String phone;
  const ProfilePage({super.key, required this.phone});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;

  Future<void> fetchprofile(String phone) async {
    final uri = Uri.parse('https://cpsgtinst.org/app/logindetil.php?ph=$phone');
    try {
      final responce = await http.get(uri);
      if (responce.statusCode == 200) {
        print('Profile succesfully loaded');
        print("Responce:$responce");
        final data = jsonDecode(responce.body);
        print(responce.body);
       if (data['stock'] != null && data['stock'].isNotEmpty) {
  setState(() {
    profile = data['stock'][0];
  });
} else {
  print("No profile data found");
}
      } else {
        print("Failed:$responce");
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchprofile(widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('lib/assets/images/cpsgts.png', height: 32),
            Text(
              "Calcutta Police Sergeant's Institute",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              icon: Icon(Icons.logout_outlined, color: Colors.red),
            ),
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey.shade200,

      body: profile == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔷 TOP BLUE SECTION
                Container(
                  height: 230,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0D3B66), Color(0xFF164E83)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Image.network(profile!['image']),
                ),

                // 🔷 DETAILS CARD
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ProfileRow(
                            icon: Icons.military_tech,
                            text: '${profile!['name']}',
                          ),
                          ProfileRow(
                            icon: Icons.phone,
                            text: '${profile!['ph']}',
                          ),
                          Divider(height: 1),
                          ProfileRow(
                            icon: Icons.email,
                            text: '${profile!['email']}',
                          ),
                          Divider(height: 1),
                          ProfileRow(
                            icon: Icons.location_on,
                            text: '${profile!['address']}',
                          ),
                          Divider(height: 1),
                          ProfileRow(
                            icon: Icons.calendar_month,
                            text: '${profile!['rank']}',
                          ),
                          Divider(height: 1),
                          ProfileRow(
                            icon: Icons.event,
                            text: '${profile!['batch']}',
                          ),
                          Divider(height: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

      // // 🔷 BOTTOM NAV BAR
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 2,
      //   selectedItemColor: const Color(0xFF0D3B66),
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.link),
      //       label: "",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }
}

// 🔷 ROW WIDGET
class ProfileRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 20),
          Text(text, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        ],
      ),
    );
  }
}
