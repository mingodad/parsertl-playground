import std.io;

void dosomething1(int x, int y, int z);
void dosomething2(float x, float y);

void main() {
	int x = 100;
	int y, z;

	float f1, f2;

	int i = 0;
	for (i = 100; i < 70; i++)
		x *= 100;

	switch (x) {
		case 1:
			dosomething1(x, y, z);
			break;
		case 2:
			dosomething2(f1, f2);
			break;
		default:
			break;
	}
	// single comment

	if (x > 100)  {
		dosomething2(f2, f1);
	} else {
		dosomething1(x, y, z);
	}

	///* block */
	i = 15;
	while (i <= 1) {
		x++;
		i--;
	}

	i = 0;
	do {
		writeln("Test string");
		i++;
	} while (i <= 3)

	switch (x) {
		case 1:
			dosomething1(4, 5, 6);
			break;
		case 2:
			dosomething2(2.3, 4.7);
			break;
		default:
			break;
	}

}