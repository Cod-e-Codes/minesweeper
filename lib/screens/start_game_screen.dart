import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'minesweeper_screen.dart'; // Import the Minesweeper game screen

class StartGameScreen extends StatelessWidget {
  const StartGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f7), // Light background for modern look
      appBar: AppBar(
        title: const Text(
          'Minesweeper',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Center title for clean design
        backgroundColor: const Color(0xFF007AFF), // Bright blue for modern feel
        foregroundColor: Colors.white, // White text
        elevation: 0, // Flat look with no shadow
      ),
      body: Column(
        children: [
          // Lottie animation
          SizedBox(
            width: screenWidth, // Set the width to the full screen width
            height: screenWidth, // You can set the height relative to the width (square)
            child: Lottie.asset(
              'assets/images/lottie_bomb.json', // Path to your .json file
              fit: BoxFit.cover, // Ensures the animation fills the width
            ),
          ),

          // Spacer to move the button towards the bottom
          const Spacer(),

          // Custom Start Game Button
          ElevatedButton(
            onPressed: () {
              // Navigate to Minesweeper game screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MinesweeperScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF), // Consistent bright blue color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded button for modern look
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 64),
              shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for button
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text(
              'Start Game',
              style: TextStyle(
                color: Colors.white, // White text for contrast
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32), // Add some space below the button
        ],
      ),
    );
  }
}
