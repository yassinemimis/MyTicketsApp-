import 'package:flutter/material.dart';

class BuyTramOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Tram Options"),
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TramOptionCard(
              title: "Buy Tram Ticket",
              description: "Purchase a single tram ticket for your trip.",
              icon: Icons.confirmation_number,
              color: Colors.blue.shade300,
              onTap: () {
                // Navigate to Buy Tram Ticket page
              },
            ),
            SizedBox(height: 20),
            TramOptionCard(
              title: "Buy Tram Card",
              description: "Get a rechargeable tram card for frequent use.",
              icon: Icons.credit_card,
              color: Colors.green.shade300,
              onTap: () {
                // Navigate to Buy Tram Card page
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TramOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  TramOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
