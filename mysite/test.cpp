#include<iostream>
using namespace std;


void compete(int** a, int low, int high, int num)
{	
	if (num == 2)
	{
		a[low][low+1] = 1;
		a[low+1][low] = 1;
		
		return;
	}
	else if (num == 3)
	{
		a[low][low+1] = 1;
		a[low+1][low] = 1;
		a[low][low+2] = 2;
		a[low+2][low] = 2;
		a[low+1][low+2] = 3;
		a[low+2][low+1] = 3;
		
		return;
	}
	
	int num1 = num / 2;
	int num2 = num -num1;
	
	compete(a, low, low+num1-1, num1);
	compete(a, low+num1, high, num2);
	
	for 
	
	return;
}


int main()
{
	int number;
	int **p;
	
	cout<<"input number:"; 
	cin>>number;
	number = number+1;
	
	p = new int*[number];
	p[0] = new int[number*number];
	
	for (int i=1; i<number; i++)
		p[i] = p[0] + number*i;
		
	for (int i=1; i<number; i++)
		for (int j=1; j<number; j++)
			p[i][j] = 0;
	
	compete(p, 1, number-1, number-1);
	
	for (int i=1; i<number; i++)
	{
		for (int j=1; j<number; j++)
			cout<<p[i][j]<<" ";
		cout<<endl;
	}
	
	return 0;
}
