#include<iostream>
using namespace std;

__global__ void addition(int *a, int*b, int n)
{
  int tid=threadIdx.x;
  int sum=0;
  for(int i=0;i<n;i++)
  {
      sum+=a[i];
  } 
  b[tid]=sum; 
}

int main()
{
  int n=1000;
  int *a=(int*)malloc(n*sizeof(int));
  cudaEvent_t start, end;
  for(int i=0;i<n;i++)
  {
      a[i]=i+1;
  }
  cudaEventCreate(&start);
  cudaEventCreate(&end);
  int *dev_a,  *dev_b;
  int size=n*sizeof(int);
  cudaMalloc(&dev_a,size);
  cudaMalloc(&dev_b,sizeof(int));
  cudaMemcpy(dev_a,a,size,cudaMemcpyHostToDevice);
  cudaEventRecord(start);
  addition<<<1, n>>>(dev_a, dev_b, n);
  int *sum=(int *)malloc(sizeof(int));
  cudaEventRecord(end);
  float time=0;
  cudaEventSynchronize(end);
  cudaEventElapsedTime(&time, start, end);
  cudaMemcpy(sum, dev_b, sizeof(int),cudaMemcpyDeviceToHost);
  cout<<"\nAddition is : "<<sum[0];
  cout<<"\nTime taken : "<<time;
  return 0;
}
