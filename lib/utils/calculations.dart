class Calculations {
  int additionCount = 0;
  int subtractionCount = 0;
  int multiplicationCount = 0;
  int maxDieCount = 0;
  int minDieCount = 0;

  // Addition
  int add(int a, int b) {
    if (additionCount < 4) {
      additionCount++;
      return a + b;
    } else {
      throw Exception("Limite d'additions atteinte !");
    }
  }

  // Soustraction
  int subtract(int a, int b) {
    if (subtractionCount < 4) {
      subtractionCount++;
      return a - b;
    } else {
      throw Exception("Limite de soustractions atteinte !");
    }
  }

  // Multiplication
  int multiply(int a, int b) {
    if (multiplicationCount < 4) {
      multiplicationCount++;
      return a * b;
    } else {
      throw Exception("Limite de multiplications atteinte !");
    }
  }

  // Plus grand dé
  int maxDie(int a, int b) {
    if (maxDieCount < 4) {
      maxDieCount++;
      return a > b ? a : b;
    } else {
      throw Exception("Limite de max dé atteinte !");
    }
  }

  // Plus petit dé
  int minDie(int a, int b) {
    if (minDieCount < 4) {
      minDieCount++;
      return a < b ? a : b;
    } else {
      throw Exception("Limite de min dé atteinte !");
    }
  }
}
