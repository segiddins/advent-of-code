#include <stdio.h>

int is_composite(long long x) {
  for (long long i = 2; i <= x / 2; ++i) {
    if (i * i > x) return 0;
    if (x % i == 0) return 1;
  }
  return 0;
}

int main() {
  long long a = 0;
  long long b = 0;
  long long c = 0;
  long long d = 0;
  long long e = 0;
  long long f = 0;
  long long g = 0;
  long long h = 0;

  b = 67;
  c = b;
  b *= 100;
  b += 100000;
  c = b;
  c += 17000;
  for (;b!=c+17;b+=17) {
    if (is_composite(b)) { // b composite
      h += 1;
    }
  }
  printf("%lld", h);
}
