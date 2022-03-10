#include <stdio.h>
#include <math.h>

__global__ void kernel(double *n, bool *result, double *count) {
    *result = true;

    while (*n != 1)
    {
        // perform modulo
        // a - (a / b) * b => a % b
        if ((*n - (*n / 2) * 2) == 0)
        {
            *n = *n / 2;
        }
        else
        {
            *n = *n * 3;
            *n = *n + 1;
        }

        *count = *count + 1;
    }
}

int main() {
    // Host copies
    double n;
    bool result;
    double count;

    // CUDA Device copies
    double *n_ptr;
    bool *result_ptr;
    double *count_ptr;
    
    cudaMalloc(&n_ptr, sizeof(double));
    cudaMalloc(&result_ptr, sizeof(bool));
    cudaMalloc(&count_ptr, sizeof(double));

    // nums to add
    n = 4;

    // copy to device
    cudaMemcpy(n_ptr, &n, sizeof(double1), cudaMemcpyHostToDevice);
    
    // start
    kernel<<<1, 1>>>(n_ptr, result_ptr, count_ptr);

    // copy result from device
    cudaMemcpy(&result, result_ptr, sizeof(bool), cudaMemcpyDeviceToHost);
    cudaMemcpy(&count, count_ptr, sizeof(double), cudaMemcpyDeviceToHost);

    printf("%lf: %d | with %lf operations\n", n, result, count);

    cudaDeviceSynchronize();
    cudaError_t error = cudaGetLastError();
    if(error != cudaSuccess)
    {
        fprintf(stderr,"ERROR: %s\n", cudaGetErrorString(error) );
        exit(-1);
    }

    return 0;
}