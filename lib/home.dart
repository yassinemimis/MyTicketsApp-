import 'package:flutter/material.dart';
import 'package:tram_app2/AllChatsPage.dart';
import 'package:tram_app2/BuyTicket.dart';
import 'package:tram_app2/BuyTramOptionsPage.dart';
import 'package:tram_app2/CardScreen.dart';
import 'package:tram_app2/ChatPage1.dart';
import 'package:tram_app2/NotificationsPage.dart';
import 'package:tram_app2/SubscriptionPage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tram_app2/Ticket.dart';
import 'package:tram_app2/TouristPlacesPage.dart';
import 'package:tram_app2/profil.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> user;

  Home({required this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Duration duration = Duration();
  int _selectedIndex = 0;
  late Timer timer;
  Timer? _timer;
  int _unreadCount = 0; 
  
  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchUnreadCount();
    });
  }
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TramTicketScreen(user: widget.user),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  userId: "5",
                  receiverId: "4",
                )),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TouristPlacesPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
      fetchUnreadCount();
    updateTimeRemaining();
    startTimer();
    _startAutoRefresh(); 
  }
Future<void> fetchUnreadCount() async {
    final url = Uri.parse("http://192.168.1.3:5000/notifications/1/unread-count");
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _unreadCount = data["unread_count"];
        });
      }
    } catch (e) {
      print(" Error fetching unread notifications: $e");
    }
  }
  void updateTimeRemaining() {
    DateTime now = DateTime.now();
    DateTime targetTime = DateTime(now.year, now.month, now.day, 22, 0, 0);

    if (now.isAfter(targetTime)) {
      targetTime = targetTime.add(Duration(days: 1));
    }

    setState(() {
      duration = targetTime.difference(now);
    });
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration.inSeconds > 0) {
        setState(() {
          duration = duration - Duration(seconds: 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
     _timer?.cancel();
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  @override
  Widget build(BuildContext context) {
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.04),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Hello,\n${widget.user['nom']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32, 
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow
                            .ellipsis, 
                      ),
                    ),
                    Spacer(),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationsPage()),
                            );
                          },
                          child: Icon(
                            Icons.notifications,
                            color: Color(0xFF578FCA),
                            size: 40, 
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              "$_unreadCount", 
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10), 
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: widget.user),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: screenWidth * 0.08, 
                        backgroundImage: widget.user['photo_profil'] != null &&
                                widget.user['photo_profil'].isNotEmpty
                            ? NetworkImage(
                                'http://192.168.1.3:5000/uploads/${widget.user['photo_profil']}')
                            : null,
                        child: (widget.user['photo_profil'] == null ||
                                widget.user['photo_profil'].isEmpty)
                            ? Icon(Icons.account_circle,
                                size: screenWidth * 0.08, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.137),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      width: double.infinity,
                      height: screenHeight * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.1),
                          Text(
                            "Buy tickets",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Container(
                            child: Column(
                              children: [
                                TramOptionCard(
                                  title: "Buy Tram Ticket",
                                  description:
                                      "Purchase a single tram ticket for your trip.",
                                  icon: Icons.confirmation_number,
                                  color: Color(0xFF578FCA),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TicketPurchasePage(
                                                  user: widget.user)),
                                    );
                                  },
                                ),
                                SizedBox(height: 20),
                                TramOptionCard(
                                  title: "Buy Tram Card",
                                  description:
                                      "Get a rechargeable tram card for frequent use.",
                                  icon: Icons.credit_card,
                                  color: Color(0xFF3674B5),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SubscriptionPage(
                                                  user: widget.user)),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      )),
                  Positioned(
                    top: -screenHeight * 0.07,
                    left: screenWidth * 0.08,
                    right: screenWidth * 0.08,
                    child: Container(
                      height: screenHeight * 0.15,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3674B5), Color(0xFF578FCA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_transit,
                              color: Colors.white, size: 45),
                          SizedBox(width: 8),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Tram closes after",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  buildTimeColumn(hours, "Hours"),
                                  SizedBox(width: 8),
                                  buildTimeColumn(minutes, "Minutes"),
                                  SizedBox(width: 8),
                                  buildTimeColumn(seconds, "Seconds"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Container(
            height: screenHeight * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.confirmation_number, "", 1),
                SizedBox(width: 48),
                _buildNavItem(Icons.message, "", 2),
                _buildNavItem(Icons.travel_explore, "", 3),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CardScreen(user: widget.user)),
            );
          },
          backgroundColor: Color(0xFF578FCA),
          elevation: 5,
          child: Icon(Icons.card_membership, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget buildTimeColumn(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color:
                _selectedIndex == index ? Color(0xFF578FCA) : Colors.blueGrey,
            size: 30,
          ),
          if (label.isNotEmpty)
            Text(label,
                style: TextStyle(
                    color: _selectedIndex == index
                        ? Color(0xFF578FCA)
                        : Colors.blueGrey,
                    fontSize: 16))
        ],
      ),
    );
  }
}

class TramOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  TramOptionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
