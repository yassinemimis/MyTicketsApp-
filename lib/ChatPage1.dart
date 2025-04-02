import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage1 extends StatefulWidget {
  final String userId; 
  final String receiverId; 

  ChatPage1({required this.userId, required this.receiverId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage1> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;
 ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    connectSocket();
    fetchMessages();
  }

  void connectSocket() {
    socket = IO.io('http://192.168.1.3:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.emit("join", widget.userId);

    socket.on("newMessage", (data) {
      if (mounted) {
        setState(() {
          messages.add({
            "sender_id": data["sender_id"],
            "message": data["contenu"],
            "time": "Now"
          });
        });
      }
    });
  }

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.3:5000/messages/${widget.userId}/${widget.receiverId}'));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedMessages = json.decode(response.body);
      setState(() {
        messages = fetchedMessages.map((msg) {
          return {
            "sender_id": msg["sender_id"],
            "message": msg["contenu"],
            "time": msg["date_envoi"].toString().substring(11, 16),
          };
        }).toList();
      });
       WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    }
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      final newMessage = {
        "sender_id": widget.userId,
        "receiver_id": widget.receiverId,
        "contenu": messageController.text
      };

      final response = await http.post(
        Uri.parse('http://192.168.1.3:5000/sendMessage'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(newMessage),
      );

      if (response.statusCode == 200) {
        setState(() {
          messages.add({
            "sender_id": widget.userId,
            "message": messageController.text,
            "time": "Now"
          });
        });
        messageController.clear();
      }
       WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    }
  }
void _scrollToBottom() {
  Future.delayed(Duration(milliseconds: 300), () {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Support"),
        backgroundColor: Color(0xFF578FCA),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
               controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isCurrentUser = messages[index]["sender_id"].toString() == widget.userId.toString();
                return Align(
                  alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isCurrentUser ? Colors.lightBlue.shade200 : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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