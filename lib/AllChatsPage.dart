import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsPageState createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  List<Map<String, dynamic>> chatList = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchChatList();
  }

  Future<void> fetchChatList() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.3:5000/api/conversations/4'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          chatList = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print("Failed to load chat list: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching chat list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Chats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF578FCA),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
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
              child: Text(chatList[index]["nom"][0],
                  style: TextStyle(color: Colors.white)),
            ),
            title: Text(
              "${chatList[index]["nom"]} ${chatList[index]["prenom"]}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(chatList[index]["lastMessage"]),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.Hm().format(
                      DateTime.parse(chatList[index]["lastMessageTime"])),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(userId: "4", receiverId: chatList[index]["id"].toString(),),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



class ChatPage extends StatefulWidget {
  final String userId;
  final String receiverId;

  ChatPage({required this.userId, required this.receiverId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;
  ScrollController _scrollController = ScrollController();
  Timer? _timer; 

  @override
  void initState() {
    super.initState();
    connectSocket();
    fetchMessages();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        fetchMessages();
      }
    });
  }

  void connectSocket() {
    socket = IO.io('http://192.168.1.3:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnect': true,
    });

    socket.onConnect((_) {
      print("Connected to Socket.io Server");
      socket.emit("join", widget.userId);
    });

    socket.onDisconnect((_) {
      print("Disconnected! Trying to reconnect...");
      socket.connect();
    });

    socket.on("newMessage", (data) {
      print("📩 New message received: $data");
      if (mounted) {
        setState(() {
          messages.add({
            "sender_id": data["sender_id"],
            "message": data["contenu"],
            "time": data["date_envoi"].toString().substring(11, 16),
          });
        });
        _scrollToBottom();
      }
    });

    socket.onError((error) {
      print("Socket error: $error");
    });

    socket.onConnectError((error) {
      print("Socket connection error: $error");
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

      _scrollToBottom();
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
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    _timer?.cancel(); 
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
