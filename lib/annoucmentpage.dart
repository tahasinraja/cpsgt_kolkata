import 'package:flutter/material.dart';

class Annoucmentpage extends StatefulWidget {
  const Annoucmentpage({super.key});

  @override
  State<Annoucmentpage> createState() => _AnnoucmentpageState();
}

class _AnnoucmentpageState extends State<Annoucmentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3B66),
        title: Text('Announcements',style: TextStyle(fontSize: 16,color: Colors.white),
        ),centerTitle: true,
      ),
      body: Center(
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 30),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.grey.shade200,
            child: Icon(
              Icons.campaign_outlined,
              size: 40,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "No Announcements",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Currently not available any announcement.\nPlease visit again later.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  ),
)

    );
  }
}