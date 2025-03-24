import 'package:flutter/material.dart';


class PersonalDataScreen extends StatelessWidget {
  @override
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
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
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
                        backgroundImage:  NetworkImage('https://media.licdn.com/dms/image/v2/D4E03AQH6F13n0KOofg/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1699315717040?e=1747872000&v=beta&t=fEkLrHOVCnuhe5NRrMx6hEO4wBAIgEuhoRRSPamqlqM'),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, color: Color(0xFF3674B5), size: 20),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Kherbouche Yassie", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("yassinekherbouche88@gmail.com", style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),

            SizedBox(height: 20),

            // حقول البيانات
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomTextField(label: "Full Name", hint: "Kherbouche Yassie"),
                  CustomTextField(label: "Email", hint: "exemple@gmail.com"),
                  CustomTextField(label: "Phone Number", hint: "+123 456 789"),
                  CustomTextField(label: "Address", hint: "123 Street, City, Country"),
                  
                  SizedBox(height: 20),

                  // زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF578FCA),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text("Save Changes", style: TextStyle(fontSize: 18, color: Colors.white)),
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

  CustomTextField({required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
          SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
