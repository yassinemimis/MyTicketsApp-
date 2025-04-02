import 'package:flutter/material.dart';
import 'package:tram_app2/Change_Password.dart';
import 'package:tram_app2/Payment_Methods.dart';
import 'package:tram_app2/Personal_Data.dart';
import 'package:tram_app2/SettingsScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {});
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      setState(() {
        _image = selectedImage;
      });

      // رفع الصورة بعد اختيارها
      await updateProfileImage(selectedImage, widget.user['id']);
    }
  }

  
  Future<void> updateProfileImage(File imageFile, int userId) async {
    var request = http.MultipartRequest(
      "PUT",
      Uri.parse("http://192.168.1.3:5000/update-photo/$userId"),
    );

    var pic = await http.MultipartFile.fromPath("photo_profil", imageFile.path);
    request.files.add(pic);

    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image updated successfully");
    } else {
      print("Image update failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF3674B5),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: EdgeInsets.only(top: 50, bottom: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _image != null
                            ? FileImage(_image!) as ImageProvider
                            : NetworkImage(
                                'http://192.168.1.3:5000/uploads/${widget.user['photo_profil']}',
                              ),
                        onBackgroundImageError: (error, stackTrace) {
                          
                        },
                        child: _image == null &&
                                (widget.user['photo_profil'] == null ||
                                    widget.user['photo_profil'].isEmpty)
                            ? Icon(Icons.account_circle,
                                size: 50, color: Colors.blue)
                            : null,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.camera_alt,
                              color: Color(0xFF3674B5), size: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("${widget.user['nom']} ${widget.user['prenom']}",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text("${widget.user['email']} ",
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),

            // القائمة
            SizedBox(height: 20),
            ProfileMenuItem(
              icon: Icons.person,
              text: "Personal Data",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PersonalDataScreen(user: widget.user)),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.credit_card,
              text: "Payment Methods",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentMethodsScreen()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.settings,
              text: "Settings",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.lock,
              text: "Change Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              },
            ),
            ProfileMenuItem(
              icon: Icons.exit_to_app,
              text: "Sign out",
              color: Colors.red,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}


class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap; 

  ProfileMenuItem(
      {required this.icon,
      required this.text,
      this.color = Colors.black,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
    
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(icon, color: Colors.black),
            ),
            title: Text(text, style: TextStyle(fontSize: 18, color: color)),
            trailing:
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ),
        ),
      ),
    );
  }
}
