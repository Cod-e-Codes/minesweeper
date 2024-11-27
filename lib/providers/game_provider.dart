import 'package:flutter/foundation.dart'; // Required for compute function
import 'dart:math';
import '../models/cell_model.dart';

class GameProvider extends ChangeNotifier {
  static const int gridSize = 10; // 10x10 grid
  static const int numberOfMines = 15;
  late List<CellModel> grid;

  GameProvider() {
    initializeGrid();
  }

  Future<void> initializeGrid() async {
    // Offload heavy computation to an isolate
    grid = await compute(_createGridWithMines, gridSize);
    notifyListeners();
  }

  // This function will run on a separate isolate
  static List<CellModel> _createGridWithMines(int gridSize) {
    List<CellModel> grid = List.generate(gridSize * gridSize, (index) {
      int x = index % gridSize;
      int y = index ~/ gridSize;
      return CellModel(x: x, y: y);
    });

    final random = Random();
    int minesPlaced = 0;

    while (minesPlaced < numberOfMines) {
      int index = random.nextInt(grid.length);
      if (!grid[index].hasMine) {
        grid[index].hasMine = true;
        minesPlaced++;
      }
    }

    for (var cell in grid) {
      if (!cell.hasMine) {
        int count = _getSurroundingMines(cell, grid, gridSize);
        cell.mineCount = count;
      }
    }

    return grid;
  }

  static int _getSurroundingMines(CellModel cell, List<CellModel> grid, int gridSize) {
    int count = 0;
    List<CellModel> neighbors = _getNeighbors(cell, grid, gridSize);
    for (var neighbor in neighbors) {
      if (neighbor.hasMine) {
        count++;
      }
    }
    return count;
  }

  static List<CellModel> _getNeighbors(CellModel cell, List<CellModel> grid, int gridSize) {
    List<CellModel> neighbors = [];
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        int nx = cell.x + dx;
        int ny = cell.y + dy;
        if (nx >= 0 && nx < gridSize && ny >= 0 && ny < gridSize) {
          neighbors.add(grid[ny * gridSize + nx]);
        }
      }
    }
    return neighbors;
  }

  void revealCell(CellModel cell) {
    if (!cell.isRevealed && !cell.isFlagged) {
      cell.isRevealed = true;
      if (cell.mineCount == 0 && !cell.hasMine) {
        List<CellModel> neighbors = _getNeighbors(cell, grid, gridSize);
        for (var neighbor in neighbors) {
          if (!neighbor.isRevealed) {
            revealCell(neighbor);
          }
        }
      }
      notifyListeners();
    }
  }

  void toggleFlag(CellModel cell) {
    if (!cell.isRevealed) {
      cell.isFlagged = !cell.isFlagged;
      notifyListeners();
    }
  }

  bool isGameWon() {
    // Player wins when all non-mine cells are revealed
    return grid.every((cell) => cell.isRevealed || cell.hasMine);
  }

  bool isGameLost() {
    // Player loses when any mine is revealed
    return grid.any((cell) => cell.hasMine && cell.isRevealed);
  }

  void restartGame() {
    initializeGrid();
  }
}
