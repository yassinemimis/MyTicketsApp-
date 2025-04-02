import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class TicketHistoryPage extends StatefulWidget {
  @override
  _TicketHistoryPageState createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<TicketHistoryPage> {
  
  List<Map<String, String>> allTickets = [
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
  ];

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); 

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredTickets = allTickets
        .where((ticket) => ticket['date'] == selectedDate)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Scanned Tickets", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton.icon(
              onPressed: _selectDate,
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text("Filter by Day", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF578FCA)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTickets.length,
              itemBuilder: (context, index) {
                final ticket = filteredTickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: ListTile(
                    title: Text("Destination: ${ticket['destination']}", style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Type: ${ticket['type']} \nDate: ${ticket['date']}"),
                    trailing: Text(
                      ticket['status']!,
                      style: TextStyle(
                        color: ticket['status'] == "Valid" ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to select a date
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2025, 12, 31),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }
}
