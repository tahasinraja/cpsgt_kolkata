
import 'package:calcutta_psapp/commingsoon.dart';
import 'package:calcutta_psapp/holyday.dart';
import 'package:flutter/material.dart';

class facilitespage extends StatefulWidget {
  const facilitespage({super.key});

  @override
  State<facilitespage> createState() => _facilitespageState();
}

class _facilitespageState extends State<facilitespage> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Holidays', 'icon': Icons.holiday_village_outlined},
    {'name': 'Gym', 'icon': Icons.fitness_center_outlined},
    {'name': 'Clubbing', 'icon': Icons.nightlife_outlined},
    {'name': 'Social Gathering', 'icon': Icons.groups_outlined},
    {'name': 'Lifestyle', 'icon': Icons.self_improvement_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: Text(
          'Facilities Area',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FacilityGridItem(
                  title: 'Holidays',
                  icon: Icons.holiday_village_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HolydayPage()),
                    );
                  },
                ),
                FacilityGridItem(
                  title: 'Gym',
                  icon: Icons.fitness_center_outlined,
                    onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoonPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FacilityGridItem(
                  title: 'Clubbing',
                  icon: Icons.nightlife_outlined,
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoonPage()),
                    );
                  },
                ),
                FacilityGridItem(
                  title: 'Social Gathering',
                  icon: Icons.groups_outlined,
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoonPage()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FacilityGridItem(
                  title: 'Lifestyle',
                  icon: Icons.self_improvement_outlined,
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComingSoonPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FacilityGridItem extends StatelessWidget {
  final String title;
  final IconData icon;
 // final bool isEnabled;
  final VoidCallback? onTap;

  const FacilityGridItem({
    super.key,
    required this.title,
    required this.icon,
   // this.isEnabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onTap ,
     
       
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 31, 30, 30),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D3B66),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color:Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
