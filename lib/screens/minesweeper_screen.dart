import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg package
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class MinesweeperScreen extends StatelessWidget {
  const MinesweeperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f7), // Light background for modern look
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centering the title and icon together
          children: [
            const Text(
              'Minesweeper',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8), // Space between text and the icon
            SvgPicture.asset(
              'assets/icons/bomb_icon.svg', // Path to your SVG icon
              width: 32, // Increased icon size
              height: 32, // Increased icon size
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title + icon row
        backgroundColor: const Color(0xFF007AFF), // Bright blue for a modern feel
        foregroundColor: Colors.white, // White text for a modern look
        elevation: 0, // Flat look with no shadow
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Adding spacing for cleaner UI
          _buildGrid(context),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => context.read<GameProvider>().restartGame(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF), // Consistent bright blue color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button for modern look
                ),
                shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text(
                'Restart',
                style: TextStyle(
                  color: Colors.white, // Ensures the text has better contrast
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: context.read<GameProvider>().initializeGrid(), // Awaiting grid initialization
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading grid'));
          }

          return Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (gameProvider.isGameWon()) {
                  _showWinDialog(context);
                } else if (gameProvider.isGameLost()) {
                  _showLoseDialog(context);
                }
              });

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: GameProvider.gridSize,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: gameProvider.grid.length,
                itemBuilder: (context, index) {
                  final cell = gameProvider.grid[index];
                  return GestureDetector(
                    onTap: () => gameProvider.revealCell(cell),
                    onLongPress: () => gameProvider.toggleFlag(cell),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300), // Smooth reveal animation
                      decoration: BoxDecoration(
                        color: cell.isRevealed
                            ? (cell.hasMine ? Colors.redAccent.withOpacity(0.9) : Colors.white)
                            : const Color(0xFFB0BEC5), // Slightly modern grey for hidden cells
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          cell.isRevealed
                              ? (cell.hasMine
                              ? '💣'
                              : cell.mineCount > 0
                              ? '${cell.mineCount}'
                              : '')
                              : (cell.isFlagged ? '🚩' : ''),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: cell.isRevealed
                                ? (cell.hasMine ? Colors.white : Colors.black87)
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Dialogs for winning and losing
  void _showWinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'You Win!',
            style: TextStyle(color: Colors.green),
          ),
          content: const Text('Congratulations! You have flagged all the mines.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GameProvider>().restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Game Over',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text('You hit a mine! Try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<GameProvider>().restartGame();
              },
            ),
          ],
        );
      },
    );
  }
}
