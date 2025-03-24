import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // لحساب التاريخ 
import 'package:qr_code_scanner/qr_code_scanner.dart';
class ControllerPage extends StatefulWidget {
  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  // Fake scanned tickets data
  List<Map<String, String>> allTickets = [
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
    {"destination": "Station A", "type": "Student", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station B", "type": "Regular", "date": "2025-03-22", "status": "Expired"},
    {"destination": "Station C", "type": "Senior", "date": "2025-03-23", "status": "Valid"},
    {"destination": "Station D", "type": "Regular", "date": "2025-03-21", "status": "Expired"},
  ];

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Default to today

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredTickets = allTickets
        .where((ticket) => ticket['date'] == selectedDate)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Controller", style: TextStyle(color: Colors.white)),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF578FCA),
        onPressed: () {
          Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QRScannerScreen()),
      );
        },
        child: Icon(Icons.qr_code_scanner, color: Colors.white),
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

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = "Scan a QR code";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QR Scanner")),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  setState(() {
                    qrText = scanData.code!;
                  });
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                qrText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
