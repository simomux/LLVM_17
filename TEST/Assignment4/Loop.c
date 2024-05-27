#include <stdlib.h>
#include <time.h>

void calculateVectors(int N, int* a, int* b, int* c, int* d) {
  int i;
  for (i = 0; i < N; i++) {
    a[i] = 1 / b[i] * c[i];
  }

  for (i = 0; i < N; i++) {
    d[i] = a[i] + c[i];
  }
}

int main() {
  int N = 5;
  int a[N], b[N], c[N], d[N];
  
  srand(time(NULL));
  for (int i = 0; i < N; i++) {
    a[i] = rand();
    b[i] = rand();
    c[i] = rand();
  }
  calculateVectors(N, a, b, c, d);
  return 0;
}