import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [
    {"title": "Subscription Approved", "message": "Your student subscription has been approved!", "isRead": false},
    {"title": "Payment Successful", "message": "Your tram ticket purchase was successful.", "isRead": true},
    {"title": "Reminder", "message": "Your subscription will expire in 3 days.", "isRead": false},
  ];

  void markAsRead(int index) {
    setState(() {
      notifications[index]["isRead"] = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification["isRead"] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications",style: TextStyle(color:Color.fromARGB(255, 255, 255, 255))),
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
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          var notification = notifications[index];
          return Card(
            color: notification["isRead"] ? Colors.lightBlue.shade100 : Colors.white,
            child: ListTile(
              leading: Icon(
                notification["isRead"] ? Icons.notifications_none : Icons.notifications_active,
                color: Color(0xFF578FCA),
              ),
              title: Text(notification["title"], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF578FCA))),
              subtitle: Text(notification["message"]),
              trailing: notification["isRead"]
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
