#include<iostream>
using namespace std;


int compete( int (*a)  [2])
{	
	cout<<a[0][0];
	return 0;	
} 



int main()
{
	int number;
	
	cout<<"input number:"; 
	cin>>number;
	
	int a[number+1][number+1] = {0};
	
	for (int i=1; i<=number; i++)
	{
		for (int j=1; j<=number; j++)
			cout<<a[i][j]<<" ";
		cout<<"\n";
	}
	int b[2][2]={1,2,3,4};
	
	compete(b);
	
}
