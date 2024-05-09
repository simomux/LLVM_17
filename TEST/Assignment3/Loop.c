int g;

int loop(int a, int b, int c) {
  int i, ret = 0;

  for (i = a; i < b; i++) {
    g += c;
  }

  return ret + g;
}