import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  
  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.3:5000/notifications/1'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          notifications = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load notifications");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

 
  Future<void> markAsRead(int index) async {
    int notificationId = notifications[index]["id"];
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.3:5000/notifications/$notificationId/read'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          notifications[index]["lu"] = 1; 
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<void> markAllAsRead() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.1.3:5000/notifications/1/read-all'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          for (var notification in notifications) {
            notification["lu"] = 1;
          }
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.day}-${parsedDate.month}-${parsedDate.year} ${parsedDate.hour}:${parsedDate.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF578FCA),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline),
            onPressed: markAllAsRead,
            tooltip: "Mark all as read",
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text("No notifications available"))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    return Card(
                      color: notification["lu"] == 1 ? Colors.lightBlue.shade100 : Colors.white,
                      child: ListTile(
                        leading: Icon(
                          notification["lu"] == 1 ? Icons.notifications_none : Icons.notifications_active,
                          color: Color(0xFF578FCA),
                        ),
                        title: Text("${notification["nom"]}", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF578FCA))),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification["message"]),
                            SizedBox(height: 5),
                            Text(formatDate(notification["date_envoi"]), style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: notification["lu"] == 1
                            ? null
                            : IconButton(
                                icon: Icon(Icons.check, color: Color(0xFF578FCA)),
                                onPressed: () => markAsRead(index),
                              ),
                      ),
                    );
                  },
                ),
    );
  }
}
