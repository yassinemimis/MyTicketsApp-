import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); 

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
  bool isProcessing = false; 

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> checkQRCode(String qrCode) async {
    final url = Uri.parse("http://192.168.1.3:5000/validate");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"code_ticket": qrCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              result: data,
              qrCode: qrCode,
            ),
          ),
        );
      } else {
      

    final url1 = Uri.parse("http://192.168.1.3:5000/validatecard");

  final response1 = await http.post(
        url1,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"code_ticket": qrCode}),
      );

      if (response1.statusCode == 200) {
        final data1 = jsonDecode(response1.body);
        
       print('$data1');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreencard(
              result: data1,
              qrCode: qrCode,
            ),
          ),
        );
      }


        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ResultScreen(
        //       result: {"valid": false, "message":"Server connection error"},
        //       qrCode: qrCode,
        //     ),
        //   ),
        // );
      }
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: {"valid": false, "message": "Connection failed: $e"},
            qrCode: qrCode,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("QR Scanner", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
             onQRViewCreated: (QRViewController controller) {
  this.controller = controller;
  controller.scannedDataStream.listen((scanData) {
    if (!isProcessing) {
      setState(() {
        isProcessing = true;
        qrText = scanData.code!;
      });

      controller.pauseCamera(); 
      checkQRCode(qrText).then((_) {
        setState(() {
          isProcessing = false;
        });
        controller.resumeCamera();
      });
    }
  });
},

              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "$qrText",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final String qrCode;
 
  const ResultScreen({Key? key, required this.result, required this.qrCode})
      : super(key: key);

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }



Future<void> updatevalidate(String qrCode, BuildContext context) async {
  final url = Uri.parse("http://192.168.1.3:5000/validate-and-update");
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"code_ticket": qrCode}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"] ?? "Updated successfully!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update. Try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    bool valid = result["valid"] == true;
    String message = result["message"] ?? "";
    Map<String, dynamic>? ticket = result["ticket"];

    return Scaffold(
       appBar: AppBar(
        title: Text("Verification Result", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              valid ? "✅ Ticket is Valid" : "❌ Ticket is Invalid",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valid ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

          
            if (ticket != null) ...[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ticket Details:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),

                      RowInfo(label: "Ticket ID:", value: "${ticket["id"]}"),
                      RowInfo(label: "Ticket Code:", value: "${ticket["code_ticket"]}"),
                      RowInfo(label: "User ID:", value: "${ticket["user_id"]}"),
                      RowInfo(label: "Passages Count:", value: "${ticket["nombre_passage"]}"),
                      RowInfo(label: "Total Price:", value: "${ticket["total_price"]} DZD"),
                      RowInfo(label: "Status:", value: ticket["valide"] == "yes" ? "✔️ Valid" : "❌ Invalid"),
                      RowInfo(label: "Station:", value: "${ticket["state"]}"),
                      RowInfo(label: "Ticket Type:", value: "${ticket["type_ticket"]}"),                  
                      RowInfo(label: "Creation Date:", value: formatDate(ticket["date_creation"])),
                    ],
                  ),
                ),
              ),
            ],

            Spacer(),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF578FCA),
        minimumSize: Size(120, 50), 
      ),
      onPressed: () {
        Navigator.pop(context); 
      },
      child: Text(
        "Back",
        style: TextStyle(color: Colors.white),
      ),
    ),
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF578FCA),
        minimumSize: Size(120, 50), 
      ),
      onPressed: () {
         updatevalidate(qrCode, context);
      },
      child: Text(
        "Validate",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ],
),

           
          ],
        ),
      ),
    );
  }
}



class ResultScreencard extends StatelessWidget {
  final Map<String, dynamic> result;
  final String qrCode;
 
  const ResultScreencard({Key? key, required this.result, required this.qrCode})
      : super(key: key);

  String formatDate(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }



  @override
  Widget build(BuildContext context) {
    bool valid = result["valid"] == true;
    String message = result["message"] ?? "";
    Map<String, dynamic>? card = result["card"];

    return Scaffold(
       appBar: AppBar(
        title: Text("Verification Result", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              valid ? "✅ Card is Valid" : "❌ Card is Invalid",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valid ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

          
            if (card != null) ...[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Card Details:",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),

                   RowInfo(label: "card ID:", value: "${card["id_ab"].toString()}"),
                      RowInfo(label: "card Code:", value: "${card["code_card"]}"),
                      RowInfo(label: "User ID:", value: "${card["user_id"]}"),
                      RowInfo(label: "Total Price:", value: "${card["total_price"]} DZD"),
                      RowInfo(label: "Status:", value: card["statut"] == "actif" ? "✔️ Valid" : "❌ Invalid"),
                      RowInfo(label: "Station:", value: "${card["state"]}"),
                      RowInfo(label: "card Type:", value: "${card["subscription_type"]}"),                                  
                       RowInfo(label: "date_debut:", value: formatDate(card["date_debut"])),       
                      RowInfo(label: "date_fin:", value: formatDate(card["date_fin"])),

                    ],
                  ),
                ),
              ),
            ],

            Spacer(),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF578FCA),
        minimumSize: Size(120, 50), 
      ),
      onPressed: () {
        Navigator.pop(context); 
      },
      child: Text(
        "Back",
        style: TextStyle(color: Colors.white),
      ),
    ),
    
  ],
),

           
          ],
        ),
      ),
    );
  }
}




class RowInfo extends StatelessWidget {
  final String label;
  final String value;

  const RowInfo({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
