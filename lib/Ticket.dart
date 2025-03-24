import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tram_app2/TramTicketScreenExpired.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // لتحويل الاستجابة من JSON
import 'package:intl/intl.dart'; // تأكد من استيراد مكتبة intl
import 'package:flutter_svg/flutter_svg.dart';
class TramTicketScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  TramTicketScreen({required this.user});
  @override
  _TramTicketScreenState createState() => _TramTicketScreenState();
}

class _TramTicketScreenState extends State<TramTicketScreen> {
  bool isActive = true;
 bool isLoading = true; // لتحديد ما إذا كان التطبيق في حالة تحميل
  String state = "";
  String nom = "";
  String prenom = "";
  String type = "";
  String code = "";
  String dateString = "";
  String formattedDate = "";
  // دالة لجلب البيانات من API
  void getLastActiveSubscription() async {
    try {
      // إرسال طلب GET إلى API
      final response = await http.get(Uri.parse(
          'http://192.168.1.2:5000/last-active-subscription/${widget.user['id']}'));

      if (response.statusCode == 200) {
       
        final responseData =
            jsonDecode(response.body); 

        print('Response Body: ${response.body}');
        print('Response Data: $responseData');

        // الوصول إلى البيانات داخل "data"
        if (responseData['data'] != null &&
            responseData['data'].containsKey('statut')) {
          setState(() {
          
            state = responseData['data']['state'];
            type = responseData['data']['subscription_type'];
            code = responseData['data']['code_card'];
            dateString = responseData['data']['date_fin'];

            // تحويل السلسلة النصية إلى كائن DateTime
            DateTime date = DateTime.parse(dateString);

            // تنسيق التاريخ بالشكل الذي تريده (يوم/شهر/سنة)
            formattedDate = DateFormat('dd/MM/yyyy').format(date);


            isLoading = false; // تحديد أن البيانات تم تحميلها
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
      
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLastActiveSubscription(); // استدعاء الدالة عند تحميل الواجهة
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
              // التاريخ + الحالة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "March 18, 2025",
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

              // معلومات التذكرة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text("State", style: TextStyle(fontSize: 20)),
                      Text("Oran",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Time", style: TextStyle(fontSize: 20)),
                      Text("16:30",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Passengers", style: TextStyle(fontSize: 20)),
                      Text("1",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 15),

              // رقم التذكرة
              Text("Id ticket", style: TextStyle(fontSize: 20)),
              Text(
                "2-9097-0115-5487-5375",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // السعر
              Text("Total price", style: TextStyle(fontSize: 20)),
              Text(
                "30 DZ",
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
      body: Container(
        child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // توسيط العنصر أفقيًا
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
                              builder: (context) => TramTicketScreenExpired()),
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
                      "valid 1 day",
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
                data: "https://your-ticket-data.com",
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
