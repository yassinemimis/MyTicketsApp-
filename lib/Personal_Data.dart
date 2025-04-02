import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PersonalDataScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  PersonalDataScreen({required this.user});

  @override
  _PersonalDataScreen createState() => _PersonalDataScreen();
}

class _PersonalDataScreen extends State<PersonalDataScreen> {

late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      setState(() {
        _image = selectedImage;
      });


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

  Future<void> updateUser(int userId ) async {
    final url = Uri.parse('http://192.168.1.3:5000/api/users/$userId');

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nom": nomController.text,
        "prenom": prenomController.text,
        "email": emailController.text,
        "phone": phoneController.text,
        "address": addressController.text,
      }),
    );

    if (response.statusCode == 200) {
      print("User updated successfully");
    } else {
      print("Error: ${response.body}");
    }
  }

  @override
   void initState() {
    super.initState();
    

    nomController = TextEditingController(text: widget.user['nom']);
    prenomController = TextEditingController(text: widget.user['prenom']);
    emailController = TextEditingController(text: widget.user['email']);
    phoneController = TextEditingController(text: widget.user['phone'] ?? '');
    addressController = TextEditingController(text: widget.user['address'] ?? '');
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF578FCA),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF578FCA),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: EdgeInsets.only(top: 30, bottom: 20),
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
                        onBackgroundImageError: (error, stackTrace) {},
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

            SizedBox(height: 20),

            // حقول البيانات
            Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
           CustomTextField(label: "First Name", hint: "${widget.user['nom']}", controller: nomController),
CustomTextField(label: "Last Name", hint: "${widget.user['prenom']}", controller: prenomController),
CustomTextField(label: "Email", hint: "${widget.user['email']}", controller: emailController),
CustomTextField(label: "Phone Number", hint: "+123 456 789", controller: phoneController),
CustomTextField(label: "Address", hint: "123 Street, City, Country", controller: addressController),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){updateUser(widget.user['id']);}, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF578FCA),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
                child: Text("Save Changes",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
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
}

// ويدجت لحقل النصوص
class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
