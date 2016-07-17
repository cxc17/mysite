#include <iostream>

using namespace std;

int fun()
{
	return 17;
}


enum VideoSiteID
{
	VSite_UnSupported = 123,
	A
};

int main()
{
	VideoSiteID  a;
	// a = A;

	int i = VSite_UnSupported;

	cout <<  i <<endl;
	
	return 0;

}