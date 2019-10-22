#include<iostream>

using namespace std;

__global__ void minimum(int *input)
{
  int tid = threadIdx.x;
  int step_size = 1;
  int number_of_threads = blockDim.x;

  while(number_of_threads > 0)
  {
    if(tid < number_of_threads)
    {
      int first = tid*step_size*2;
      int second = first + step_size;
      if(input[first] > input[second])
      {
        input[first] = input[second];
      }
    }
    step_size *= 2;
    number_of_threads /=2;
  }
}

__global__ void sum(int *input)
{
  int step_size = 1;
  int number_of_threads = blockDim.x;
  int tid = threadIdx.x;

  while(number_of_threads > 0)
  {
    if(tid < number_of_threads)
    {
      int first = tid*step_size*2;
      int second = first + step_size;
      input[first] += input[second];
    }
    step_size *=2;
    number_of_threads /= 2;
  }
}
int main()
{
  int n;
  cout<<"Enter no of elements"<<"\n";
  cin>>n;

  srand(n);
  int *arr = new int[n];
  for(int i=0;i<n;i++)
  {
    arr[i] = rand();
  }

  for(int i=0;i<n;i++)
  {
    cout<<arr[i]<<" ";
  }
  cout<<"\n";

  int size = n*sizeof(int);
  int *arr_d,result1;

  cudaMalloc(&arr_d,size);
  cudaMemcpy(arr_d,arr,size,cudaMemcpyHostToDevice);

  minimum<<<1,n/2>>>(arr_d);

  cudaMemcpy(&result1,arr_d,sizeof(int),cudaMemcpyDeviceToHost);
  cout<<"Minimum Element  = "<<result1;

  cudaFree(arr_d);

  int *arr_sum,result2;
  cudaMalloc(&arr_sum,size);
  cudaMemcpy(arr_sum,arr,size,cudaMemcpyHostToDevice);

  sum<<<1,n/2>>>(arr_sum);

  cudaMemcpy(&result2,arr_sum,size,cudaMemcpyDeviceToHost);
  cout<<"Sum = "<<result2;

  cudaFree(arr_sum);
  return 0;
}