#include<stdio.h>
#define SIZE 10

__global__ void MatrixMul(int a[], int b[], int c[], int n) 
{
	int tx = threadIdx.x;
	int ty = threadIdx.y;

	int result = 0;

    	for(int i = 0; i < SIZE ; i++) 
    	{
        	int p = *(a + ty*SIZE + i);
        	int q = *(b + i*SIZE + tx);
        	result = result + (p*q);
    	}

    	*(c + ty*SIZE + tx) = result;
}
int main() 
{    
	time_t t;
	srand((unsigned) time(&t));
	
	int *a, *b, *c;
	
	a = (int*)malloc(SIZE * SIZE * sizeof(int));
	b = (int*)malloc(SIZE * SIZE * sizeof(int));
	c = (int*)malloc(SIZE * SIZE * sizeof(int));
	
    	for(int i = 0; i < SIZE ; i++) 
    	{
        	for(int j = 0; j < SIZE ; j++) 
        	{
        		*(a + i*SIZE + j) = i;
        		*(b + i*SIZE + j) = i+1;
        	}
    	}
    
	int *d_a, *d_b, *d_c;

    	cudaMalloc(&d_a, SIZE * SIZE * sizeof(int));
    	cudaMalloc(&d_b, SIZE * SIZE * sizeof(int));
    	cudaMalloc(&d_c, SIZE * SIZE * sizeof(int));
    	
    	cudaMemcpy(d_a, a, SIZE * SIZE * sizeof(int), cudaMemcpyHostToDevice);
    	cudaMemcpy(d_b, b, SIZE * SIZE * sizeof(int), cudaMemcpyHostToDevice);

	dim3 thread_b(SIZE,SIZE,1);
    	MatrixMul <<<1, thread_b>>> (d_a, d_b, d_c, SIZE);
    	
    	cudaDeviceSynchronize();

    	cudaMemcpy(c, d_c, SIZE * SIZE * sizeof(int), cudaMemcpyDeviceToHost);
    
    	printf("1st matrix: \n");
	for (int i = 0; i < SIZE; i++)
	{
		for(int j = 0; j < SIZE; j++)
		{
			printf("%d ", *(a + i*SIZE + j));
		}
		printf("\n");
	}
	printf("2nd matrix: \n");
	for (int i = 0; i < SIZE; i++)
	{
		for(int j = 0; j < SIZE; j++)
		{
			printf("%d ", *(b + i*SIZE + j));
		}
		printf("\n");
	}
	printf("Product: \n");
	for (int i = 0; i < SIZE; i++)
	{
		for(int j = 0; j < SIZE; j++)
		{
			printf("%d ", *(c + i*SIZE + j));
		}
		printf("\n");
	}

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);
	
	free(a);
	free(b);
	free(c);

   
    	return 0;
}
