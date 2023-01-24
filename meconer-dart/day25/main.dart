import 'dart:math';

Future<void> main(List<String> args) async {
  print('Part 1:');
  final resultP1 = calcResultP1();
  print(resultP1);

  // print('Part 2:');
  // final resultP2 = calcResultP2(inputLines);
  // print(resultP2);
}

int calcResultP1() {
  //int cardPubKey = 5764801;
  //int doorPubKey = 17807724;
  int cardPubKey = 13233401;
  int doorPubKey = 6552760;
  int subjNumber = 7;
  int cardLoopSize = findLoopSize(cardPubKey, subjNumber);

  // Not needed but calculated anyway
  int doorLoopSize = findLoopSize(doorPubKey, subjNumber);

  int encryptionKey = transform(cardLoopSize, doorPubKey);
  return encryptionKey;
}

int transform(int loopSize, int subjNumber) {
  int result = 1;
  for (int i = 0; i < loopSize; i++) {
    result *= subjNumber;
    result = result % 20201227;
  }
  return result;
}

int findLoopSize(int pubKey, int subjNumber) {
  int result = 1;
  int loopSize = 0;
  while (result != pubKey) {
    result *= subjNumber;
    result = result % 20201227;
    loopSize++;
  }
  return loopSize;
}
