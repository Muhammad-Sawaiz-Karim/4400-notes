#include <stdio.h>
#define BLOCK_SIZE 16

//will be stored as row-major order. element calculated by row * [cols] + column
typedef struct
{
    int rows;
    int cols;
    float *elements;
} Matrix;

__global__ void kernel_call(Matrix d_A, Matrix d_B, Matrix d_C);
void multiply(const Matrix A, const Matrix B, Matrix C);

void multiply(const Matrix A, const Matrix B, Matrix C)
{
    //allocating matrix A. Same for B and C, except we don't copy over any elements to C.
    size_t a_size = sizeof(float) * A.rows * A.cols; 
    Matrix d_A;
    d_A.cols = A.cols;
    d_A.rows = A.rows;
    cudaMalloc(&d_A.elements, a_size);
    cudaMemcpy(d_A.elements, A.elements, a_size, cudaMemcpyHostToDevice);

    size_t b_size = sizeof(float) * B.rows * B.cols;
    Matrix d_B;
    d_B.cols = B.cols;
    d_B.rows = B.rows;
    cudaMalloc(&d_B.elements, b_size);
    cudaMemcpy(d_B.elements, B.elements, b_size, cudaMemcpyHostToDevice);

    size_t c_size = sizeof(float) * B.cols * A.rows;
    Matrix d_C;
    d_C.cols = B.cols;
    d_C.rows = A.rows;
    cudaMalloc(&d_C.elements, c_size);

    dim3 block(BLOCK_SIZE, BLOCK_SIZE);
    //this is a ceiling calculation. ensures enough blocks exist to compute the whole grid. 
    dim3 grid((d_C.cols + BLOCK_SIZE - 1) / BLOCK_SIZE, (d_C.rows + BLOCK_SIZE - 1) / BLOCK_SIZE);

    kernel_call<<<grid, block>>>(d_A, d_B, d_C);

    cudaMemcpy(C.elements, d_C.elements, c_size, cudaMemcpyDeviceToHost);

    cudaFree(d_A.elements);
    cudaFree(d_B.elements);
    cudaFree(d_C.elements);
}

__global__ void kernel_call(Matrix d_A, Matrix d_B, Matrix d_C)
{
    int global_row = blockDim.y * blockIdx.y + threadIdx.y; //global thread row ID
    int global_col = blockDim.x * blockIdx.x + threadIdx.x; //global thread col ID
    int start_id = global_row * (gridDim.x * blockDim.x) + global_col; //start ID for the grid-stride loop
    int stride = blockDim.x * blockDim.y * gridDim.y * gridDim.x; //total threads in the grid

    for (int i = start_id; i < d_C.cols * d_C.rows; i += stride)
    {
        int row = i / d_C.cols; //unpack row ID. This undoes the global_row * (gridDim.x * blockDim.x) part.
        int col = i % d_C.cols; //unpack col ID. This undoes the + global_col part.

        float c_value = 0.0f;
        for (int e = 0; e < d_A.cols; e++) //this loop will calculate the dot product of A's row and B's column
        {
            //calculating the dot product of each column and row in A, B and then assigning the value to c[row][col]
            c_value += d_A.elements[row * d_A.cols + e] * d_B.elements[e * d_B.cols + col];
        }
        d_C.elements[row * d_C.cols + col] = c_value;
    }
}

int main()
{
    // Seed random number generator
    srand((unsigned int)time(NULL));

    // 1. Initialize Matrix A (100 x 50)
    Matrix A;
    A.rows = 100;
    A.cols = 50;
    A.elements = (float*)malloc(A.rows * A.cols * sizeof(float));
    for(int i = 0; i < A.rows * A.cols; i++) 
        A.elements[i] = (float)(rand() % 101);

    // 2. Initialize Matrix B (50 x 100)
    Matrix B;
    B.rows = 50;
    B.cols = 100;
    B.elements = (float*)malloc(B.rows * B.cols * sizeof(float));
    for(int i = 0; i < B.rows * B.cols; i++) 
        B.elements[i] = (float)(rand() % 101);

    // 3. Initialize Matrix C (100 x 100)
    // The result of (100x50) * (50x100) is a (100x100) matrix
    Matrix C;
    C.rows = A.rows;
    C.cols = B.cols;
    C.elements = (float*)malloc(C.rows * C.cols * sizeof(float));

    printf("Multiplying A (%dx%d) and B (%dx%d)...\n", A.rows, A.cols, B.rows, B.cols);

    // 4. Run Multiplication
    multiply(A, B, C);

    // 5. Verify Results (Print top-left corner)
    printf("Multiplication Complete. Top-left 3x3 result:\n");
    for(int r = 0; r < 3; r++) {
        for(int c = 0; c < 3; c++) {
            printf("%.2f\t", C.elements[r * C.cols + c]);
        }
        printf("\n");
    }

    // 6. Free Host Memory
    free(A.elements);
    free(B.elements);
    free(C.elements);

    return 0;
}