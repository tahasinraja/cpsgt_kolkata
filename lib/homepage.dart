import 'package:calcutta_psapp/Gallery.dart';
import 'package:calcutta_psapp/activity.dart';
import 'package:calcutta_psapp/executivecment.dart';
import 'package:calcutta_psapp/holyday.dart';
import 'package:calcutta_psapp/payment.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String phone;
  const HomePage({super.key, required this.phone});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> banners = [
    'lib/assets/images/banner.jpg',
    'lib/assets/images/banner.jpg',
    'lib/assets/images/banner.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 🔷 APP BAR
      appBar: AppBar(
  backgroundColor: const Color(0xFF0D3B66),
  centerTitle: true,
  title: Row(
    children: [
      Image.asset(
        'lib/assets/images/cpsgts.png',
        height: 34,
      ),
      const SizedBox(width: 8),

      Expanded(
        child: Text(
          "Calcutta Police Sergeants' Institute & Police Athletic Club",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16, // AppBar ke liye 14 better
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  ),
),


      // 🔷 BODY
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔷 IMAGE BANNER
            Container(
              child: CarouselSlider(
                items: banners.map((banner) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Image.asset(
                        banner,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
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
                      // Handle tap for PAYMENT
                    },
                    icon: Icons.handshake,
                    text: "PAYMENT",
                    color: Colors.blue,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              paymentpage(phone: widget.phone),
                        ),
                      );
                    },
                    icon: Icons.pending_actions,
                    text: "PENDING PAYMENT",
                    color: Colors.grey,
                  ),
                  HomeMenu(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HolydayPage()),
                      );
                    },
                    icon: Icons.home,
                    text: "HOLIDAY INN",
                    color: Colors.pink,
                  ),
                  HomeMenu(
                    onTap: () {
                      // Handle tap for ANNOUNCEMENTS
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
              text: "ACTIVITIES",
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
