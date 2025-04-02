import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tram_app2/AllChatsPage.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminRequestsPage extends StatefulWidget {
  @override
  _AdminRequestsPageState createState() => _AdminRequestsPageState();
}

class _AdminRequestsPageState extends State<AdminRequestsPage> {
  List<Map<String, dynamic>> requests = [];
  String filter = "All";

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    final response = await http
        .get(Uri.parse('http://192.168.1.3:5000/pending-abonnements'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        requests = data
            .map((item) => {
                  "id_ab": item["id_ab"],
                  "name": "${item["nom"]} ${item["prenom"]}",
                  "wilaya": item["state"],
                  "student": item["subscription_type"] == "student",
                  "status": item["validation"],
                  "pdfUrl": item["student_id_path"]
                })
            .toList();
      });
    }
  }

  Future<void> updateRequestStatus(int? id, String status) async {
    if (id == null) {
      print("⚠ Error: Cannot send null as id");

      return;
    }

    final response = await http.put(
      Uri.parse('http://192.168.1.3:5000/update-abonnement/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"validation": status.toLowerCase()}),
    );

    if (response.statusCode == 200) {
      await fetchRequests();
      setState(() {
        var request = requests.firstWhere(
          (req) => req["id_ab"] == id,
          orElse: () => {},
        );
        if (request.isNotEmpty) {
          request["validation"] = status;
        } else {
        print("⚠ Request not found in the list.");
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request $status successfully!")),
      );
    }
  }

  void openPdf(String fileName) async {
    final Uri pdfUrl = Uri.parse("http://192.168.1.3:5000/uploads/$fileName");

    if (await canLaunchUrl(pdfUrl)) {
      await launchUrl(pdfUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredRequests = requests.where((request) {
      if (filter == "Pending") return request["status"] == "pending";
      if (filter == "History") return request["status"] != "pending";
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Subscription Requests",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF578FCA)),
                  onPressed: () => setState(() => filter = "Pending"),
                  child: Text("Unread Requests",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF578FCA)),
                  onPressed: () => setState(() => filter = "History"),
                  child: Text("History", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredRequests.isEmpty
                ? Center(
                    child: Text("No requests found!",
                        style:
                            TextStyle(color: Color(0xFF578FCA), fontSize: 18)))
                : ListView.builder(
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      var request = filteredRequests[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        color: Colors.lightBlue.shade50,
                        child: ListTile(
                          leading: Icon(Icons.person, color: Color(0xFF578FCA)),
                          title: Text(request["name"],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF578FCA))),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Wilaya: ${request["wilaya"]}"),
                              Text(
                                  "Type: ${request["student"] ? "Student (10% Discount)" : "Regular"}"),
                              Text("Status: ${request["status"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: request["status"] == "pending"
                                          ? Colors.orange
                                          : request["status"] == "approved"
                                              ? Colors.green
                                              : Colors.red)),
                              if (request["student"] &&
                                  request["pdfUrl"] != null)
                                GestureDetector(
                                  onTap: () => openPdf(request["pdfUrl"]),
                                  child: Row(
                                    children: [
                                      Icon(Icons.picture_as_pdf,
                                          color: Colors.red),
                                      GestureDetector(
                                        onTap: () {
                                          if (request["pdfUrl"] != null) {
                                            openPdf(request["pdfUrl"]!);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "No PDF available!")),
                                            );
                                          }
                                        },
                                        child: Text(" Student ID Uploaded",
                                            style: TextStyle(
                                                color: Colors.red,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          trailing: request["status"] == "pending"
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () {
                                        if (request["id_ab"] != null) {
                                          updateRequestStatus(
                                              request["id_ab"], "approved");
                                        } else {
                                       print("⚠ Error: `id_ab` is missing or null");
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        print("📌 Data: $request");

                                        if (request["id_ab"] != null) {
                                          updateRequestStatus(
                                              request["id_ab"], "rejected");
                                        } else {
                                         print("⚠ Error: `id` is missing or null");
                                        }
                                      },
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
