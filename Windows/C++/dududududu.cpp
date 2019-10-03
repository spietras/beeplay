#include <iostream>
#include <windows.h>

using namespace std;

void makeBeep(double frequency, int beepDuration, int sleepDuration, int repeats=1)
{
	if(frequency < 37.00 || frequency > 32767.00)
		throw new std::exception("Frequency not in range (37, 32767)");

	for(int i = 0; i < repeats; i++)
	{
		Beep(frequency, beepDuration);
		Sleep(sleepDuration);
	}
}

int main()
{
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160);
	makeBeep(440, 40, 80, 5);
	makeBeep(440, 80, 160);
	makeBeep(587.33, 40, 80, 6);
	makeBeep(587.33, 80, 160);
	makeBeep(523.25, 40, 80);
	makeBeep(587.33, 40, 80, 5);
	makeBeep(523.25, 80, 160);
	makeBeep(392, 80, 160);
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160);
	makeBeep(440, 40, 80, 5);
	makeBeep(440, 80, 160);
	makeBeep(587.33, 40, 80);
	makeBeep(440, 40, 80, 5);
	makeBeep(440, 80, 160);
	makeBeep(440, 40, 80, 5);
	makeBeep(440, 80, 160);
	makeBeep(587.33, 40, 80, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160, 2);
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 160, 320);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160, 2);
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160, 2);
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160, 2);
	makeBeep(587.33, 40, 8, 4);
	makeBeep(587.33, 80, 160, 2);
	makeBeep(523.25, 40, 80, 4);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(392, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160, 2);
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160, 2);
	makeBeep(440, 40, 80, 4);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(440, 80, 160);
	makeBeep(523.25, 80, 160, 2);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(440, 40, 80, 2);
	makeBeep(523.25, 80, 160);
	makeBeep(587.33, 640, 10, 4);
	
	system("pause");
	return 0;
}