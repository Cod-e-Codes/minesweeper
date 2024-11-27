import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/start_game_screen.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(const MinesweeperApp());
}

class MinesweeperApp extends StatelessWidget {
  const MinesweeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Minesweeper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto', // Applying the Roboto font globally
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 18), // General text size
            titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Titles
          ),
        ),
        home: const StartGameScreen(), // Set Start Game Screen as the home screen
      ),
    );
  }
}
