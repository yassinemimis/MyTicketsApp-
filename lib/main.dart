import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tram_app2/AdminRequestsPage.dart';
import 'package:tram_app2/BuyTicket.dart';
import 'package:tram_app2/CardScreen.dart';
import 'package:tram_app2/Change_Password.dart';
import 'package:tram_app2/LoginScreen2.dart';
import 'package:tram_app2/NotificationsPage.dart';
import 'package:tram_app2/Payment_Methods.dart';
import 'package:tram_app2/Personal_Data.dart';
import 'package:tram_app2/SettingsScreen.dart';
import 'package:tram_app2/SubscriptionPage.dart';
import 'package:tram_app2/SuccessPageBuy.dart';
import 'package:tram_app2/Ticket.dart';
import 'package:tram_app2/TramCardScreen.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tram_app2/home.dart';
import 'package:tram_app2/profil.dart';














// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: ['email'],
//   serverClientId: "YOUR_WEB_CLIENT_ID",
//   forceCodeForRefreshToken: true,
// );

// Future<void> signInWithGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) {
//       print("❌ User canceled login");
//       return;
//     }

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//     print("🔍 Access Token: ${googleAuth.accessToken}");
//     print("🔍 ID Token: ${googleAuth.idToken}");

//     if (googleAuth.idToken == null) {
//       print("❌ Google ID token is null");
//       return;
//     }

//     print("✅ Google Sign-In Successful!");
//   } catch (e) {
//     print("❌ Error during Google Sign-In: $e");
//   }
// }



































import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: LoginScreen2(),
        ),
      ),
    );
  }
}

// class TramCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       margin: EdgeInsets.all(20),
//       child: Container(
//         width: 350,
//         padding: EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade100, Colors.white],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           image: DecorationImage(
//             image: AssetImage("assets/patterns/waves.jpg"),
//             opacity: 0.3,
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Tram card',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue.shade800,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'This card must be validated upon boarding',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade700,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // الصورة الشخصية
//                       Container(
//                         margin: EdgeInsets.only(right: 15),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.blue.shade800,
//                             width: 2,
//                           ),
//                         ),
//                         child: CircleAvatar(
//                           radius: 35,
//                           backgroundImage:  NetworkImage('https://media.licdn.com/dms/image/v2/D4E03AQH6F13n0KOofg/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1699315717040?e=1747872000&v=beta&t=fEkLrHOVCnuhe5NRrMx6hEO4wBAIgEuhoRRSPamqlqM'),
//                         ),
//                       ),
//                       // الاسم والعائلة
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'KHERBOUCHE',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 1,
//                               ),
//                             ),
//                             Text(
//                               'MOHAMMED YACINE',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // QR كود
//                       QrImageView(
//                         data: "https://your-ticket-data.com",
//                         version: QrVersions.auto,
//                         size: 100,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     '02-000 003 238 633',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade900,
//                       letterSpacing: 1.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }