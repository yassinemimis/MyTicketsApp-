import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool isNotificationsEnabled = true;
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF578FCA),
        title: Text("Settings"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // الوضع الليلي
          _buildSettingItem(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              activeColor: Color(0xFF578FCA),
            ),
          ),

          // الإشعارات
          _buildSettingItem(
            icon: Icons.notifications,
            title: "Notifications",
            trailing: Switch(
              value: isNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
              activeColor: Color(0xFF578FCA),
            ),
          ),

          // اللغة
          _buildSettingItem(
            icon: Icons.language,
            title: "Language",
            trailing: DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
              },
              items: ["English", "Français", "العربية"]
                  .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                  .toList(),
            ),
          ),

          // الخصوصية
          _buildSettingItem(
            icon: Icons.lock,
            title: "Privacy Settings",
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
            onTap: () {
              // فتح صفحة الخصوصية
            },
          ),

          SizedBox(height: 20),

          // زر تسجيل الخروج
          Center(
            child: ElevatedButton(
              onPressed: () {
                // تنفيذ عملية تسجيل الخروج
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Sign Out", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت لإعدادات الصفوف
  Widget _buildSettingItem({required IconData icon, required String title, Widget? trailing, VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFF578FCA)),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
