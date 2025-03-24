import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tram_app2/Ticket.dart';



class TramTicketScreenExpired extends StatefulWidget {
  @override
  _TramTicketScreenState createState() => _TramTicketScreenState();
}

class _TramTicketScreenState extends State<TramTicketScreenExpired> {
  bool isActive = false;


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
      body: SingleChildScrollView(
  child: Container(
         decoration: BoxDecoration(
        color: Colors.lightBlue[100],),
        child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // توسيط العنصر أفقيًا
    children: [
      Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color:   Colors.lightBlue[100],
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
                      setState(() {
                       
    //                           Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => TramTicketScreen(user: widget)),
    // );
                      });
                    }, screenWidth),
                    SizedBox(width: screenWidth * 0.02),
                    _buildToggleButton("Expired", !isActive, () {
                      setState(() {
                   
                      });
                    }, screenWidth),
                  ],
                ),
              ),
              Container(
                child: Column(children: [
  _Card(screenWidth,screenHeight,"March 18, 2025","Oran","16:30",1,"2-9097-0115-5487-5375",40),
         _Card(screenWidth,screenHeight,"March 18, 2025","Oran","16:30",1,"2-9097-0115-5487-5375",40),
          _Card(screenWidth,screenHeight,"March 18, 2025","Oran","16:30",1,"2-9097-0115-5487-5375",40),
                ],),
              )
            
            ],
          ),
        ),
         ],
          ),
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
  Widget _Card(double screenWidth,double screenHeight,String date,String state,String time,int passa,String id_ticket,int price) {
    
    return   Container(
 margin: EdgeInsets.only(top: screenHeight * 0.03),
  decoration: BoxDecoration(
    color: Colors.blue.shade100,
  
  ),
          child:  Container(
 padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color.fromARGB(255, 255, 255, 255),
  
           borderRadius: BorderRadius.circular(25),
  ),child: 
           Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                    child: Text(
                      "Expired",
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
                      Text(state,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Time", style: TextStyle(fontSize: 20)),
                      Text("$time",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("Passengers", style: TextStyle(fontSize: 20)),
                      Text("$passa",
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
                id_ticket,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // السعر
              Text("Total price", style: TextStyle(fontSize: 20)),
              Text(
                 "$price DZ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

            
            ],
          ),
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
