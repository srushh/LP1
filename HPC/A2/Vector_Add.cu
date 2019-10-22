#include <stdio.h>
# include "cuda_runtime.h"

#define SIZE 50

__global__ void VectorAdd(int a[], int b[], int c[], int n)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	
	if(i < n)
	{
		c[i] = a[i] + b[i];
	}
}

int main()
{
	int *a, *b, *c;
	
	a = (int*)malloc(SIZE * sizeof(int));
	b = (int*)malloc(SIZE * sizeof(int));
	c = (int*)malloc(SIZE * sizeof(int));
	
	for (int i = 0; i < SIZE; i++)
	{
		a[i] = i+1;
		b[i] = i;
	}
	
	int *d_a, *d_b, *d_c;
	
	cudaMalloc(&d_a, SIZE * sizeof(int));
	cudaMalloc(&d_b, SIZE * sizeof(int));
	cudaMalloc(&d_c, SIZE * sizeof(int));
	
	cudaMemcpy(d_a, a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, SIZE * sizeof(int), cudaMemcpyHostToDevice);
		
	VectorAdd <<< 2, SIZE/2 >>> (d_a, d_b, d_c, SIZE);
	
	cudaDeviceSynchronize(); // jab tak saare threads ka kaam nahi hota.... tab tak ruko
	
	cudaMemcpy(c, d_c, SIZE * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < SIZE; i++)
		printf("%d + %d = %d\n", a[i], b[i], c[i]);

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	
	free(a);
	free(b);
	free(c);

	return 0;
}
