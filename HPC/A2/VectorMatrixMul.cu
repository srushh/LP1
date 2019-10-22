#include <stdio.h>
#define SIZE 10

__global__ void VectorMatrixMult(int a[], int b[], int c[], int n)
{
	int i = threadIdx.x;

	if(i < n)
	{
		for(int j=0; j<SIZE; j++)
		{
			c[i] = c[i] + (a[j] * *(b + i*SIZE + j));
		}
	}
}

int main()
{
	int *a, *b, *c;
	
	a = (int*)malloc(SIZE * sizeof(int));
	b = (int*)malloc(SIZE * SIZE * sizeof(int));
	c = (int*)malloc(SIZE * sizeof(int));
	
	for (int i = 0; i < SIZE; i++)
	{
		a[i] = i+1;
		for (int j = 0; j < SIZE; j++)
		{
			*(b + i*SIZE + j) = i*j;
		}
	}
	
	int *d_a, *d_b, *d_c;
	
	cudaMalloc(&d_a, SIZE * sizeof(int));
	cudaMalloc(&d_b, SIZE * SIZE * sizeof(int));
	cudaMalloc(&d_c, SIZE * sizeof(int));
	
	cudaMemcpy(d_a, a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, SIZE * SIZE * sizeof(int), cudaMemcpyHostToDevice);
	
	VectorMatrixMult <<< 1, SIZE >>> (d_a, d_b, d_c, SIZE);
	
	cudaDeviceSynchronize();
	
	cudaMemcpy(c, d_c, SIZE * sizeof(int), cudaMemcpyDeviceToHost);

	printf("Vector: \n");
	for (int i = 0; i < SIZE; i++)
	{
		printf("%d ", a[i]);
	}
	printf("\n");
	printf("Matrix: \n");
	for (int i = 0; i < SIZE; i++)
	{
		for (int j = 0; j < SIZE; j++)
		{
			printf("%d ", *(b + i*SIZE + j));
		}
		printf("\n");
	}
	printf("Product: \n");
	for (int i = 0; i < SIZE; i++)
	{
		printf("%d ", c[i]);
	}
	printf("\n");
	
	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	
	free(a);
	free(b);
	free(c);

	return 0;
}
