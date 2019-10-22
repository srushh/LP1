#include<iostream>
using namespace std;

__global__ void average(int *a, float *b, int n)
{
  int tid=threadIdx.x;
  int sum=0;
  for(int i=0;i<n;i++)
  {
      sum+=a[i];
  } 
 float mean=sum/(n*1.0);
  b[tid]=mean; 
}

__global__ void standardDev(int *a, float *b, float mean, int n)
{
    int tid=blockIdx.x;
    b[0]=0.0;
    for(int i=0;i<n;i++)
    {
        b[0] += (a[i] - mean) * (a[i] - mean);
    }
  b[0]=b[0]/n;
}

int main()
{
  int n=10;
  int *a=(int*)malloc(n*sizeof(int));
  cudaEvent_t start, end;
  for(int i=0;i<n;i++)
  {
      a[i]=i+1;
  }
  cudaEventCreate(&start);
  cudaEventCreate(&end);
  int *dev_a;
  float  *dev_b;
  int size=n*sizeof(int);
  cudaMalloc(&dev_a,size);
  cudaMalloc(&dev_b,sizeof(float));
  cudaMemcpy(dev_a,a,size,cudaMemcpyHostToDevice);
  cudaEventRecord(start);
  average<<<1, n>>>(dev_a, dev_b, n);
  float *mean=(float *)malloc(sizeof(float));
  cudaEventRecord(end);
  cudaEventSynchronize(end);
  float time=0;
  cudaEventElapsedTime(&time, start, end);
  cudaMemcpy(mean, dev_b, sizeof(float),cudaMemcpyDeviceToHost);
  cout<<"\nMean is : "<<mean[0];
  float *std=(float*)malloc(sizeof(float));
  standardDev<<<n,1>>>(dev_a, dev_b, mean[0], n);
  cudaMemcpy(std, dev_b, sizeof(float), cudaMemcpyDeviceToHost);
  cout<<"\nStandard Deviation is : "<<sqrt(std[0])<<endl;
  cout<<"\nTime taken : "<<time;
  return 0;
}
