import 'package:flutter/material.dart';


class PaymentMethodsScreen extends StatefulWidget {
  @override
  _PaymentMethodsScreenState createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  List<Map<String, String>> paymentMethods = [
    {"cardNumber": "**** **** **** 1234", "cardType": "Visa", "holderName": "John Doe"},
    {"cardNumber": "**** **** **** 5678", "cardType": "MasterCard", "holderName": "Alice Smith"},
  ];

  void _addPaymentMethod(String cardNumber, String cardType, String holderName) {
    setState(() {
      paymentMethods.add({
        "cardNumber": "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}",
        "cardType": cardType,
        "holderName": holderName
      });
    });
  }

  void _showAddCardDialog() {
    String cardNumber = "", cardType = "Visa", holderName = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Card"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Card Number"),
                keyboardType: TextInputType.number,
                onChanged: (value) => cardNumber = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Card Holder Name"),
                onChanged: (value) => holderName = value,
              ),
              DropdownButtonFormField<String>(
                value: cardType,
                decoration: InputDecoration(labelText: "Card Type"),
                items: ["Visa", "MasterCard", "American Express"]
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => cardType = value!,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (cardNumber.length == 16 && holderName.isNotEmpty) {
                  _addPaymentMethod(cardNumber, cardType, holderName);
                  Navigator.pop(context);
                }
              },
              child: Text("Add Card"),
            ),
          ],
        );
      },
    );
  }

  void _removePaymentMethod(int index) {
    setState(() {
      paymentMethods.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF578FCA),
        title: Text("Payment Methods"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Icon(Icons.credit_card, color: Color(0xFF578FCA)),
                      title: Text(paymentMethods[index]["cardType"]!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "${paymentMethods[index]["holderName"]}\n${paymentMethods[index]["cardNumber"]}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removePaymentMethod(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _showAddCardDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF578FCA),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text("Add New Card", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
