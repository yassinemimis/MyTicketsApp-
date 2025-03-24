import 'package:flutter/material.dart';
import 'package:tram_app2/Change_Password.dart';
import 'package:tram_app2/Payment_Methods.dart';
import 'package:tram_app2/Personal_Data.dart';
import 'package:tram_app2/SettingsScreen.dart';

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
                        backgroundImage: NetworkImage(
                            'https://media.licdn.com/dms/image/v2/D4E03AQH6F13n0KOofg/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1699315717040?e=1747872000&v=beta&t=fEkLrHOVCnuhe5NRrMx6hEO4wBAIgEuhoRRSPamqlqM'),
                      ),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt,
                            color: Color(0xFF3674B5), size: 20),
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
                  MaterialPageRoute(builder: (context) => PersonalDataScreen()),
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

// ويدجت عنصر القائمة
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap; // ✅ إضافة onTap كـ Callback

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
        // ✅ لجعل العنصر قابلاً للنقر
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
