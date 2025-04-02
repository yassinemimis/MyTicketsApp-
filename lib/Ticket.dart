import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tram_app2/TramTicketScreenExpired.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'package:intl/intl.dart'; 
import 'package:flutter_svg/flutter_svg.dart';
class TramTicketScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  TramTicketScreen({required this.user});
  @override
  _TramTicketScreenState createState() => _TramTicketScreenState();
}

class _TramTicketScreenState extends State<TramTicketScreen> {
  bool isActive = true;
 bool isLoading = true; 
  String state = "";
  String? type_ticket;
  int nombre_passage = 1;
  String prenom = "";

  String code_ticket = "";
  String date_creation = "";
  String formattedDate = "";
  String formattedDateday = "";
  String price = "";
  void getLastActiveSubscription() async {
    try {
     
      final response = await http.get(Uri.parse(
          'http://192.168.1.3:5000/last-active-tickets/${widget.user['id']}'));

      if (response.statusCode == 200) {
       
        final responseData =
            jsonDecode(response.body); 

        print('Response Body: ${response.body}');
        print('Response Data: $responseData');

        
        if (responseData['data'] != null &&
            responseData['data'].containsKey('statut')) {
          setState(() {
          
            state = responseData['data']['state'];
            date_creation = responseData['data']['date_creation'];
            code_ticket = responseData['data']['code_ticket'];
            nombre_passage = responseData['data']['nombre_passage'];
            price = responseData['data']['total_price'];
            type_ticket = responseData['data']['type_ticket'];
            DateTime date = DateTime.parse(date_creation);

             formattedDateday = DateFormat('dd/MM/yyyy').format(date);
            formattedDate = DateFormat('HH:mm').format(date);
            print("$formattedDate ffffffff");

            isLoading = false; 
          });
        } else {
          throw Exception('Statut not found in response data');
        }
      } else {
        throw Exception('Failed to load subscription');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
      type_ticket = null;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLastActiveSubscription(); 
  }
  void showTicketDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedDateday,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue.shade100,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "Active",
                      style: TextStyle(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("State", style: TextStyle(fontSize: 20)),
                      Text(state,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Time", style: TextStyle(fontSize: 20)),
                      Text(formattedDate,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Passengers", style: TextStyle(fontSize: 20)),
                      Text("$nombre_passage",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15),

              
              Text("Id ticket", style: TextStyle(fontSize: 20)),
              Text(
                code_ticket,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

          
              Text("Total price", style: TextStyle(fontSize: 20)),
              Text(
                price,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF578FCA),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("OK",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "Tram Ticket",
          style: TextStyle(
              color: Colors.black,
              fontSize: screenWidth * 0.09,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body:isLoading
          ? CircularProgressIndicator()
          : type_ticket == null
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, 
                    crossAxisAlignment:
                        CrossAxisAlignment.center, 
                    children: [
                      Image.asset(
                  'assets/patterns/ticket.png',
                   height: screenHeight * 0.3,
                        width: screenWidth * 0.7,
                  fit: BoxFit.cover, 
                ),
                      SizedBox(height: screenWidth * 0.05),
              Text(
                'You currently don t have an active ticket',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
                      ElevatedButton(
                        onPressed: () {
                          
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          backgroundColor: const Color(0xFF578FCA),
                        ),
                        child: const Text(
                          "Buy now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
        child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.lightBlue[100],
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton("Active", isActive, () {
                      setState(() {});
                    }, screenWidth),
                    SizedBox(width: screenWidth * 0.02),
                    _buildToggleButton("Expired", !isActive, () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TramTicketScreenExpired(user: widget.user)),
                        );
                      });
                    }, screenWidth),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.lightBlue[100],
                height: screenHeight * 0.03,
              ),
              Container(
                width: double.infinity,
                height: screenHeight * 0.15,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: Color(0xFF578FCA),
                ),
                child: Center(
                  child: Text(
                    "Tram ticket",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  children: [
                    Text(
                      "Scan this code in\nbar code scanner",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth * 0.07),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      "Used once",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(height: 10),
                  buildDashedDivider(screenWidth),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHalfCircle(screenWidth, false),
                      _buildHalfCircle(screenWidth, true),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              QrImageView(
                data: code_ticket,
                version: QrVersions.auto,
                size: screenWidth * 0.5,
              ),
              Container(
                width: double.infinity,
                color: Colors.lightBlue[100],
                height: screenHeight * 0.03,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showTicketDetails(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF578FCA),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    ),
                  ),
                  child: Text(
                    'Ticket details',
                    style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ],
          ),
        ),
        ],
          ),
      ),
    );
  }

  Widget buildDashedDivider(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        (screenWidth * 0.4 ~/ 5),
        (index) => Container(
          width: 5,
          height: 1.5,
          margin: EdgeInsets.symmetric(horizontal: 3),
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildHalfCircle(double screenWidth, bool isLeft) {
    return Container(
      width: screenWidth * 0.06,
      height: screenWidth * 0.08,
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: isLeft
            ? BorderRadius.horizontal(left: Radius.circular(screenWidth * 0.04))
            : BorderRadius.horizontal(
                right: Radius.circular(screenWidth * 0.04)),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected,
      VoidCallback onPressed, double screenWidth) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.025,
          horizontal: screenWidth * 0.119,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(screenWidth * 0.09),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
