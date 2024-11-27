class CellModel {
  final int x;
  final int y;
  bool hasMine;
  bool isRevealed;
  bool isFlagged;
  int mineCount;

  CellModel({
    required this.x,
    required this.y,
    this.hasMine = false,
    this.isRevealed = false,
    this.isFlagged = false,
    this.mineCount = 0,
  });
}
