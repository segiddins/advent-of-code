#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	int idx = 0;
	int w = 0, x = 0, y = 0, z = 0;

	// z = carry
	// w = digit

	w = argv[1][idx++] - '\0';
	x = x * 0;	// x = 0
	x = x + z;	// x = z
	x = x % 26; // x = z % 26
	z = z / 1;	// z = z
	x = x + 11; // x = (z % 26) + 11 <- also differs
	// since 11, never 0
	x = x == w; // x = 1 if x == w else 0
	// since 11, always 1
	x = x == 0; // x = ((z % 26) + 11) == w
	y = y * 0;	// y = 0
	y = y + 25; // y = 25
	y = y * x;	// y = 25 * x
	y = y + 1;	// y = 25 * x + 1
	z = z * y;	// z = z * (25 * x + 1)
	y = y * 0;	// y = 0
	y = y + w;	// y = w
	y = y + 6;	// y = w + 6 <- this is what differs
	y = y * x;	// y = (w + 6) * x
	z = z + y;	// z = z * (25 * x + 1) + (w + 6) * x

	// z = (w + 6)

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26; // x = z % 26
	z = z / 1;
	x = x + 11; // x = (z % 26) + 11
	x = x == w; // x = 0
	x = x == 0; // x = 1
	y = y * 0;
	y = y + 25; // y = 25
	y = y * x;	// y = 25
	y = y + 1;	// y = 26
	z = z * y;	// z = z * 26
	y = y * 0;	// y = 0
	y = y + w;	// y = w
	y = y + 12; // y = w + 12
	y = y * x;	// y = w + 12
	z = z + y;	// z = z + w + 12

	// z = d1 + d2 + 18

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26; // x = (d1 + d2 + 18) % 26
	z = z / 1;
	x = x + 15;
	x = x == w;
	x = x == 0; // x = 1
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1; // y = 26
	z = z * y; // z = z * 26
	y = y * 0;
	y = y + w;
	y = y + 8;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 26;
	x = x + -11;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 7;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 1;
	x = x + 15;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 7;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 1;
	x = x + 15;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 12;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 1;
	x = x + 14;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 2;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 26;
	x = x + -7;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 15;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 1;
	x = x + 12;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 4;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 26;
	x = x + -6;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 5;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 26;
	x = x + -10;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 12;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26;
	z = z / 26;
	x = x + -15;
	x = x == w;
	x = x == 0;
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1;
	z = z * y;
	y = y * 0;
	y = y + w;
	y = y + 11;
	y = y * x;
	z = z + y;

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26; // x = z % 26
	z = z / 26;
	x = x + -9; // x = input_z % 26 -9
	x = x == w;
	x = x == 0; // x = 1
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1; // y = 26
	z = z * y; // z = input_z
	y = y * 0;
	y = y + w;
	y = y + 13;
	y = y * x; // y = (w + 13)
	z = z + y; // z = input_z + w + 13

	w = argv[1][idx++] - '\0';
	x = x * 0;
	x = x + z;
	x = x % 26; // x = z % 26
	z = z / 26; // z = z / 26
	x = x + 0;
	x = x == w;
	x = x == 0; // x = 1
	y = y * 0;
	y = y + 25;
	y = y * x;
	y = y + 1; // y = 26
	z = z * y; // z = z * 26 <- input z
	y = y * 0;
	y = y + w;
	y = y + 7;
	y = y * x; // y = w + 7
	z = z + y; // z = input_z + w + 7
	return z == 0 ? 0 : 1;
}
