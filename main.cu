#include <stdio.h>

__global__ void kernel(int *num1, int *num2, int *result) {
    *result = *num1 + *num2;
}

// 3n+1 problem:
// 
//
//

int main() {
    // Host copies
    int result, num1, num2;

    // CUDA Device copies
    int *result_ptr, *num1_ptr, *num2_ptr;
    
    cudaMalloc(&num1_ptr, sizeof(int));
    cudaMalloc(&num2_ptr, sizeof(int));
    cudaMalloc(&result_ptr, sizeof(int));

    // nums to add
    num1 = 2;
    num2 = 6;

    // copy to device
    cudaMemcpy(num1_ptr, &num1, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(num2_ptr, &num2, sizeof(int), cudaMemcpyHostToDevice);
    
    // start
    kernel<<<1, 1>>>(num1_ptr, num2_ptr, result_ptr);

    // copy result from device
    cudaMemcpy(&result, result_ptr, sizeof(int), cudaMemcpyDeviceToHost);

    printf("%d\n", result);

    cudaDeviceSynchronize();
    cudaError_t error = cudaGetLastError();
    if(error!=cudaSuccess)
    {
        fprintf(stderr,"ERROR: %s\n", cudaGetErrorString(error) );
        exit(-1);
    }

    return 0;
}