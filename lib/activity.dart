import 'package:calcutta_psapp/activitydetails.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final List<Map<String, dynamic>> sportsList = [
    {"name":"Archery","icon":Icons.sports_score},
    {"name":"Athletic", "icon": Icons.directions_run},
    {"name":"Basketball", "icon": Icons.sports_basketball},
    {"name":"Billiards", "icon": Icons.sports},
    {"name":"Chess","icon":Icons.sports_esports},
    {"name":"Combat","icon":Icons.sports_mma},
    {"name":"Cricket", "icon": Icons.sports_cricket},
    {"name":"Football", "icon": Icons.sports_soccer},
    {"name":"Hockey", "icon": Icons.sports_hockey},
    {"name":"Handball", "icon": Icons.sports_handball},
    {"name":"Kabaddi", "icon": Icons.sports_kabaddi},
    {"name":"Rowing","icon":Icons.rowing},
    {"name":"Rugby", "icon": Icons.sports_rugby},
    {"name":"Volleyball", "icon": Icons.sports_volleyball},
    
    
    
    
    
   
   
    
   
    
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: const Text(
          "Sports Activities",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activities ', style: TextStyle(fontSize: 30)),
                  Text('Calcutta Police Sergeants Institute'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: sportsList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final sport = sportsList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              activitydetails(teamName: sport['name']),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFF0D3B66),
                            child: Icon(
                              sport['icon'],
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            sport['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
