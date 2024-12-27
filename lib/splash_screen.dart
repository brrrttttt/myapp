import 'package:flutter/material.dart';
import 'MyCloset.dart'; // Adjust the import to your actual main screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  // Function to navigate after a delay
  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash screen duration
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyCloset()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Adjust the background color if needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center both vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Image.asset(
              'assets/Closet.png', // Your splash screen image
              width: 150,  // Adjust the width to make the logo smaller
              height: 150, // Adjust the height to maintain aspect ratio
            ),
            const SizedBox(height: 20), // Space between the image and the title
            const Text(
              'Closet Organizer',  // Title text
              style: TextStyle(
                fontSize: 24,  // Adjust the font size to your preference
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Set the text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
