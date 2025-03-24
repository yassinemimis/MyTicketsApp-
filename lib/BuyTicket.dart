import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tram_app2/SuccessPageBuy.dart';

class TicketPurchasePage extends StatefulWidget {
  final Map<String, dynamic> user;

  TicketPurchasePage({required this.user});
  @override
  _TicketPurchasePageState createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends State<TicketPurchasePage> {
  final List<String> destinations = ["Algiers", "Oran", "Constantine", "Ouargla" ,"Sétif" , "Sidi Bel Abbès" , "Mostaganem"];
  final List<String> ticketTypes = ["Regular", "Student", "Senior"];

  String? selectedDestination;
  String? selectedTicketType;
  int ticketCount = 1;
  double ticketPrice = 2.5;
  bool shareTicket = false;
  TextEditingController _idController = TextEditingController();
  Future<List<Map<String, dynamic>>> fetchUsers(String query) async {
    if (query.isEmpty) return []; // إذا كان الحقل فارغاً لا نبحث

    final response = await http
        .get(Uri.parse('http://192.168.1.2:5000/search-user?query=$query'));

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } catch (e) {
        print("Error parsing JSON: $e");
        throw Exception("Invalid JSON response");
      }
    } else {
      throw Exception("Failed to load users");
    }
  }

  List<Map<String, dynamic>> searchResults = [];

  void _onSearch(String query) async {
    print("Searching for: $query");
    if (query.isEmpty) {
      setState(() => searchResults = []);
      return;
    }

    try {
      List<Map<String, dynamic>> results = await fetchUsers(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> buyTicket() async {
    if (selectedDestination == null || selectedTicketType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select all options!")),
      );
      return;
    }

    final url = Uri.parse("http://192.168.1.2:5000/buy-ticket");
    final body = jsonEncode({
      "user_id": widget.user['id'],
      "nombre_passage": ticketCount,
      "total_price": ticketCount * ticketPrice,
      "state": selectedDestination,
      "share_ticket": shareTicket ? _idController.text : null,
      "type_ticket": selectedTicketType
    });
    print(widget.user['user_id']);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["message"])),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: ${responseData['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Failed to connect to server!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF578FCA),
        title: Text(
          "Buy Tram Ticket",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Destination",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: selectedDestination,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: destinations.map((destination) {
                  return DropdownMenuItem(
                      value: destination, child: Text(destination));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedDestination = value);
                },
              ),
              SizedBox(height: 20),
              Text("Select Ticket Type",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: selectedTicketType,
                decoration: InputDecoration(border: OutlineInputBorder()),
                items: ticketTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedTicketType = value);
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Number of Tickets",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.remove,
                          color: Color(0xFF578FCA),
                        ),
                        onPressed: () {
                          if (ticketCount > 1) {
                            setState(() => ticketCount--);
                          }
                        },
                      ),
                      Text("$ticketCount", style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Color(0xFF578FCA),
                        ),
                        onPressed: () {
                          setState(() => ticketCount++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                  "Total Price: \$${(ticketCount * ticketPrice).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF578FCA),
                  )),
              SizedBox(height: 20),
              Container(
                color: Colors.lightBlue.shade50,
                child: SwitchListTile(
                  title: Text(
                    "Share Ticket",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  value: shareTicket,
                  onChanged: (value) {
                    setState(() {
                      shareTicket = value;
                    });
                  },
                  activeColor: Color(0xFF578FCA),
                ),
              ),
              if (shareTicket) ...[
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: "Enter Recipient ID",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: _onSearch,
                ),
                if (searchResults.isNotEmpty)
                  Container(
                    height: 200,
                    color: Colors.lightBlue.shade50,
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final user = searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF578FCA),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            "${user['nom'] ?? 'N/A'} ${user['prenom'] ?? ''}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            "ID: ${user['id'] ?? 'N/A'}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.grey),
                          onTap: () {
                            if (user['id'] != null) {
                              _idController.text =
                                  (user['id'] ?? "").toString();
                              setState(() => searchResults = []);
                            } else {
                              print("Error: User ID is null");
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF578FCA),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: buyTicket,
                  child: Text("Buy Ticket",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
