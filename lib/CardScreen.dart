import 'package:tram_app2/TramCardScreen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:flutter_svg/flutter_svg.dart';

class CardScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  CardScreen({required this.user});
  @override
  _CardScreen createState() => _CardScreen();
}

class _CardScreen extends State<CardScreen> {
  String? subscriptionStatus;
  bool isLoading = true; 
  String state = "";
  String nom = "";
  String prenom = "";
  String type = "";
  String code = "";
  String dateString = "";
  String formattedDate = "";

  void getLastActiveSubscription() async {
    try {
     
      final response = await http.get(Uri.parse(
          'http://192.168.1.3:5000/last-active-subscription/${widget.user['id']}'));

      if (response.statusCode == 200) {
       
        final responseData =
            jsonDecode(response.body); 

      
        print('Response Body: ${response.body}');
        print('Response Data: $responseData');

   
        if (responseData['data'] != null &&
            responseData['data'].containsKey('statut')) {
          setState(() {
            subscriptionStatus = responseData['data']
                ['statut'];
            state = responseData['data']['state'];
            type = responseData['data']['subscription_type'];
            code = responseData['data']['code_card'];
            dateString = responseData['data']['date_fin'];

           
            DateTime date = DateTime.parse(dateString);

        
            formattedDate = DateFormat('dd/MM/yyyy').format(date);

            print("Subscription Status: $subscriptionStatus");
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
        subscriptionStatus = null; 
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLastActiveSubscription(); 
  }

  void showTicketDetails(
      BuildContext context, double screenHeight, double screenWidth) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Tram Card",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: QrImageView(
                  data: code,
                  version: QrVersions.auto,
                  size: screenWidth * 0.5,
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF578FCA),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
    int x = 0;
    return Scaffold(
      appBar: AppBar(
     
        backgroundColor: Color(0xFF578FCA),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Tram Card",
          style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: screenWidth * 0.09,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : subscriptionStatus == null
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, 
                    crossAxisAlignment:
                        CrossAxisAlignment.center, 
                    children: [
                      SvgPicture.asset(
                        'assets/patterns/card.svg', 
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.7,
                      ),
                      SizedBox(height: screenWidth * 0.05),
              Text(
                'You currently don t have an active subscription',
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
                          "Subscribe now",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlipTramCard(user: widget.user,code: code,),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Expiration Date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Expiration Date",
                                        style: TextStyle(fontSize: 18)),
                                    Text(formattedDate,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: x == 1
                                        ? Colors.grey[300]
                                        : Colors.lightBlue[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    x == 1 ? "Expired" : "Active",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 12),

                            // State
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("State",
                                        style: TextStyle(fontSize: 18)),
                                    Text(state,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.user['nom']}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text("${widget.user['prenom']}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                         
                            Text("Subscription Type",
                                style: TextStyle(fontSize: 18)),
                            Text(type,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 12),

                          
                            Text("Id ticket", style: TextStyle(fontSize: 18)),
                            Text(code,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 12),

                           
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showTicketDetails(
                                context, screenHeight, screenWidth);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            backgroundColor: const Color(0xFF578FCA),
                          ),
                          child: const Text(
                            "Show QR Code",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
