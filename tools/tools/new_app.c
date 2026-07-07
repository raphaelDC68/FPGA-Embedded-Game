

int main()
{
	unsigned long i=0;
	unsigned long N=50;
	unsigned long T[100];
	T[0] = 0;
	
	for(i=1;i<N; i++)
	{
		T[i] = T[i-1] +i;
	}
	
	return 0;
}

