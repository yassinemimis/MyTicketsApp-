import 'package:flutter/material.dart';

class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsPageState createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  List<Map<String, dynamic>> chatList = [
    {"name": "John Doe", "lastMessage": "Hello, I need help!", "time": "10:30 AM", "unread": true},
    {"name": "Alice Smith", "lastMessage": "Thanks for the support!", "time": "09:45 AM", "unread": false},
    {"name": "Bob Johnson", "lastMessage": "How can I renew my subscription?", "time": "Yesterday", "unread": true},
    {"name": "Emma Brown", "lastMessage": "I'll upload my student card soon.", "time": "Yesterday", "unread": false},
    {"name": "John Doe", "lastMessage": "Hello, I need help!", "time": "10:30 AM", "unread": true},
    {"name": "Alice Smith", "lastMessage": "Thanks for the support!", "time": "09:45 AM", "unread": false},
    {"name": "Bob Johnson", "lastMessage": "How can I renew my subscription?", "time": "Yesterday", "unread": true},
    {"name": "Emma Brown", "lastMessage": "I'll upload my student card soon.", "time": "Yesterday", "unread": false},
    {"name": "John Doe", "lastMessage": "Hello, I need help!", "time": "10:30 AM", "unread": true},
    {"name": "Alice Smith", "lastMessage": "Thanks for the support!", "time": "09:45 AM", "unread": false},
    {"name": "Bob Johnson", "lastMessage": "How can I renew my subscription?", "time": "Yesterday", "unread": true},
    {"name": "Emma Brown", "lastMessage": "I'll upload my student card soon.", "time": "Yesterday", "unread": false},
    {"name": "John Doe", "lastMessage": "Hello, I need help!", "time": "10:30 AM", "unread": true},
    {"name": "Alice Smith", "lastMessage": "Thanks for the support!", "time": "09:45 AM", "unread": false},
    {"name": "Bob Johnson", "lastMessage": "How can I renew my subscription?", "time": "Yesterday", "unread": true},
    {"name": "Emma Brown", "lastMessage": "I'll upload my student card soon.", "time": "Yesterday", "unread": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Chats", style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Color(0xFF578FCA),
        actions: [
          IconButton(
            icon: Icon(Icons.search, 
            color: Colors.white,
           
          ),
            onPressed: () {
              // إضافة ميزة البحث لاحقًا
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue.shade200,
              child: Text(chatList[index]["name"][0], style: TextStyle(color: Colors.white)),
            ),
            title: Text(chatList[index]["name"], style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chatList[index]["lastMessage"]),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(chatList[index]["time"], style: TextStyle(color: Colors.grey)),
                if (chatList[index]["unread"])
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
          );
        },
      ),
    );
  }
}
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [
    {"sender": "User", "message": "Hello, I need help with my subscription.", "time": "10:30 AM"},
    {"sender": "Admin", "message": "Sure! What issue are you facing?", "time": "10:32 AM"},
    {"sender": "User", "message": "I uploaded my student card but still pending.", "time": "10:35 AM"},
    {"sender": "Admin", "message": "We will check it and get back to you soon!", "time": "10:37 AM"},
  ];

  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({"sender": "Admin", "message": messageController.text, "time": "Now"});
      });
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Support", style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isAdmin = messages[index]["sender"] == "Admin";
                return Align(
                  alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isAdmin ? Colors.lightBlue.shade200 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          messages[index]["message"],
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          messages[index]["time"],
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  backgroundColor: Color(0xFF578FCA),
                  onPressed: sendMessage,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
