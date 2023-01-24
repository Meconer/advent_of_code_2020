import '../util/util.dart';

//const String inputFile = 'day24/example.txt';
const String inputFile = 'day24/input.txt';

Future<void> main(List<String> args) async {
  var inputLines = await readInput(inputFile);

  print('Part 1:');
  final resultP1 = calcResultP1(inputLines);
  print(resultP1);

  print('Part 2:');
  final resultP2 = calcResultP2(inputLines);
  print(resultP2);
}

int calcResultP1(List<String> inputLines) {
  Map<HexPos, Color> flippedTiles = {};
  for (final line in inputLines) {
    HexPos tilePos = getHexPos(line);
    flipTile(flippedTiles, tilePos);
  }
  int countBlacks = 0;
  for (final tile in flippedTiles.values) {
    if (tile == Color.black) countBlacks++;
  }
  return countBlacks;
}

int calcResultP2(List<String> inputLines) {
  Map<HexPos, Color> tiles = {};
  for (final line in inputLines) {
    HexPos tilePos = getHexPos(line);
    flipTile(tiles, tilePos);
    setNeigboursWhite(tiles); // Add white neighbours to all existing tiles
  }
  for (int day = 0; day < 100; day++) {
    tiles = doDailyFlip(tiles);
    setNeigboursWhite(tiles); // Add white neighbours to all existing tiles
    print('Day ${day + 1}: ${countBlackTiles(tiles)}');
  }
  return countBlackTiles(tiles);
}

Map<HexPos, Color> doDailyFlip(Map<HexPos, Color> tiles) {
  Map<HexPos, Color> tilesAfterFlip = {};
  for (final tile in tiles.keys) {
    // Count black neighbours
    int blackNeighbourCount = 0;
    for (final neighbour in tile.getNeighbours()) {
      if (tiles.containsKey(neighbour) && tiles[neighbour] == Color.black) {
        blackNeighbourCount++;
      }
    }

    /**
      Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
      Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
    */
    tilesAfterFlip[tile] = tiles[tile]!;
    if (tiles[tile] == Color.black) {
      // Black tile.
      if (blackNeighbourCount == 0 || blackNeighbourCount > 2) {
        tilesAfterFlip[tile] = Color.white;
      }
    } else {
      // White tile
      if (blackNeighbourCount == 2) {
        tilesAfterFlip[tile] = Color.black;
      }
    }
  }
  return tilesAfterFlip;
}

int countBlackTiles(Map<HexPos, Color> tiles) {
  int countBlacks = 0;
  for (final tileColor in tiles.values) {
    if (tileColor == Color.black) countBlacks++;
  }
  return countBlacks;
}

void setNeigboursWhite(Map<HexPos, Color> tiles) {
  Map<HexPos, Color> newWhiteTiles = {};
  for (final tile in tiles.keys) {
    // Skip if tile is white
    if (tiles[tile] == Color.white) continue;

    // Make neighbours white
    List<HexPos> neighbours = tile.getNeighbours();
    for (final neighbour in neighbours) {
      if (!tiles.containsKey(neighbour)) {
        newWhiteTiles[neighbour] = Color.white;
      }
    }
  }
  tiles.addAll(newWhiteTiles);
}

HexPos getHexPos(String line) {
  HexPos hexPos = HexPos(0, 0);
  String direction = '';
  while (line.isNotEmpty) {
    if (line.startsWith('s') || line.startsWith('n')) {
      direction = line.substring(0, 2);
      line = line.substring(2);
    } else {
      direction = line.substring(0, 1);
      line = line.substring(1);
    }
    hexPos = hexPos.move(direction);
  }
  return hexPos;
}

void flipTile(Map<HexPos, Color> flippedTiles, HexPos tilePos) {
  if (flippedTiles.containsKey(tilePos)) {
    var tileColor =
        flippedTiles[tilePos] == Color.black ? Color.white : Color.black;
    flippedTiles[tilePos] = tileColor;
  } else {
    flippedTiles[tilePos] = Color.black;
  }
}

enum Color { black, white }

class HexPos {
  /**
   * Positions counts as:
   * 
   *     0   2   4   6   8   10
   *       1   3   5   7   9
   */
  final int row;
  final int col;

  HexPos(this.col, this.row);

  HexPos move(String direction) {
    switch (direction) {
      case 'nw':
        return HexPos(col - 1, row - 1);
      case 'ne':
        return HexPos(col + 1, row - 1);
      case 'e':
        return HexPos(col + 2, row);
      case 'se':
        return HexPos(col + 1, row + 1);
      case 'sw':
        return HexPos(col - 1, row + 1);
      case 'w':
        return HexPos(col - 2, row);
      default:
        return HexPos(col, row);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HexPos && (col == other.col && row == other.row);
  }

  int get hashCode => (col * 100000 + row);

  List<HexPos> getNeighbours() {
    List<HexPos> neighbours = [];
    List<String> directions = ['nw', 'ne', 'e', 'se', 'sw', 'w'];
    for (final dir in directions) {
      neighbours.add(move(dir));
    }
    return neighbours;
  }
}
