#include<cstdio>
#include<mpi.h>
#include<iostream>
#include<chrono>
#include<unistd.h>

#include <time.h>

using namespace std::chrono;
using namespace std;

void binary_search(int a[],int start,int end,int key,int rank)
{
	while(start <= end)
	{
		int m = (start+end)/2;
        
		if(a[m]==key)
		{
			cout<<"The element is found by Process No "<<rank+1<<endl;
			return;
		}
		else if(a[m]<key)
		{
			start=m+1;
		}
		else
		{
			end=m-1;
		}
	}
    cout<<"Not found by Process No : "<<rank+1<<endl;
}

int main(int argc, char **argv)
{

	//cout<<"Hello welcome to MPI World"<<endl;
    int n=8000;
    int key=4500;
    double c[4];
    int a[n];
	for(int i=0;i<n;i++)
	{
        a[i]=i+1;
	}
    
	int rank,blocksize;
	MPI_Init(&argc,&argv); //Initialise MPI
	/*MPI_COMM_WORLD is the default communicator, it basically groups all the processes when the program started
	The number in a communicator does not change once it is created. 
	That number is called the size of the communicator. 
	At the same time, each process inside a communicator has a unique number to identify it. 
	This number is called the rank of the process.*/
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);// Sets the rank. The rank of a process always ranges from o to size-1

	MPI_Comm_size(MPI_COMM_WORLD,&blocksize); // Sets the size. size = no. of processes
	
	blocksize=n/4; // to allocate uniform load on each of the 4 processors.
	
	double start = MPI_Wtime();//MPI_Wtime() : returns current time.

	binary_search(a,rank*blocksize,(rank+1)*blocksize-1,key,rank);

	double end = MPI_Wtime();

	cout<<"The time for process " <<rank+1<<"is "<<(end-start)*1000<<endl<<endl;
	c[rank]=end;

	MPI_Finalize(); //Finalize MPI

}

/*
Commands :
mpicxx binary_search.cpp
mpirun -np 4 ./a.out
./a.out
*/