import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Text(
          'tram app',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Text(
                  'Login to your Account',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), 
                _buildTextField('Email', screenWidth),
                SizedBox(height: screenHeight * 0.015),
                _buildTextField('Password', screenWidth, isPassword: true),
                SizedBox(height: screenHeight * 0.03),
                _buildButton('Sign in', Colors.blue[900]!, screenWidth,
                   1000, () {}),
                SizedBox(height: screenHeight * 0.09),
                Text(
                  '- Or sign in with -',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: screenWidth * 0.05,
                  children: [
                    _buildSocialButton(FontAwesomeIcons.google, Colors.red,
                        screenWidth, screenHeight),
                    _buildSocialButton(FontAwesomeIcons.facebookF, Colors.blue,
                        screenWidth, screenHeight),
                    _buildSocialButton(FontAwesomeIcons.twitter,
                        Colors.lightBlue, screenWidth, screenHeight),
                  ],
                ),
                SizedBox(height: screenHeight * 0.1),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text('Don’t have an account? Sign up',
                       style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Color.fromARGB(255, 10, 7, 161),
                  ),
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, double screenWidth,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.02)),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.025, horizontal: screenWidth * 0.03),
      ),
    );
  }

  Widget _buildButton(String text, Color color, double screenWidth,
      double screenHeight, VoidCallback onPressed) {
    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.02)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      IconData icon, Color color, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.18,
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: FaIcon(icon, color: color, size: screenWidth * 0.08),
        onPressed: () {},
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  @override
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.05), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                Text(
                  'Create your Account',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), 
                _buildTextField('Email', screenWidth),
                SizedBox(height: screenHeight * 0.015),
                _buildTextField('Password', screenWidth, isPassword: true),
                SizedBox(height: screenHeight * 0.015),
                _buildTextField('Confirm Password', screenWidth, isPassword: true),
                SizedBox(height: screenHeight * 0.03),
                _buildButton('Sign in', Colors.blue[900]!, screenWidth,
                    1000, () {}),
                SizedBox(height: screenHeight * 0.09),
                Text(
                  '- Or sign in with -',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: screenWidth * 0.05,
                  children: [
                    _buildSocialButton(FontAwesomeIcons.google, Colors.red,
                        screenWidth, screenHeight),
                    _buildSocialButton(FontAwesomeIcons.facebookF, Colors.blue,
                        screenWidth, screenHeight),
                    _buildSocialButton(FontAwesomeIcons.twitter,
                        Colors.lightBlue, screenWidth, screenHeight),
                  ],
                ),
                
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(String label, double screenWidth,
      {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.02)),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.025, horizontal: screenWidth * 0.03),
      ),
    );
  }

  Widget _buildButton(String text, Color color, double screenWidth,
      double screenHeight, VoidCallback onPressed) {
    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.06,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.02)),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      IconData icon, Color color, double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth * 0.18,
      height: screenHeight * 0.08,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: FaIcon(icon, color: color, size: screenWidth * 0.08),
        onPressed: () {},
      ),
    );
  }
}