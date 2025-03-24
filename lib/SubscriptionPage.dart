import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class SubscriptionPage extends StatefulWidget {
  final Map<String, dynamic> user;
   SubscriptionPage({required this.user});
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String? selectedWilaya;
  String? selectedSubscriptionType;
  String? selectedDuration;
  bool isStudent = false;
  double basePrice = 100.0;
  double studentDiscount = 0.1;
  String? uploadedFileName;

  final List<String> wilayas = ["Algiers", "Oran", "Constantine"];
  final List<String> subscriptionTypes = ["regular", "student"];
  final List<String> durations = ["1 Month", "3 Months", "6 Months", "1 Year"];

  double calculatePrice() {
    double price = basePrice;
    if (selectedDuration == "3 Months") price *= 2.5;
    if (selectedDuration == "6 Months") price *= 4.5;
    if (selectedDuration == "1 Year") price *= 8.5;

    if (isStudent) {
      price *= (1 - studentDiscount); // خصم 10% للطلاب
    }
    return price;
  }

  void uploadStudentID() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], 
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      Dio dio = Dio();
      Response response = await dio.post(
        "http://192.168.1.2:5000/upload", // استبدل بعنوان API الحقيقي
        data: formData,
      );

      if (response.statusCode == 200) {
       final responseData = response.data;
      setState(() {
          uploadedFileName = responseData['filePath'].split('/').last;  // استخراج اسم الملف فقط
        });
    } else {
        throw Exception("Failed to upload file");
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  }
}
int getDurationValue(String? selectedDuration) {
  switch (selectedDuration) {
    case "1 Month":
      return 1;
    case "3 Months":
      return 3;
    case "6 Months":
      return 6;
    case "1 Year":
      return 12;
    default:
      return 1; 
  }
}
  Future<void> submitRequest() async {
    if (selectedWilaya == null || selectedSubscriptionType == null || selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ يرجى اختيار جميع الخيارات قبل الإرسال!")),
      );
      return;
    }

    String apiUrl = "http://192.168.1.2:5000/subscribe";
String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Map<String, dynamic> requestData = {
  "user_id": widget.user['id'],
  "state": selectedWilaya,
  "subscription_type": selectedSubscriptionType,
  "duration":  getDurationValue(selectedDuration),
  "total_price": calculatePrice(),
  "student_id_path": isStudent ? uploadedFileName : null,
  "date_debut": formattedDate
};

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ تم إرسال الطلب بنجاح!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ فشل في إرسال الطلب! حاول مرة أخرى.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🚨 خطأ في الاتصال بالخادم!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscription Plan",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF578FCA),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Wilaya:"),
            DropdownButtonFormField<String>(
              value: selectedWilaya,
              items: wilayas.map((String wilaya) {
                return DropdownMenuItem<String>(
                  value: wilaya,
                  child: Text(wilaya),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedWilaya = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            Text("Select Subscription Type:"),
            DropdownButtonFormField<String>(
              value: selectedSubscriptionType,
              items: subscriptionTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedSubscriptionType = value;
                  isStudent = value == "student";
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            Text("Select Subscription Duration:"),
            DropdownButtonFormField<String>(
              value: selectedDuration,
              items: durations.map((String duration) {
                return DropdownMenuItem<String>(
                  value: duration,
                  child: Text(duration),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedDuration = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 16),
            Text(
              "Total Price: \$${calculatePrice().toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF578FCA),
              ),
            ),
            SizedBox(height: 16),
            isStudent
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: uploadStudentID,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF578FCA),
                        ),
                        child: Text("Upload Student ID (PDF)",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                      SizedBox(height: 8),
                      uploadedFileName != null
                          ? Text("Uploaded: $uploadedFileName",
                              style: TextStyle(color: Colors.green))
                          : Container(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF578FCA),
                        ),
                        child: Text("Submit for Review",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: submitRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF578FCA),
                    ),
                    child: Text("Proceed to Purchase",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)))),
          ],
        ),
      ),
    );
  }
}
