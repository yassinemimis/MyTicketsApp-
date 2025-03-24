import 'package:flutter/material.dart';
import 'package:tram_app2/AllChatsPage.dart';

class AdminRequestsPage extends StatefulWidget {
  @override
  _AdminRequestsPageState createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  List<Map<String, dynamic>> requests = [
    {"name": "Ali Ahmed", "wilaya": "Algiers", "student": true, "status": "Pending", "pdfUploaded": true},
    {"name": "Sara Ben", "wilaya": "Oran", "student": false, "status": "Approved", "pdfUploaded": false},
    {"name": "Youssef Karim", "wilaya": "Constantine", "student": true, "status": "Rejected", "pdfUploaded": false},
    {"name": "Meriem Boudiaf", "wilaya": "Blida", "student": false, "status": "Pending", "pdfUploaded": false},
  ];

  String filter = "All"; // "All", "Pending", "History"

  void updateRequestStatus(int index, String status) {
    setState(() {
      requests[index]["status"] = status;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Request ${status.toLowerCase()} successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRequests = requests.where((request) {
      if (filter == "Pending") return request["status"] == "Pending";
      if (filter == "History") return request["status"] != "Pending";
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Subscription Requests", style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF578FCA)),
                  onPressed: () => setState(() => filter = "Pending"),
                  child: Text("Unread Requests", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF578FCA)),
                  onPressed: () => setState(() => filter = "History"),
                  child: Text("History", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredRequests.isEmpty
                ? Center(child: Text("No requests found!", style: TextStyle(color: Color(0xFF578FCA), fontSize: 18)))
                : ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      var request = filteredRequests[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        color: Colors.lightBlue.shade50,
                        child: ListTile(
                          leading: Icon(Icons.person, color: Color(0xFF578FCA)),
                          title: Text(request["name"], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF578FCA))),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Wilaya: ${request["wilaya"]}"),
                              Text("Type: ${request["student"] ? "Student (10% Discount)" : "Regular"}"),
                              Text("Status: ${request["status"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: request["status"] == "Pending"
                                          ? Colors.orange
                                          : request["status"] == "Approved"
                                              ? Colors.green
                                              : Colors.red)),
                              if (request["student"] && request["pdfUploaded"])
                                Row(
                                  children: [
                                    Icon(Icons.picture_as_pdf, color: Colors.red),
                                    Text(" Student ID Uploaded", style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                            ],
                          ),
                          trailing: request["status"] == "Pending"
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check, color: Colors.green),
                                      onPressed: () => updateRequestStatus(index, "Approved"),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, color: Colors.red),
                                      onPressed: () => updateRequestStatus(index, "Rejected"),
                                    ),
                                  ],
                                )
                              : null,
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
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Chat Feature Coming Soon!")),
          );
            Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllChatsPage()),
                      );
        },
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
