import 'package:calcutta_psapp/Gallery.dart';
import 'package:calcutta_psapp/activity.dart';
import 'package:calcutta_psapp/annoucmentpage.dart';
import 'package:calcutta_psapp/executivecment.dart';


import 'package:calcutta_psapp/memberfacilitiespage.dart';
import 'package:calcutta_psapp/otploginpage.dart';
import 'package:calcutta_psapp/payment.dart';
import 'package:calcutta_psapp/webacademy.dart';
import 'package:calcutta_psapp/webachivement.dart';
import 'package:calcutta_psapp/webarchive.dart';
import 'package:calcutta_psapp/webcultural_activities.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String phone;
  const HomePage({super.key, required this.phone});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> banners = [
    'lib/assets/images/20250119_105618.jpg',
    'lib/assets/images/20250119_105634.jpg',
    'lib/assets/images/IMG-20251230-WA0019.jpg',
    'lib/assets/images/IMG-20251230-WA0020.jpg',
    'lib/assets/images/IMG-20251230-WA0021(1).jpg',
    'lib/assets/images/IMG-20251230-WA0022.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔷 APP BAR
      appBar: AppBar(
  backgroundColor: const Color(0xFF0D3B66),
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('lib/assets/images/cpsgts.png', height: 34),
      const SizedBox(width: 8),
      const Text(
        "UNMESH CPSI & PAC",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      const Spacer(), 
          IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => sendotppage()),
                );
              },
              icon: Icon(Icons.logout_outlined, color: Colors.white),
            ),// Left aur right balance ke liye
    ],
  ),
),


      // 🔷 BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            // 🔷 IMAGE BANNER
            Container(
              child: CarouselSlider(
                items: banners.map((banner) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Builder(
                      builder: (BuildContext context) {
                        return Image.asset(
                          banner,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 220,
                  autoPlay: true,
                  enlargeCenterPage: true,
                   viewportFraction: 1.0,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
              ),
            ),

            // Image.asset(
            //   'lib/assets/images/banner.jpg',
            //   width: double.infinity,
            //   height: 200,
            //   fit: BoxFit.cover,
            // ),
            const SizedBox(height: 40),

            // 🔷 GRID MENU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 30,
                children: [
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => executivepage(),
                        ),
                      );
                    },
                    icon: Icons.groups,
                    text: "EXECUTIVE CMTE",
                    color: Color(0xFF0D3B66),
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => webachivementpage(),
                        ),
                      );
                    },
                    icon: Icons.handshake,
                    text: "ACHIVEMENT",
                    color: Colors.blue,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push( 
                        context,
                        MaterialPageRoute(
                          builder: (context,) =>
                              paymentpage(phone: widget.phone),
                        ),
                      );
                    },
                    icon: Icons.pending_actions,
                    text: "PAYMENT",
                    color: Colors.grey,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => facilitespage(),
                        ),
                      );
                    },
                    icon: Icons.home,
                    text: "MEMBER FACILITIES",
                    color: Colors.pink,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Annoucmentpage(),
                        ),
                      );
                    },
                    icon: Icons.campaign,
                    text: "ANNOUNCEMENTS",
                    color: Colors.indigo,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => gallerypage()),
                      );
                    },
                    icon: Icons.photo,
                    text: "GALLERY",
                    color: Colors.green,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => webcalcuralpage(),
                        ),
                      );
                    },
                    icon: Icons.local_activity,
                    text: "CULTURAL ACTIVITY",
                    color: Colors.grey,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => webacademy()),
                      );
                    },
                    icon: Icons.school_outlined,
                    text: "ACADEMY",
                    color: Colors.blue,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => webachivepage(),
                        ),
                      );
                    },
                    icon: Icons.archive_outlined,
                    text: " ARCHIVE",
                    color: const Color.fromARGB(255, 165, 75, 75),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔷 ACTIVITIES BUTTON
            HomeMenu(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActivityPage()),
                );
              },
              icon: Icons.sports_tennis,
              text: "SPORTS",
              color: Colors.red,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // 🔷 BOTTOM NAVIGATION
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 1,
      //   selectedItemColor: const Color(0xFF0D3B66),
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person_outline),
      //       label: "",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "",
      //     ),
      //   ],
      // ),
    );
  }
}

// 🔷 MENU WIDGET
class HomeMenu extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const HomeMenu({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, height: 1.2),
          ),
        ],
      ),
    );
  }
}
